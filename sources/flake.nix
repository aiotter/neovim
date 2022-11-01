{
  description = "Neovim plugin sources";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    # Fix for https://github.com/NixOS/nixpkgs/pull/192733
    nixpkgs.url = "github:ilkecan/nixpkgs/buildVimPlugin-prevent-building-two-times";
    flake-utils.url = "github:numtide/flake-utils";

    vim-cheatsheet = { url = "github:reireias/vim-cheatsheet"; flake = false; };
    vim-dichromatic = { url = "github:romainl/vim-dichromatic"; flake = false; };
    vim-precious = { url = "github:osyo-manga/vim-precious"; flake = false; };
    vim-mdx-js = { url = "github:jxnblk/vim-mdx-js"; flake = false; };
    vim-textobj-indent = { url = "github:kana/vim-textobj-indent"; flake = false; };
    vim-textobj-line = { url = "github:kana/vim-textobj-line"; flake = false; };
    vim-textobj-parameter = { url = "github:sgur/vim-textobj-parameter"; flake = false; };
    vim-textobj-underscore = { url = "github:lucapette/vim-textobj-underscore"; flake = false; };
    vim-textobj-uri = { url = "github:jceb/vim-textobj-uri"; flake = false; };
    vim-textobj-word-column = { url = "github:idbrii/textobj-word-column.vim"; flake = false; };
    vim-quickrun = { url = "github:thinca/vim-quickrun"; flake = false; };
    spelunker-vim = { url = "github:kamykn/spelunker.vim"; flake = false; };
    popup-menu-nvim = { url = "github:kamykn/popup-menu.nvim"; flake = false; };
    vimdoc-ja = { url = "github:vim-jp/vimdoc-ja"; flake = false; };
    vim-emacs-bindings = { url = "github:kentarosasaki/vim-emacs-bindings"; flake = false; };
    vim-emacscommandline = { url = "github:houtsnip/vim-emacscommandline"; flake = false; };
    vim-fugitive-blame-ext = { url = "github:tommcdo/vim-fugitive-blame-ext"; flake = false; };
    denops-vim = { url = "github:vim-denops/denops.vim"; flake = false; };
    askpass-vim = { url = "github:lambdalisue/askpass.vim"; flake = false; };
    vim-tmux-yank = { url = "github:jabirali/vim-tmux-yank"; flake = false; };
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs:
    # Deno is not supported on i686-linux
    with flake-utils.lib; eachSystem (nixpkgs.lib.lists.remove system.i686-linux defaultSystems) (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        vimPlugins = pkgs.vimPlugins;
        buildSimpleVimPlugins = builtins.mapAttrs (name: src: pkgs.vimUtils.buildVimPlugin { inherit name src; });
        myVimPlugins = self: buildSimpleVimPlugins (pkgs.lib.attrsets.filterAttrs (name: _: name != "nixpkgs" && name != "flake-utils" && name != "self") inputs);
        overrides = self: super: {
          vim-precious = super.vim-precious.overrideAttrs (old: { dependencies = [ vimPlugins.context_filetype-vim ]; });
          vim-textobj-indent = super.vim-textobj-indent.overrideAttrs (old: { dependencies = [ vimPlugins.vim-textobj-user ]; });
          vim-textobj-line = super.vim-textobj-line.overrideAttrs (old: { dependencies = [ vimPlugins.vim-textobj-user ]; });
          vim-textobj-parameter = super.vim-textobj-parameter.overrideAttrs (old: { dependencies = [ vimPlugins.vim-textobj-user ]; });
          vim-textobj-underscore = super.vim-textobj-underscore.overrideAttrs (old: { dependencies = [ vimPlugins.vim-textobj-user ]; });
          vim-textobj-uri = super.vim-textobj-uri.overrideAttrs (old: { dependencies = [ vimPlugins.vim-textobj-user ]; });
          vim-textobj-word-column = super.vim-textobj-word-column.overrideAttrs (old: { dependencies = [ vimPlugins.vim-textobj-user ]; });
          vim-quickrun = super.vim-quickrun.overrideAttrs (old: { dependencies = [ vimPlugins.vimproc-vim ]; });
          spelunker-vim = super.spelunker-vim.overrideAttrs (old: { dependencies = [ self.popup-menu-nvim ]; });
          vim-fugitive-blame-ext = super.vim-fugitive-blame-ext.overrideAttrs (old: { dependencies = [ vimPlugins.vim-fugitive ]; });
          denops-vim = super.denops-vim.overrideAttrs (old: {
            dontBuild = true;
            patchPhase = ''
              sed -i "s%call s:define('denops#deno', 'deno')%call s:define('denops#deno', '${pkgs.deno}/bin/deno')%" autoload/denops.vim
            '';
            buildInputs = [ pkgs.deno ];
          });
          askpass-vim = super.askpass-vim.overrideAttrs (old: {
            dontBuild = true;
            dontPatchShebangs = true;
            preFixup = ''
              sed -i '1 s#deno#${pkgs.deno}/bin/deno#' $out/denops/askpass/cli.ts
            '';
            dependencies = [ self.denops-vim ];
          });
        };
      in
      { packages = with pkgs.lib; recurseIntoAttrs (fix (extends overrides myVimPlugins)); });
}
