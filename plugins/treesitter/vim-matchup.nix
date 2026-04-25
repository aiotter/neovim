{ vim-matchup }: {
  plugin = vim-matchup;
  config.lua = ''
    vim.g.matchup_treesitter_enabled = true
  '';
}
