# display the colours in the file (#rrggbb, #rgb, ...)
{ vim-hexokinase }: {
  plugin = vim-hexokinase;
  option = ''
    if &termguicolors
      autocmd VimEnter * :HexokinaseTurnOn
      let g:Hexokinase_optInPatterns = 'full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names'
      let g:Hexokinase_ftEnabled = ['html', 'less', 'r', 'sass', 'scss', 'stylus', 'vim', 'yaml']
    endif
  '';
}
