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
        vimPlugins = pkgs.vimPlugins // vim-plugins.packages.${system};
        callVimPlugin = pkgs.lib.callPackageWith (vimPlugins // pkgs);
        allPlugins = map
          (fileName: pkgs.lib.filterAttrs (n: _: builtins.elem n [ "plugin" "config" "optional" ]) (callVimPlugin ./plugins/${fileName} { }))
          (builtins.attrNames (builtins.readDir ./plugins));
        lspServers = import ./lsp-servers { inherit pkgs; };
        additionalPath = "${pkgs.symlinkJoin { name = "plugins"; paths = lspServers.packages; }}/bin";

        neovimConfigOriginal = pkgs.neovimUtils.makeNeovimConfig {
          customRC = builtins.readFile ./vimrc-append.vim;
          plugins = [
            # dummy plugin to read vimrc-prepend.vim at the beginning
            { plugin = pkgs.hello; config = builtins.readFile ./vimrc-prepend.vim; }
          ] ++ allPlugins;
        };
        neovimConfigFinal = neovimConfigOriginal // {
          neovimRcContent = builtins.concatStringsSep "\n\n" [
            lspServers.neovimConfig
            (neovimConfigOriginal.neovimRcContent)
            (
              let
                python3 = pkgs.python3.withPackages (pkgs: [ pkgs.pynvim ]);
              in
              ''
                if exists("$VIRTUAL_ENV")
                  let g:python3_host_prog = $VIRTUAL_ENV . '/bin/python'

                  " Install pynvim if absent
                  if system(g:python3_host_prog . ' -c "' . "import importlib.util; print(importlib.util.find_spec('pynvim') is None)" . '"') =~ '^True'
                    call system(g:python3_host_prog . ' -m pip --disable-pip-version-check install pynvim')
                  endif

                  " config for QuickRun
                  let $PATH = $VIRTUAL_ENV . '/bin:' . $PATH
                else
                  let g:python3_host_prog = '${python3}/bin/python3'
                endif
              ''
            )
          ];
          wrapperArgs = neovimConfigOriginal.wrapperArgs
            ++ [ "--add-flags" ''--cmd "set rtp^=${./runtime}"'' "--prefix" "PATH" ":" additionalPath ];
        };
      in
      pkgs.wrapNeovimUnstable neovim-unwrapped neovimConfigFinal;

    overlays.default = final: prev: {
      neovim = self.packages.${prev.system}.default;
    };

    packages = builtins.mapAttrs
      (system: _:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          neovim-unwrapped = pkgs.neovim-unwrapped.overrideAttrs {
            src = neovim;
            doInstallCheck = false;
            patches = pkgs.fetchpatch {
              url = "https://github.com/neovim/neovim/pull/33421.patch";
              hash = "sha256-+llX3rfNMx5C89+kkxvxviafHdBBjOvs/shze9f79PE=";
              revert = true;
            };
          };
        in
        { default = self.lib.makeCustomNeovim { inherit system neovim-unwrapped; }; })
      vim-plugins.packages;
  };

  # On Darwin, sandbox must be off
  # https://github.com/NixOS/nix/issues/4119
  # https://github.com/NixOS/nix/pull/12570
  nixConfig.sandbox = false;
}
