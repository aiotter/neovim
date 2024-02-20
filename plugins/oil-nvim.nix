{ oil-nvim }: {
  plugin = oil-nvim;
  config = ''
    lua <<EOF
      require("oil").setup({
        columns = {"icon", "permissions"},
        view_options = {
          show_hidden = true,
          is_hidden_file = function(name, bufnr)
            return name ~= ".." and vim.startswith(name, ".")
          end,
        }
      })
    EOF
  '';
}
