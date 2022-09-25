{ vim-matchup }: {
  plugin = vim-matchup;
  config = ''
    lua <<EOF
    require'nvim-treesitter.configs'.setup {
      matchup = {
        enable = true,  -- mandatory, false will disable the whole extension
        disable = { },  -- optional, list of language that will be disabled
        -- [options]
      },
    }
    EOF
  '';
}
