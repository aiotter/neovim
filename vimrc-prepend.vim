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

vim.api.nvim_create_user_command("LspCapabilities", function()
  local curBuf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients { bufnr = curBuf }

  for _, client in pairs(clients) do
    if client.name ~= "null-ls" then
      local capAsList = {}
      for key, value in pairs(client.server_capabilities) do
        if value and key:find("Provider") then
          local capability = key:gsub("Provider$", "")
          table.insert(capAsList, "- " .. capability)
        end
      end
      table.sort(capAsList) -- sorts alphabetically
      local msg = "# " .. client.name .. "\n" .. table.concat(capAsList, "\n")
      vim.notify(msg, "trace", {
        on_open = function(win)
          local buf = vim.api.nvim_win_get_buf(win)
          vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
        end,
        timeout = 14000,
      })
      vim.fn.setreg("+", "Capabilities = " .. vim.inspect(client.server_capabilities))
    end
  end
end, {})

-- require("vim.lsp.log").set_level(vim.log.levels.DEBUG)
EOF
