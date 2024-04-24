{ ultimate-autopair-nvim }: {
  plugin = ultimate-autopair-nvim;
  config = ''
    lua <<EOF
      require("ultimate-autopair").setup({})
    EOF
  '';
}
