{
  description = "Neovim plugin sources";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

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
    askpass-vim = { url = "github:lambdalisue/askpass.vim"; flake = false; };
  };

  outputs = { self, nixpkgs, ... }: {
    packages = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        addDeps = package: dependencies: package.overrideAttrs { inherit dependencies; };

        overlay = final: prev: with pkgs; {
          vim-precious = addDeps prev.vim-precious [ vimPlugins.context_filetype-vim ];
          vim-textobj-indent = addDeps prev.vim-textobj-indent [ vimPlugins.vim-textobj-user ];
          vim-textobj-line = addDeps prev.vim-textobj-line [ vimPlugins.vim-textobj-user ];
          vim-textobj-parameter = addDeps prev.vim-textobj-parameter [ vimPlugins.vim-textobj-user ];
          vim-textobj-underscore = addDeps prev.vim-textobj-underscore [ vimPlugins.vim-textobj-user ];
          vim-textobj-uri = addDeps prev.vim-textobj-uri [ vimPlugins.vim-textobj-user ];
          vim-textobj-word-column = addDeps prev.vim-textobj-word-column [ vimPlugins.vim-textobj-user ];
          vim-quickrun = addDeps prev.vim-quickrun [ vimPlugins.vimproc-vim ];
          spelunker-vim = addDeps prev.spelunker-vim [ final.popup-menu-nvim ];
          vim-fugitive-blame-ext = addDeps prev.vim-fugitive-blame-ext [ vimPlugins.vim-fugitive ];

          askpass-vim = prev.askpass-vim.overrideAttrs {
            dontBuild = true;
            dontPatchShebangs = true;
            preFixup = ''
              sed -i '1 s#deno#${pkgs.deno}/bin/deno#' $out/denops/askpass/cli.ts
            '';
            dependencies = [ vimPlugins.denops-vim ];
          };
        };
      in
      builtins.removeAttrs self.inputs ["nixpkgs"]
      |> builtins.mapAttrs (pname: src: pkgs.vimUtils.buildVimPlugin { inherit pname src; version = src.shortRev; })
      |> pkgs.lib.toFunction
      |> pkgs.lib.extends overlay
      |> pkgs.lib.fix
    );
  };
}
