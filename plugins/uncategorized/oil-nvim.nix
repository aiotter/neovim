{ oil-nvim }: {
  plugin = oil-nvim;
  config.lua = ''
    require("oil").setup({
      keymaps = {
        ["<S-CR>"] = { "actions.select", opts = { tab = true } },
      },
      columns = {"icon", "permissions"},
      view_options = {
        show_hidden = true,
        is_hidden_file = function(name, bufnr)
          return name ~= ".." and vim.startswith(name, ".")
        end,
      },
      cleanup_delay_ms = false, -- https://github.com/stevearc/oil.nvim/issues/517
    })
  '';
}
