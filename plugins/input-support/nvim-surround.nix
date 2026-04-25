{ nvim-surround }: {
  plugin = nvim-surround;
  config.lua = ''
    require("nvim-surround").setup()

    vim.g.nvim_surround_no_visual_mappings = true
    vim.keymap.set("x", "s", "<Plug>(nvim-surround-visual)", {
      desc = "Add a surrounding pair around a visual selection",
    })
    vim.keymap.set("x", "S", "<Plug>(nvim-surround-visual-line)", {
      desc = "Add a surrounding pair around a visual selection, on new lines",
    })
  '';
}
