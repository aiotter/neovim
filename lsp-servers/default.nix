# Available servers: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
{ pkgs }:

let
  tailwindcss-lsp = (import ./tailwindcss { inherit pkgs; })."@tailwindcss/language-server";
  sourcekitPath = if pkgs.stdenv.isDarwin then "sourcekit-lsp" else "${pkgs.swift}/bin/sourcekit-lsp";
in

''
  lua <<EOF
  local lspconfig = require("lspconfig")
  local util = require("lspconfig.util")

  lspconfig.rnix.setup { cmd = { "${pkgs.rnix-lsp}/bin/rnix-lsp" } }
  lspconfig.sourcekit.setup { cmd = { "${sourcekitPath}" } }
  lspconfig.zls.setup { cmd = { "${pkgs.zls}/bin/zls" } }

  lspconfig.tailwindcss.setup {
    cmd = { "${tailwindcss-lsp}/bin/tailwindcss-language-server", "--stdio" } }

  lspconfig.denols.setup {
    cmd = { "${pkgs.deno}/bin/deno", "lsp" },
    init_options = { importMap = vim.fn.findfile("import_map.json", vim.api.nvim_buf_get_name(0) .. ";") and vim.fn.fnamemodify(vim.fn.findfile("import_map.json", vim.api.nvim_buf_get_name(0) .. ";"), ":p") },
  }
  EOF
''
