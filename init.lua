vim.o.exrc = true
vim.o.secure = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.timeoutlen = 500

vim.keymap.set("n", "<Leader>f", ":let &filetype=input('Enter filetype: ')<CR>")

vim.o.encoding = "utf-8"
vim.opt.fileencodings = { "ucs-boms", "utf-8", "euc-jp", "cp932" }
vim.opt.fileformats = { "unix", "dos", "mac" }
vim.o.showmatch = true

vim.opt.clipboard = { "unnamedplus" }

vim.o.list = true
vim.opt.listchars = {
  tab = "▸  ",
  eol = "↲",
  extends = "»",
  precedes = "«",
}
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  command = [[
    highlight NonText    ctermbg=NONE ctermfg=238 guibg=NONE guifg='#444444'
    highlight SpecialKey ctermbg=NONE ctermfg=238 guibg=NONE guifg='#444444'
  ]],
})

-- conceal
vim.o.conceallevel = 1
vim.api.nvim_create_autocmd({ "ColorSchemePre" }, { command = "highlight clear Conceal" })
vim.g.markdown_syntax_conceal = 0

-- tabs and indents
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = -1  -- use shiftwidth
vim.o.shiftwidth = 0  -- use tabstop
vim.o.autoindent = true
vim.o.preserveindent = true
vim.o.copyindent = true

-- search
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.keymap.set("n", "<Esc><Esc>", ":<C-u>set hlsearch!<CR>", { silent = true })

-- cursor
vim.o.whichwrap = "b,s,h,l,<,>,[,],~"
vim.o.number = true
vim.o.cursorline = true
vim.o.scrolloff = 5
vim.opt.backspace = { "indent", "eol", "start" }
vim.o.mouse = "a"
vim.keymap.set("n", "<C-b>", "h")
vim.keymap.set("n", "<C-n>", "j")
vim.keymap.set("n", "<C-p>", "k")
vim.keymap.set("n", "<C-f>", "l")

-- auto close quickfix
vim.api.nvim_create_augroup("QFClose", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter" }, {
  group = "QFClose",
  command = "if winnr('$') == 1 && &buftype == 'quickfix'|q|endif",
})

-- floating window
vim.cmd([[highlight NormalFloat guifg=#eceff4 guibg=#1e1e1e ctermbg=235]])

-- status line
vim.o.laststatus = 2
vim.o.showmode = false
vim.o.showcmd = true
vim.o.ruler = true

-- sign column
vim.o.signcolumn = "yes"

-- spell check
vim.o.spell = true
vim.opt.spelllang = { "en", "cjk" }
vim.opt.spelloptions = { "camel" }
vim.o.spellcapcheck = ""

-- completion
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }

-- https://vi.stackexchange.com/questions/19953/why-doesnt-this-autocmd-take-effect-for-neovim/19963
vim.opt.shortmess:remove { "F" }

-- LSP
vim.keymap.set("n", "gK", "K")
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
  end)
end, { buffer = true })

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
