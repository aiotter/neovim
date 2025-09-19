{ prettierrc-nvim }:
{
  plugin = prettierrc-nvim;
  optional = true;
  config.lua = ''
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "javascript", "typescript", "svelte" },
      group = vim.api.nvim_create_augroup("prettierrc-nvim-loader", {}),
      command = "packadd prettierrc-nvim",
    })
  '';
}
