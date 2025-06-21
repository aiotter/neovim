{ vim-dichromatic }: {
  plugin = vim-dichromatic;
  config = ''
    colorscheme dichromatic

    highlight SpellBad NONE
    highlight SpellBad gui=undercurl
  '';
}
