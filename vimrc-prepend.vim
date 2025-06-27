set encoding=utf-8
scriptencoding utf-8
set exrc secure
let g:mapleader = "\<Space>"
let g:maplocalleader = "\<Space>"


" ----- LSP ----- 
" cf. configuration for vim-which-key
" Execute default K by gK
nnoremap gK K

lua <<EOF
-- Hover definition (invoke with K)
vim.keymap.set("n", "K", function()
  vim.lsp.buf.hover({ border = "single" })

  local bufnr = vim.api.nvim_get_current_buf()
  vim.keymap.set("n", "<ESC>", function()
    local winid = vim.b[bufnr].lsp_floating_preview
    if vim.api.nvim_win_is_valid(winid) then
      vim.api.nvim_win_close(winid, false)
    else
      vim.keymap.del("n", "<ESC>", { buffer = true })
      vim.cmd.normal("\\<Esc>")
    end
  end, { buffer = true })
end)

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

vim.diagnostic.config({
  severity_sort = true,
  float = { source = true },
})

vim.api.nvim_create_user_command("LspCapabilities", function()
  local curBuf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { bufnr = curBuf }

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

-- Close floating window by ESC
vim.keymap.set('n', '<Esc>', function()
  if vim.api.nvim_win_get_config(0).relative ~= "" then
    vim.cmd.wincmd('c')
  else
    vim.cmd.normal("\\<Esc>")
  end
end)

EOF
