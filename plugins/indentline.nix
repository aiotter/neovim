# Show indent depth
{ indentLine }: {
  plugin = indentLine;
  config = ''
    let g:indentLine_setConceal = 0
    " let g:indentLine_setColors = 0
    " let g:indentLine_char = '︳'
    " let g:indentLine_char = '⎜'
    let g:indentLine_char = '⎸'
    " let g:indentLine_char = '꜏'
  '';
}
