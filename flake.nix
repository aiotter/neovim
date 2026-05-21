{
  description = "Neovim with my favourite plugins";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    neovim.url = "github:neovim/neovim";
    neovim.flake = false;
    vim-plugins.url = "path:./sources";
    vim-plugins.inputs.nixpkgs.follows = "nixpkgs";
    nil.url = "github:oxalica/nil";
    nil.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, neovim, vim-plugins, ... }@inputs: {
    lib.makeCustomNeovim = { system, neovim-unwrapped }:
      let
        overlays = with inputs; [
          nil.overlays.default
          (import ./overlay.nix)
        ];

        pkgs = import nixpkgs { inherit system overlays; };
        pkgsNoAliases = import nixpkgs { inherit system overlays; config.allowAliases = false; };
        lspServers = import ./lsp-servers { inherit pkgs pkgsNoAliases; };
        lspRuntimeDir = pkgs.runCommand "runtime-lsp" { } "mkdir $out; ln -s ${./lsp-servers/configs} $out/lsp";
        runtimeDeps = with self.packages.${system}; [ read-prettier-config ];
      in
      pkgs.wrapNeovimUnstable neovim-unwrapped {
        plugins = import ./plugins { inherit pkgs; pluginPkgs = vim-plugins.packages.${system}; };

        # prepends to the generated init.lua
        luaRcContent = builtins.readFile ./init.lua;

        neovimRcContent = builtins.concatStringsSep "\n\n" [
          lspServers.neovimConfig
          (builtins.readFile ./vimrc.vim)
          ''
            if exists("$VIRTUAL_ENV")
              let g:python3_host_prog = $VIRTUAL_ENV . '/bin/python'

              " Install pynvim if absent
              if system(g:python3_host_prog . ' -c "' . "import importlib.util; print(importlib.util.find_spec('pynvim') is None)" . '"') =~ '^True'
                call system(g:python3_host_prog . ' -m pip --disable-pip-version-check install pynvim')
              endif

              " config for QuickRun
              let $PATH = $VIRTUAL_ENV . '/bin:' . $PATH
            endif
          ''
        ];

        wrapperArgs = [
          "--add-flags"
          ''--cmd "set rtp^=${./runtime}" --cmd "set rtp+=${lspRuntimeDir}"''
          "--prefix"
          "PATH"
          ":"
          (pkgs.symlinkJoin {
            name = "neovim-deps";
            paths = lspServers.packages ++ runtimeDeps;
            stripPrefix = "/bin";
          })
        ];
      };

    overlays.default = final: prev: {
      neovim = self.packages.${prev.system}.default;
    };

    packages = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) callPackage;

        neovim-unwrapped = pkgs.neovim-unwrapped.overrideAttrs {
          src = neovim;
          doInstallCheck = false;
        };
      in
      rec {
        default = pkgs.symlinkJoin {
          name = "neovim-customed";
          paths = [
            neovim
            neovim-remote
          ];
          meta.mainProgram = "nvim";
        };

        neovim = self.lib.makeCustomNeovim { inherit system neovim-unwrapped; };
        read-prettier-config = callPackage ./packages/read-prettier-config { };
        neovim-remote = callPackage ./packages/neovim-remote { flake = self.outPath; };
      }
    );
  };

  nixConfig = {
    extra-experimental-features = [ "pipe-operators" ];
  };
}
