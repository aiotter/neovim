if !exists('*HtmlIndent')
  runtime! indent/html.vim
endif
let b:did_indent = 1

setlocal indentexpr=HtmlIndent()
setlocal indentkeys=o,O,<Return>,<>>,{,},!^F
setlocal matchpairs+=<:>
