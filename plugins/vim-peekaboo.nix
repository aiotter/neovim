# Show contents of the registers after user inputs:
# " and @ in normal mode and <Ctrl-R> in insert mode
{ vim-peekaboo }: {
  plugin = vim-peekaboo;
  optional = true;
  config = ''
    autocmd BufWinEnter * :packadd vim-peekaboo

    let g:peekaboo_delay = 500
    let g:peekaboo_window="call CreateCenteredFloatingWindow()"

    function! CreateCenteredFloatingWindow() abort
        if(!has('nvim')) 
            split
            new
        else
            let width = float2nr(&columns * 0.6)
            let height = float2nr(&lines * 0.6)
            let top = ((&lines - height) / 2) - 1
            let left = (&columns - width) / 2
            let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal', 'border': 'single', 'noautocmd': 1}
            let s:buf = nvim_create_buf(v:false, v:true)
            call nvim_open_win(s:buf, v:true, opts)
        endif
    endfunction
  '';
}
