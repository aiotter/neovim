{
  description = "Neovim with my favourite plugins";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    vim-plugins.url = "github:aiotter/neovim?dir=sources";
    vim-plugins.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, vim-plugins }: {
    overlays.default = final: prev: {
      neovim = self.packages.${prev.system}.default;
    };
  } // flake-utils.lib.eachSystem (builtins.attrNames vim-plugins.packages) (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      vimPlugins = pkgs.vimPlugins // vim-plugins.packages.${system};
      callVimPlugin = pkgs.lib.callPackageWith (vimPlugins // pkgs);
      allPlugins = map (fileName: callVimPlugin ./plugins/${fileName} { }) (builtins.attrNames (builtins.readDir ./plugins));
      neovimConfigOriginal = pkgs.neovimUtils.makeNeovimConfig {
        # beforePlugins = ""; # <- no such config for neovim
        customRC = builtins.readFile ./vimrc-append.vim;
        plugins = allPlugins;
      };
      neovimConfigFinal = neovimConfigOriginal // {
        neovimRcContent = builtins.concatStringsSep "\n\n" [
          (builtins.readFile ./vimrc-prepend.vim)
          (import ./lsp-servers { inherit pkgs; })
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
                let $PATH = s:venv_dir . '/bin:' . $PATH
              else
                let g:python3_host_prog = '${python3}/bin/python3'
              endif
            ''
          )
        ];
        wrapperArgs = neovimConfigOriginal.wrapperArgs ++ [ "--add-flags" ''--cmd "set rtp^=${./runtime}"'' ];
      };
    in
    rec {
      packages.default = with pkgs; wrapNeovimUnstable neovim-unwrapped neovimConfigFinal;
    }
  );
}
