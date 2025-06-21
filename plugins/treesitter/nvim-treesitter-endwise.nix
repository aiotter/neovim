{ nvim-treesitter-endwise }: {
  plugin = nvim-treesitter-endwise;
  config.lua = ''
    require('nvim-treesitter.configs').setup {
        endwise = {
            enable = true,
        },
    }
  '';
}
