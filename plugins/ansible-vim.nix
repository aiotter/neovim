{ vim-which-key }: {
  plugin = vim-which-key;
  config = ''
    set timeoutlen=500
    let g:which_key_align_by_seperator = 1
    let g:which_key_use_floating_win = 0
    " let g:which_key_position = 'botright'
    " let g:g:which_key_vertical = 1
    " let g:which_key_centered = 0

    autocmd ColorScheme * highlight WhichKeyFloating ctermfg=NONE ctermbg=232  guifg=NONE guibg=#383838
    if exists('g:which_key_use_floating_win') && !g:which_key_use_floating_win
      autocmd! FileType which_key
      autocmd  FileType which_key set laststatus=0 noshowmode noruler
        \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
    endif

    nnoremap <silent> <LocalLeader> :<c-u>WhichKey g:maplocalleader<CR>
    vnoremap <silent> <LocalLeader> :<c-u>WhichKeyVisual g:maplocalleader<CR>
    nnoremap <silent> <Leader> :<c-u>WhichKey g:mapleader<CR>
    vnoremap <silent> <Leader> :<c-u>WhichKeyVisual g:mapleader<CR>

    let g:gmap = {}
    let g:gmap.c = 'cheatsheet'
    let g:gmap.d = 'definitions'
    let g:gmap.f = 'file type'
    let g:gmap.q = 'quickRun'

    let g:lmap = {}
    let g:lmap.l = {'name': '+LSP'}
    let g:lmap.l.R = ['<Plug>(lsp-rename)', 'Rename']
    let g:lmap.l.d = ['<Plug>(lsp-document-diagnostics)', 'diagnostics']
    let g:lmap.l.p = ['<Plug>(lsp-document-format)', 'prettify']
    let g:lmap.l.r = ['<Plug>(lsp-reference)', 'reference']

    let g:lmap.g = {'name': '+Git'}
    let g:lmap.g.B = [':GBrowse', 'browse']
    let g:lmap.g.a = [':Git add %:p', 'add']
    let g:lmap.g.b = [':Git blame', 'blame']
    let g:lmap.g.c = [':Git commit', 'commit']
    let g:lmap.g.d = [':Git diff', 'diff']
    let g:lmap.g.l = [':Gclog', 'log']
    let g:lmap.g.p = [':Git push', 'push']
    let g:lmap.g.s = [':Git', 'status']
  '';
}
