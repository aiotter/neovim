" ----- キーバインド -----
set ttimeoutlen=100  " Esc で Insert -> Normal のモード遷移を高速化

" ノーマルモードで o を入力したときに挿入モードに移らない
" nnoremap o :<C-u>call append(expand('.'), '')<Cr>j

" Leader
nnoremap <Leader>f :let &filetype=input('Enter filetype: ')<CR>


" ----- 文字 -----
set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
" set ambiwidth=double " □や○文字が崩れる問題を解決
set showmatch " 閉じカッコ入力時に対応するカッコを強調


" ----- クリップボード -----
if has('nvim')
    set clipboard+=unnamedplus
elseif has('vim_starting')
    set clipboard+=unnamed
endif
" lua <<EOF
"   local osc52 = require('vim.ui.clipboard.osc52')
"   vim.g.clipboard = {
"     name = 'OSC 52',
"     copy = {
"       ['+'] = osc52.copy('+'),
"       ['*'] = osc52.copy('*'),
"     },
"     paste = {
"       ['+'] = osc52.paste('+'),
"       ['*'] = osc52.paste('*'),
"     },
"   }
" EOF


" ----- 制御文字の表示 -----
set list
set listchars=tab:▸\ ,eol:↲,extends:»,precedes:« ",nbsp:⚋ ,trail:-
autocmd ColorScheme * highlight NonText    ctermbg=NONE ctermfg=238 guibg=NONE guifg='#444444'
autocmd ColorScheme * highlight SpecialKey ctermbg=NONE ctermfg=238 guibg=NONE guifg='#444444'


" ----- Concealing (構文の非表示化) の設定 -----
" json のダブルクオーテーションなど，視認性を妨げる文字を隠す設定
if has('conceal')
  set conceallevel=1 " 表示する(0), 代理文字（default: スペース）に置換(1), 非表示(2)
  set concealcursor= " カーソルライン上で構文を隠すモードの指定．n: normal, v: visual, i: insert, c: command
  autocmd ColorSchemePre * highlight clear Conceal

  let g:markdown_syntax_conceal = 0
endif


" ----- タブとインデント (グローバル設定) -----
set expandtab " タブ入力を複数の空白入力に置き換える
set tabstop=4 " 画面上でタブ文字が占める幅
set softtabstop=2 " タブの代わりに入力される空白文字の数
set shiftwidth=2 " >> や自動インデントで増減する幅
set autoindent " 改行時に前の行のインデントを継続する
" set smartindent " 改行時に前の行の構文をチェックし次の行のインデントを増減する


" ----- 検索 -----
set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト

" ESCキー2度押しでハイライトの非表示化
nnoremap <silent><Esc><Esc> :<C-u>nohlsearch<CR>


" ----- カーソル -----
set whichwrap=b,s,h,l,<,>,[,],~ " カーソルの左右移動で行末から次の行の行頭への移動が可能になる
set number " 行番号を表示
set cursorline " カーソルラインをハイライト
" highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=darkgray
set scrolloff=5 " スクロール時、常に5行先を表示する

" https://zenn.dev/mattn/articles/83c2d4c7645faa
nmap gj gj<SID>g
nmap gk gk<SID>g
nnoremap <script> <SID>gj gj<SID>g
nnoremap <script> <SID>gk gk<SID>g
nmap <SID>g <Nop>

" Emacs-like behaviour
nnoremap <C-b> h
nnoremap <C-n> j
nnoremap <C-p> k
nnoremap <C-f> l

" バックスペースキーの有効化
set backspace=indent,eol,start

if has('vim_starting')
    " 挿入モード時に点滅の縦棒タイプのカーソル
    let &t_SI .= "\e[5 q"
    " ノーマルモード時に非点滅のブロックタイプのカーソル
    let &t_EI .= "\e[2 q"
    " 置換モード時に点滅の下線タイプのカーソル
    let &t_SR .= "\e[3 q"
endif

" ----- コマンド -----
set wildmenu " コマンドモードの補完
set history=5000 " 保存するコマンド履歴の数


" ----- マウス -----
" マウスでカーソル移動やスクロール移動
if has('nvim')
    set mouse=a
elseif has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif


" ----- 色 -----
set t_Co=256
syntax enable
if has('termguicolors')
  let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
  let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
  set termguicolors
endif


" ----- ウィンドウ -----
" Quickfix だけが残された場合自動的に閉じる
aug QFClose
  au!
  au WinEnter * if winnr('$') == 1 && &buftype == "quickfix"|q|endif
aug END


" ----- フローティングウィンドウ -----
if has('nvim')
  " set pumblend=10 " 不透明度
  " set winblend=10
  highlight NormalFloat guifg=#eceff4 guibg=#1e1e1e ctermbg=235
endif


" ----- ステータスライン -----
set laststatus=2 " ステータスラインを常に表示
set noshowmode " 現在のモードを非表示
set showcmd " 打ったコマンドをステータスラインの下に表示
set ruler " ステータスラインの右側にカーソルの現在位置を表示する


" ----- サインカラム -----
set signcolumn=yes " 常に表示


" ----- ファイルタイプ固有の設定 -----
filetype plugin indent on


" ----- スペルチェック -----
set spell
set spelllang=en,cjk
set spelloptions=camel
set spellcapcheck=


" ----- 補完 -----
" 常に補完候補を表示/補完ウィンドウ表示時に挿入しない
set completeopt=menuone,noinsert,noselect ",preview

" 補完選択時はEnterで改行をしない
" function! _Enter_key()
"   if complete_info(['pum_visible', 'selected']) == {'pum_visible': 1, 'selected': -1}
"     return "\<CR>\<CR>"
"   elseif pumvisible()
"     return "\<C-y>"
"   else
"     return "\<CR>"
"   endif
" endfunction
" inoremap <expr><CR> _Enter_key()

" C-p と C-n を矢印キーと同じ挙動に（候補選択時に挿入しない）
" inoremap <expr><C-n> pumvisible() ? "<Down>" : "<C-n>"
" inoremap <expr><C-p> pumvisible() ? "<Up>" : "<C-p>"

" カーソルキーで補完ウィンドウにフォーカスしない (nvim-cmp.vim で設定済み)
" function! Is_completion_unforcused()
"   return complete_info(['pum_visible', 'selected']) == {'pum_visible': 1, 'selected': -1}
" endfunction
" imap <expr><Down> Is_completion_unforcused() ? "\<C-e>\<Down>" : "\<Down>"
" imap <expr><Up>   Is_completion_unforcused() ? "\<C-e>\<Up>"   : "\<Up>"
" ↓おそらく vim のバグで設定できない
" imap <expr><C-n>  Is_completion_unforcused() ? "\<C-e>\<C-n>"  : "\<Down>"
" imap <expr><C-p>  Is_completion_unforcused() ? "\<C-e>\<C-p>"  : "\<Up>"


" ----- ヒントの表示 -----
" function! s:hint_cmd_output(prefix, cmd) abort
"   redir => str
"     execute a:cmd
"   redir END
"   echo str
"   return a:prefix . nr2char(getchar())
" endfunction
"  
" nnoremap <expr> m  <SID>hint_cmd_output('m', 'marks')
" nnoremap <expr> `  <SID>hint_cmd_output('`', 'marks')
" nnoremap <expr> '  <SID>hint_cmd_output("'", 'marks')
" nnoremap <expr> "  <SID>hint_cmd_output('"', 'registers')
" nnoremap <expr> q  <SID>hint_cmd_output('q', 'registers')
" nnoremap <expr> @  <SID>hint_cmd_output('@', 'registers')


" ----- その他 -----
" https://vi.stackexchange.com/questions/19953/why-doesnt-this-autocmd-take-effect-for-neovim/19963
set shortmess-=F
