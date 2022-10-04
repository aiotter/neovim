{ nvim-surround }: {
  plugin = nvim-surround;
  config = ''
    lua <<EOF
      require("nvim-surround").setup({})
    EOF
  '';
}
