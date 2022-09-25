{
  description = "Neovim with my favourite plugins";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    vim-plugins.url = "path:./sources";
    # vim-plugins.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, vim-plugins }:
    flake-utils.lib.eachDefaultSystem (system:
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
          neovimRcContent = builtins.readFile ./vimrc-prepend.vim + neovimConfig.neovimRcContent;
        };
      in
      rec {
        packages.default = with pkgs; wrapNeovimUnstable neovim-unwrapped neovimConfigWrapped;
      }
    );
}
