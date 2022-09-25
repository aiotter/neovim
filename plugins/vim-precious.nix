# Syntax highlight code blocks
{ vim-precious }: {
  plugin = vim-precious;
  config = ''
    " Only changes syntax; not filetype
    let g:precious_enable_switchers = { "*" : { "setfiletype" : 0 } }
    augroup vim_precious
      autocmd!
      autocmd User PreciousFileType let &l:syntax = precious#context_filetype()
    augroup END
  '';
}
