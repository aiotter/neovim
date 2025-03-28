{ nvim-treesitter-endwise }: {
  plugin = nvim-treesitter-endwise;
  config = ''
  lua <<EOF
    require('nvim-treesitter.configs').setup {
        endwise = {
            enable = true,
        },
    }
  EOF
  '';
}
