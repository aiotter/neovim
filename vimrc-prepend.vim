set encoding=utf-8
scriptencoding utf-8
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"


" ----- LSP ----- 
" cf. configuration for vim-which-key
" Execute default K by gK
nnoremap gK K

" Hover definition (invoke with K)
nmap K <cmd>lua vim.lsp.buf.hover()<CR>

lua <<EOF
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Jump to definition
  vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, { noremap=true, silent=true, buffer=bufnr })
end

local lspconfig = require("lspconfig")
lspconfig.util.default_config = vim.tbl_deep_extend(
  "force",
  lspconfig.util.default_config,
  {
    on_attach = on_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
  }
)

local handlers = require("vim.lsp.handlers")
handlers["textDocument/hover"] = vim.lsp.with(handlers.hover, { border = "single" })

vim.diagnostic.config({
  severity_sort = true,
  float = { source = true },
})

-- require("vim.lsp.log").set_level(vim.log.levels.DEBUG)
EOF
