{ oil-nvim }: {
  plugin = oil-nvim;
  config = ''
    lua <<EOF
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
        cleanup_delay_ms = 20000, -- https://github.com/stevearc/oil.nvim/issues/517
      })
    EOF
  '';
}
