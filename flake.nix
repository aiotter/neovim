{
  description = "Neovim with my favourite plugins";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs.follows = "vim-plugins/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    vim-plugins.url = "github:aiotter/neovim?dir=sources";
    # vim-plugins.inputs.nixpkgs.follows = "nixpkgs";
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
      neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
        # beforePlugins = ""; # <- no such config for neovim
        customRC = builtins.readFile ./vimrc-append.vim;
        plugins = allPlugins;
      };
      neovimConfigWrapped = neovimConfig // {
        neovimRcContent = builtins.readFile ./vimrc-prepend.vim + import ./lsp-servers { inherit pkgs; } + neovimConfig.neovimRcContent;
      };
    in
    rec {
      packages.default = with pkgs; wrapNeovimUnstable neovim-unwrapped neovimConfigWrapped;
    }
  );
}
