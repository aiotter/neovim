# Available servers: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
{ nvim-lspconfig
, rnix-lsp
, zls
, deno
}:

{
  plugin = nvim-lspconfig;
  config = ''
    lua <<EOF
    local lspconfig = require("lspconfig")

    lspconfig.rnix.setup { cmd = { "${rnix-lsp}/bin/rnix-lsp"} }
    lspconfig.zls.setup { cmd = { "${zls}/bin/zls" } }

    lspconfig.denols.setup {
      cmd = { "${deno}/bin/deno", "lsp" },
      init_options = { importMap = vim.fn.findfile("import_map.json", vim.api.nvim_buf_get_name(0) .. ";") and vim.fn.fnamemodify(vim.fn.findfile("import_map.json", vim.api.nvim_buf_get_name(0) .. ";"), ":p") },
    }
    EOF
  '';
}
