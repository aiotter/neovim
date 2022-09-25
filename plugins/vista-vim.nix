{ vista-vim }: {
  plugin = vista-vim;
  config = ''
    nnoremap <silent> <Leader>d :<C-u>Vista!!<CR>

    let g:vista_sidebar_width = 30
    let g:vista_echo_cursor_strategy = 'floating_win'
    let g:vista#renderer#enable_icon = 1
    " let g:vista_default_executive = 'ctags'
    let g:vista_default_executive = 'nvim_lsp'

    " Close window after original buffer was closed
    augroup VistaClose
      au!
      au WinEnter * if winnr('$') == 1 && bufname() == "__vista__" |q|endif
    augroup END
  '';
}
