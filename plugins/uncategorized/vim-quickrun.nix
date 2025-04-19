{ vim-quickrun }: {
  plugin = vim-quickrun;
  config = ''
    nnoremap <Leader>q :<C-u>QuickRun<CR>

    let g:quickrun_config = {
    \ "python": {
    \   "outputter/quickfix/errorformat": '%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m'
    \ },
    \ "typescript": { "type": "typescript/deno" },
    \ "_": {
    \   "runner": "vimproc",
    \   "runner/vimproc/updatetime": 60,
    \   "outputter": "error",
    \   "outputter/error/success": exists('*win_execute') ? 'buffer' : 'buffer_legacy',
    \   "outputter/error/error": "quickfix",
    \   "outputter/buffer/split": ":botright 8sp",
    \   "outputter/buffer/close_on_empty": 1,
    \   "hook/time/enable": 1
    \ }
    \}

    " Stop QuickRun by Ctrl-C
    nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

    " Close window after original buffer was closed
    augroup QuickRunClose
      au!
      au WinEnter * if winnr('$') == 1 && &filetype == "quickrun"|q|endif
    augroup END
  '';
}
