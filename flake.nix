{
  description = "Neovim with my favourite plugins";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    neovim.url = "github:neovim/neovim/4e59422e1d4950a3042bad41a7b81c8db4f8b648";
    neovim.flake = false;
    vim-plugins.url = "github:aiotter/neovim?dir=sources";
    vim-plugins.inputs.nixpkgs.follows = "nixpkgs";
    nil.url = "github:oxalica/nil";
    nil.inputs.nixpkgs.follows = "nixpkgs";
    nil.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, neovim, vim-plugins, ... }@inputs: {
    overlays.default = final: prev: {
      neovim = self.packages.${prev.system}.default;
    };
  } // flake-utils.lib.eachSystem (builtins.attrNames vim-plugins.packages) (system:
    let
      overlays = with inputs; map (input: input.overlays.default) [ nil ];
      pkgs = import nixpkgs { inherit system overlays; };
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
                let $PATH = $VIRTUAL_ENV . '/bin:' . $PATH
              else
                let g:python3_host_prog = '${python3}/bin/python3'
              endif
            ''
          )
        ];
        wrapperArgs = neovimConfigOriginal.wrapperArgs ++ [ "--add-flags" ''--cmd "set rtp^=${./runtime}"'' ];
      };
      neovim-nightly-unwrapped = pkgs.neovim-unwrapped.overrideAttrs { src = neovim; };
    in
    {
      packages.default = with pkgs; wrapNeovimUnstable neovim-nightly-unwrapped neovimConfigFinal;
    }
  );
}
