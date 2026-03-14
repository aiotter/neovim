{ context_filetype-vim }: {
  plugin = context_filetype-vim;
  config = ''
    function! s:on_nix_file() abort
      " Editing vim plugins
      if expand('%:p:h:t') == 'plugins'
        let b:context_filetype_filetypes = {
        \ 'nix': [
        \   {
        \     'start': '\<config\s*=\s*' . "'''",
        \     'end': "'" . '\@<!' . "'''['" . '\\]\@!',
        \     'filetype': 'vim',
        \   },
        \   {
        \     'start': '\<config\s*=\s*"',
        \     'end': '"',
        \     'filetype': 'vim',
        \   },
        \ ],
        \ 'vim': [
        \   {
        \    'start': '^\s*lua <<\s*\(\h\w*\)',
        \    'end': '^\s*\1',
        \    'filetype': 'lua',
        \   },
        \ ],
        \} ->extend(g:context_filetype#filetypes, 'keep')
      elseif expand('%:p:h:t') == 'lsp-servers'
        let b:context_filetype_filetypes = {
        \ 'nix': [
        \   {
        \     'start': "'''",
        \     'end': "'" . '\@<!' . "'''['" . '\\]\@!',
        \     'filetype': 'vim',
        \   },
        \ ],
        \ 'vim': [
        \   {
        \    'start': '^\s*lua <<\s*\(\h\w*\)',
        \    'end': '^\s*\1',
        \    'filetype': 'lua',
        \   },
        \ ],
        \} ->extend(g:context_filetype#filetypes, 'keep')
      endif
    endfunction

    function! s:on_eex_file() abort
      let l:ft = &l:filetype
      if empty(l:ft)
        return
      endif

      let l:filetypes = copy(g:context_filetype#filetypes)
      let l:eex_contexts = [
      \   {
      \     'start': '<%[#=-]\?',
      \     'end': '%>',
      \     'filetype': 'elixir',
      \   },
      \ ]
      let l:filetypes[l:ft] = l:eex_contexts + get(l:filetypes, l:ft, [])
      let b:context_filetype_filetypes = l:filetypes
    endfunction

    augroup context_filetype
      autocmd!
      autocmd FileType nix call s:on_nix_file()
      autocmd FileType * if expand('%:t') =~# '\.eex$' | call s:on_eex_file() | endif
    augroup END
  '';
}
