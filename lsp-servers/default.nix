# Available servers:
# https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

# LS for Rust is configured at rust-tools-nvim plugin configuration

{ pkgs, pkgsNoAliases }:

let
  inherit (pkgs) lib;

  erlls = pkgs.callPackage ./packages/erlls { };
  # next-ls = pkgs.callPackage ./packages/next-ls {};

  elixirls = pkgs.fetchzip {
    url = "https://github.com/elixir-lsp/elixir-ls/releases/download/v0.30.0/elixir-ls-v0.30.0.zip";
    hash = "sha256-q5rVLrG5T1v+tc6zc0/pvuaEDpftQE4hYmSq0OAM2Ws=";
    stripRoot = false;
  };

  # lexical = (pkgs.lexical.override { beamPackages = pkgs.beam.packages.erlang_25; }).overrideAttrs (prev: {
  #   postInstall = ''
  #     rm $out/bin/activate_version_manager.sh
  #     substituteInPlace "$out/bin/start_lexical.sh" --replace 'elixir_command=' 'elixir_command="${pkgs.beam.packages.erlang_25.elixir_1_14}/bin/"'
  #   '';
  #   dontFixup = true;
  # });

  # tailwindcss-lsp = (import ./packages/tailwindcss { inherit pkgs; })."@tailwindcss/language-server";

  # sourcekitPath = if pkgs.stdenv.isDarwin then "sourcekit-lsp" else "${pkgs.swift}/bin/sourcekit-lsp";
  # add this below: lspconfig.sourcekit.setup { cmd = { "${sourcekitPath}" } }

  pylsp = pkgs.python3.withPackages (
    ps: with ps; [ python-lsp-server pyls-isort /** pylsp-mypy **/ ]
      ++ (with python-lsp-server.optional-dependencies; builtins.concatLists [ pycodestyle autopep8 ])
  );

  haskell-language-server = pkgs.haskell-language-server.override {
    supportedFormatters = [ "fourmolu" ];

    # latest 4 versions
    supportedGhcVersions =
      pkgsNoAliases.haskell.packages
      |> lib.attrsToList
      |> lib.sort (a: b: lib.versionOlder (b.value.ghc.version or "") (a.value.ghc.version or ""))
      |> builtins.foldl' (
        acc: elem:
        if
          acc == [ ]
          || (
            lib.versions.majorMinor elem.value.ghc.version or ""
            != lib.versions.majorMinor (builtins.head acc).value.ghc.version or ""
          )
        then
          [ elem ] ++ acc
        else
          acc
      ) [ ]
      |> builtins.foldl' (
        acc:
        { name, value }:
        let
          match = builtins.match "ghc([0-9]+)" name;
        in
        if (lib.isList match) && value.haskell-language-server.meta.available then acc ++ match else acc
      ) [ ]
      |> lib.takeEnd 4;
  };
in

{
  packages = builtins.concatLists [
    [ erlls pylsp haskell-language-server ]
    (with pkgs; [ gopls pyright terraform-ls nixd nixfmt-rfc-style efm-langserver fortls deno tilt ])
    (with pkgs.nodePackages; [ prettier svelte-language-server typescript-language-server ])
  ];

  neovimConfig = ''
    lua <<EOF
    ${pkgs.lib.fileContents ./setup.lua}

    vim.lsp.config("elixirls", {
      cmd = { "sh", "${elixirls}/language_server.sh" }
    })

    vim.lsp.config("fortls", {
      cmd = {
        "${pkgs.fortls}/bin/fortls",
        "--config=${builtins.toFile ".fortls" (builtins.toJSON {
          notify_init = true;
          hover_signature = true;
          hover_language = "fortran";
          # use_signature_help = true;
          lowercase_intrinsics = true;
          disable_autoupdate = true;
        })}"
      },
    })
    EOF
  '';
}
