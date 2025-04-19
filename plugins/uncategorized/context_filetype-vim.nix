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

    augroup context_filetype
      autocmd!
      autocmd FileType nix call s:on_nix_file()
    augroup END
  '';
}
