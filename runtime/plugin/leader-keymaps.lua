vim.keymap.set("n", "<Leader>c", "<Cmd>Cheat<CR>", { desc = "cheatsheet" })
vim.keymap.set("n", "<Leader>d", "<Cmd>Vista!!<CR>", { desc = "definitions" })
vim.keymap.set("n", "<Leader>f", ":let &filetype=input('Enter filetype: ')<CR>", { desc = "file type" })
vim.keymap.set("n", "<Leader>q", "<Cmd>QuickRun<CR>", { desc = "quickRun" })

-- LSP
vim.keymap.set("n", "<LocalLeader>la", "<Cmd>CodeActionMenu<CR>", { desc = "code action" })
vim.keymap.set("n", "<LocalLeader>li", vim.lsp.buf.implementation, { desc = "implementation" })
vim.keymap.set("n", "<LocalLeader>lR", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<LocalLeader>ld", vim.diagnostic.open_float, { desc = "diagnostics (line)" })
vim.keymap.set("n", "<LocalLeader>lf", vim.lsp.buf.format, { desc = "format" })
vim.keymap.set("n", "<LocalLeader>lr", vim.lsp.buf.references, { desc = "references" })

-- Git
vim.keymap.set("n", "<LocalLeader>gB", "<Cmd>GBrowse<CR>", { desc = "browse" })
vim.keymap.set("n", "<LocalLeader>ga", "<Cmd>Git add %:p<CR>", { desc = "add" })
vim.keymap.set("n", "<LocalLeader>gb", "<Cmd>Git blame<CR>", { desc = "blame" })
vim.keymap.set("n", "<LocalLeader>gc", "<Cmd>Git commit<CR>", { desc = "commit" })
vim.keymap.set("n", "<LocalLeader>gd", "<Cmd>Git diff<CR>", { desc = "diff" })
vim.keymap.set("n", "<LocalLeader>gl", "<Cmd>Gclog<CR>", { desc = "log" })
vim.keymap.set("n", "<LocalLeader>gp", "<Cmd>Git push<CR>", { desc = "push" })
vim.keymap.set("n", "<LocalLeader>gs", "<Cmd>Git<CR>", { desc = "status" })
