# Auto close (X)HTML tags
{ vim-closetag }: {
  plugin = vim-closetag;
  optional = true;
  config = ''
    autocmd FileType html            :packadd vim-closetag
    autocmd FileType xhtml           :packadd vim-closetag
    autocmd FileType phtml           :packadd vim-closetag
    autocmd FileType javascriptreact :packadd vim-closetag
    autocmd FileType typescriptreact :packadd vim-closetag
    autocmd FileType svelte          :packadd vim-closetag

    let g:closetag_filetypes = 'html,xhtml,phtml,javascriptreact,typescriptreact,svelte'
  '';
}
