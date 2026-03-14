{ vim-gitgutter }:
{
  plugin = vim-gitgutter;
  config.lua = ''
    vim.g.gitgutter_map_keys = 0

    vim.keymap.set("n", "<Leader>ghp", "<Plug>(GitGutterPreviewHunk)", { desc = "preview hunk" })
    vim.keymap.set({ "n", "x" }, "<Leader>ghs", "<Plug>(GitGutterStageHunk)", { desc = "stage hunk" })
    vim.keymap.set("n", "<Leader>ghu", "<Plug>(GitGutterUndoHunk)", { desc = "undo hunk" })
  '';
}
