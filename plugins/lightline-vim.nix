{ lightline-vim }: {
  plugin = lightline-vim;
  config = ''
    let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'suda_filename', 'filename', 'modified' ] ],
    \   },
    \   'component_function': {
    \     'fileformat': 'LightlineFileformat',
    \     'fileencoding': 'LightlineFileencoding',
    \     'filetype': 'LightlineFiletype',
    \     'filename': 'LightlineFilename',
    \   },
    \   'component_expand': {
    \     'suda_filename': 'LightlineSudaFilename',
    \   },
    \   'component_type': {
    \     'suda_filename': 'warning',
    \   },
    \ }

    " responsive
    let s:threshold = 65
    function! LightlineFileformat()
      if winwidth(0) > s:threshold
        return &fileformat ==# 'dos' ? 'CRLF' :
          \ &fileformat ==# 'unix' ? 'LF' :
          \ &fileformat ==# 'mac' ? 'CR' :
          \ &fileformat
      else
        return ""
      endif
    endfunction
    function! LightlineFileencoding()
      return winwidth(0) > s:threshold ? &fileencoding : ""
    endfunction
    function! LightlineFiletype()
      return winwidth(0) > s:threshold ? (&filetype !=# "" ? &filetype : 'no ft') : ""
    endfunction

    " non-suda buffer
    function! LightlineFilename()
      if expand('%') !~# '^suda://'
        return expand('%:t') !=# "" ? expand('%:t') : '[No Name]'
      endif
      return ""
    endfunction

    " suda buffer
    function! LightlineSudaFilename()
      return expand('%') =~# '^suda://' ? 'suda://' . expand('%:t') : ""
    endfunction
  '';
}
