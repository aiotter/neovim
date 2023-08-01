{ lexima-vim }: {
  plugin = lexima-vim;
  config = ''
    let g:lexima_map_escape = ""

    let g:lexima_no_default_rules = 1
    call lexima#set_default_rules()
    inoremap <silent><expr> <CR> luaeval('require("cmp").get_active_entry() and true')
      \ ? "\<Cmd>lua require('cmp').confirm()\<CR>"
      \ : "\<C-r>=lexima#expand('<LT>CR>', 'i')\<CR>"

    call lexima#add_rule({
      \ 'char': '<CR>',
      \ 'input': '<CR>',
      \ 'input_after': '<CR>',
      \ 'at': '>\%#</',
      \ 'filetype': ['html', 'xml', 'react', 'typescriptreact', 'svelte'],
      \ })
  '';
}
