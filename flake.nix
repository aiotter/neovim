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
        overlays = with inputs; map (input: input.overlays.default) [ nil ];
        pkgs = import nixpkgs { inherit system overlays; };

        allPlugins = import ./plugins { inherit pkgs; pluginPkgs = vim-plugins.packages.${system}; };

        lspServers = import ./lsp-servers { inherit pkgs; };
        additionalPath = "${pkgs.symlinkJoin { name = "plugins"; paths = lspServers.packages; }}/bin";
        lspRuntimeDir = pkgs.runCommand "runtime-lsp" { } "mkdir $out; ln -s ${./lsp-servers/configs} $out/lsp";
      in
      pkgs.wrapNeovimUnstable neovim-unwrapped {
        plugins = [
          # dummy plugin to read vimrc-prepend.vim at the beginning
          { plugin = pkgs.hello; config = builtins.readFile ./vimrc-prepend.vim; }
        ] ++ allPlugins;

        neovimRcContent = builtins.concatStringsSep "\n\n" [
          lspServers.neovimConfig
          (builtins.readFile ./vimrc-append.vim)
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
          additionalPath
        ];
      };

    overlays.default = final: prev: {
      neovim = self.packages.${prev.system}.default;
    };

    packages = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        neovim-unwrapped = pkgs.neovim-unwrapped.overrideAttrs {
          src = neovim;
          doInstallCheck = false;
        };
      in
      {
        default = self.lib.makeCustomNeovim { inherit system neovim-unwrapped; };
      }
    );
  };

  nixConfig = {
    extra-experimental-features = [ "pipe-operators" ];
  };
}
