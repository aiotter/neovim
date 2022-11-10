# Show visual help for leader commands
{ vim-which-key }:

{
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
    " let g:lmap.l.a = [':execute "lua vim.lsp.buf.code_action()"', 'code action']
    let g:lmap.l.a = [':CodeActionMenu', 'code action']
    let g:lmap.l.i = [':execute "lua vim.lsp.buf.implementation()"', 'implementation']
    let g:lmap.l.R = [':execute "lua vim.lsp.buf.rename()"', 'Rename']
    let g:lmap.l.d = [':execute "lua vim.diagnostic.open_float()"', 'diagnostics (line)']
    let g:lmap.l.f = [':execute "lua vim.lsp.buf.format()"', 'format']
    let g:lmap.l.r = [':execute "lua vim.lsp.buf.references()"', 'references']

    let g:lmap.g = {'name': '+Git'}
    let g:lmap.g.B = [':GBrowse', 'browse']
    let g:lmap.g.a = [':Git add %:p', 'add']
    let g:lmap.g.b = [':Git blame', 'blame']
    let g:lmap.g.c = [':Git commit', 'commit']
    let g:lmap.g.d = [':Git diff', 'diff']
    let g:lmap.g.l = [':Gclog', 'log']
    let g:lmap.g.p = [':Git push', 'push']
    let g:lmap.g.s = [':Git', 'status']

    function! s:on_which_key_load()
      if g:mapleader == g:maplocalleader
        let g:leadersMap = extend(g:gmap, g:lmap)
        call which_key#register(g:mapleader, "g:leadersMap")
      else
        call which_key#register(g:mapleader, "g:gmap")
        call which_key#register(g:maplocalleader, "g:lmap")
      endif
    endfunction
    augroup on_which_key_load
      autocmd!
      autocmd VimEnter * call s:on_which_key_load()
    augroup END
  '';
}
