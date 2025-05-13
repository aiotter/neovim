{
  description = "Neovim plugin sources";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    vim-cheatsheet = { url = "github:reireias/vim-cheatsheet"; flake = false; };
    vim-dichromatic = { url = "github:romainl/vim-dichromatic"; flake = false; };
    vim-helm = { url = "github:towolf/vim-helm"; flake = false; };
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
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs:
    # Deno is not supported on i686-linux
    with flake-utils.lib; eachSystem (nixpkgs.lib.lists.remove system.i686-linux defaultSystems) (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        vimPlugins = pkgs.vimPlugins;
        buildSimpleVimPlugins = builtins.mapAttrs (pname: src: pkgs.vimUtils.buildVimPlugin { inherit pname src; version = src.shortRev; });
        myVimPlugins = self: buildSimpleVimPlugins (pkgs.lib.filterAttrs (name: _: ! builtins.elem name ["nixpkgs" "flake-utils" "self"]) inputs);
        addDeps = package: dependencies: package.overrideAttrs { inherit dependencies; };

        overrides = self: super: {
          vim-precious = addDeps super.vim-precious [ vimPlugins.context_filetype-vim ];
          vim-textobj-indent = addDeps super.vim-textobj-indent [ vimPlugins.vim-textobj-user ];
          vim-textobj-line = addDeps super.vim-textobj-line [ vimPlugins.vim-textobj-user ];
          vim-textobj-parameter = addDeps super.vim-textobj-parameter [ vimPlugins.vim-textobj-user ];
          vim-textobj-underscore = addDeps super.vim-textobj-underscore [ vimPlugins.vim-textobj-user ];
          vim-textobj-uri = addDeps super.vim-textobj-uri [ vimPlugins.vim-textobj-user ];
          vim-textobj-word-column = addDeps super.vim-textobj-word-column [ vimPlugins.vim-textobj-user ];
          vim-quickrun = addDeps super.vim-quickrun [ vimPlugins.vimproc-vim ];
          spelunker-vim = addDeps super.spelunker-vim [ self.popup-menu-nvim ];
          vim-fugitive-blame-ext = addDeps super.vim-fugitive-blame-ext [ vimPlugins.vim-fugitive ];

          denops-vim = super.denops-vim.overrideAttrs {
            dontBuild = true;
            patchPhase = ''
              sed -i "s%call s:define('denops#deno', 'deno')%call s:define('denops#deno', '${pkgs.deno}/bin/deno')%" autoload/denops.vim
            '';
            buildInputs = [ pkgs.deno ];
          };

          askpass-vim = super.askpass-vim.overrideAttrs {
            dontBuild = true;
            dontPatchShebangs = true;
            preFixup = ''
              sed -i '1 s#deno#${pkgs.deno}/bin/deno#' $out/denops/askpass/cli.ts
            '';
            dependencies = [ self.denops-vim ];
          };
        };
      in
      { packages = with pkgs.lib; fix (extends overrides myVimPlugins); });
}
