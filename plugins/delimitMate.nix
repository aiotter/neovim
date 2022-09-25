# Automatic closing of quotes, parenthesis, brackets, etc.
{ delimitMate }: {
  plugin = delimitMate;
  optional = true;
  config = ''
    autocmd InsertEnter * :packadd delimitMate

    " Avoid conflicting delimitMate with vim-closetag
    autocmd FileType html,xhtml,phtml,javascriptreact,typescriptreact let b:delimitMate_matchpairs = "(:),[:],{:}"
  '';
}
