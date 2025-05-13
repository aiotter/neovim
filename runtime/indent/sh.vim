if exists('b:did_indent')
  finish
endif

source $VIMRUNTIME/indent/sh.vim

" prevent commands like "docker" being unindented by 0=do
setlocal indentkeys+=0=doc,0=dog,0=dot,0=dow,0=dox

let b:did_indent = 1
