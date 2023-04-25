# Available servers:
# https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

# LS for Rust is configured at rust-tools-nvim plugin configuration

{ pkgs }:

let
  tailwindcss-lsp = (import ./tailwindcss { inherit pkgs; })."@tailwindcss/language-server";
  sourcekitPath = if pkgs.stdenv.isDarwin then "sourcekit-lsp" else "${pkgs.swift}/bin/sourcekit-lsp";
in

''
  lua <<EOF
  local lspconfig = require("lspconfig")
  local util = require("lspconfig.util")

  lspconfig.eslint.setup { cmd = { "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-eslint-language-server", "--stdio" } }
  lspconfig.gopls.setup { cmd = { "${pkgs.gopls}/bin/gopls" } }
  lspconfig.rnix.setup { cmd = { "${pkgs.rnix-lsp}/bin/rnix-lsp" } }
  lspconfig.sourcekit.setup { cmd = { "${sourcekitPath}" } }
  lspconfig.zls.setup { cmd = { "${pkgs.zls}/bin/zls" } }

  lspconfig.fortls.setup { cmd = { "${pkgs.fortls}/bin/fortls", "--config=${builtins.toFile ".fortls" (builtins.toJSON {
      notify_init = true;
      hover_signature = true;
      hover_language = "fortran";
      # use_signature_help = true;
      lowercase_intrinsics = true;
      disable_autoupdate = true;
    })}" } }

  lspconfig.tailwindcss.setup {
    cmd = { "${tailwindcss-lsp}/bin/tailwindcss-language-server", "--stdio" } }

  lspconfig.denols.setup {
    cmd = { "${pkgs.deno}/bin/deno", "lsp" },
    init_options = { importMap = vim.fn.findfile("import_map.json", vim.api.nvim_buf_get_name(0) .. ";") and vim.fn.fnamemodify(vim.fn.findfile("import_map.json", vim.api.nvim_buf_get_name(0) .. ";"), ":p") },
  }
  EOF
''
