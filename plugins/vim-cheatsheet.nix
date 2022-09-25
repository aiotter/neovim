{ vim-cheatsheet }: {
  plugin = vim-cheatsheet;
  config = ''
    nnoremap <Leader>c :Cheat<CR>

    let g:cheatsheet#cheat_file = '~/.vim-cheatsheet.md'
    if has('nvim')
      let g:cheatsheet#float_window = 1
      let g:cheatsheet#float_window_width_ratio = 0.9
      let g:cheatsheet#float_window_height_ratio = 0.9
    endif
  '';
}
