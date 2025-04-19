# Available servers:
# https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

# LS for Rust is configured at rust-tools-nvim plugin configuration

{ pkgs }:

let
  erlls = pkgs.callPackage ./erlls { };
  # next-ls = pkgs.callPackage ./next-ls {};

  elixirls = pkgs.fetchzip {
    url = "https://github.com/elixir-lsp/elixir-ls/releases/download/v0.23.0/elixir-ls-v0.23.0.zip";
    hash = "sha256-bwYV2mgxgifZVX0qY2cl/gM/sWPCAGCrO3C/eKoTYV8=";
    stripRoot = false;
  };

  # lexical = (pkgs.lexical.override { beamPackages = pkgs.beam.packages.erlang_25; }).overrideAttrs (prev: {
  #   postInstall = ''
  #     rm $out/bin/activate_version_manager.sh
  #     substituteInPlace "$out/bin/start_lexical.sh" --replace 'elixir_command=' 'elixir_command="${pkgs.beam.packages.erlang_25.elixir_1_14}/bin/"'
  #   '';
  #   dontFixup = true;
  # });

  # tailwindcss-lsp = (import ./tailwindcss { inherit pkgs; })."@tailwindcss/language-server";

  # sourcekitPath = if pkgs.stdenv.isDarwin then "sourcekit-lsp" else "${pkgs.swift}/bin/sourcekit-lsp";
  # add this below: lspconfig.sourcekit.setup { cmd = { "${sourcekitPath}" } }

  pylsp = pkgs.python3.withPackages (
    ps: with ps; [ python-lsp-server pyls-isort /** pylsp-mypy **/ ]
      ++ (with python-lsp-server.optional-dependencies; builtins.concatLists [ pycodestyle autopep8 ])
  );
in

{
  packages = builtins.concatLists [
    [ erlls elixirls pylsp ]
    (with pkgs; [ gopls pyright terraform-ls nixd nixfmt-rfc-style efm-langserver fortls deno tilt ])
    (with pkgs.nodePackages; [ svelte-language-server typescript-language-server ])
  ];

  neovimConfig = ''
    lua <<EOF
    ${pkgs.lib.fileContents ./server_configurations.lua}
    ${pkgs.lib.fileContents ./setup.lua}

    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")


    lspconfig.elixirls.setup {
      cmd = { "sh", "${elixirls}/language_server.sh" },
      settings = {
        elixirLS = {
          dialyzerWarnOpts = { "no_missing_calls" },
        },
      },
    }

    -- lspconfig.lexical.setup {
    --   cmd = { "$${lexical}/bin/start_lexical.sh" },
    -- }

    local prettier = {
      formatCommand = "${pkgs.nodePackages.prettier}/bin/prettier --stdin-filepath ''${INPUT}",
      formatStdin = true,
    }

    lspconfig.efm.setup {
      settings = {
        rootMarkers = { ".prettierrc", ".git/" },
        languages = {
          javascript = { prettier },
          typescript = { prettier },
          html = { prettier },
        },
        -- logLevel = 4,
      },
      init_options = { documentFormatting = true },
      cmd = { "${pkgs.efm-langserver}/bin/efm-langserver" },
      filetypes = { "javascript", "typescript", "html" },
    }

    lspconfig.fortls.setup { cmd = { "${pkgs.fortls}/bin/fortls", "--config=${builtins.toFile ".fortls" (builtins.toJSON {
        notify_init = true;
        hover_signature = true;
        hover_language = "fortran";
        # use_signature_help = true;
        lowercase_intrinsics = true;
        disable_autoupdate = true;
      })}" } }
    EOF
  '';
}
