# Syntax highlight MDX files
{ vim-mdx-js }: {
  plugin = vim-mdx-js;
  optional = true;
  config = ''
    autocmd BufNewFile,BufRead *.mdx set filetype=markdown.mdx
    autocmd FileType markdown.mdx :packadd vim-mdx-js
  '';
}
