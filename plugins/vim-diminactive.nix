# Dim inactive windows
{ vim-diminactive }: {
  plugin = vim-diminactive;
  config = ''
    let g:diminactive_enable_focus = 1
    highlight ColorColumn ctermbg=0 guibg=#303030
  '';
}
