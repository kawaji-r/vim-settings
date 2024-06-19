set encoding=utf-8
set fileencoding=utf-8

" ユーザーフォルダ設定
let g:user_vim_dir = expand('<sfile>:p:h')

" -------------------- シンプル設定 --------------------
set nu
set expandtab
set shiftwidth=4
set tabstop=4
set showtabline=2
set noignorecase
" タブや改行を表示 (list:表示)
set list
" どの文字でタブや改行を表示するかを設定
set listchars=tab:>-,extends:<,trail:-,eol:~
" ------------------- / シンプル設定 -------------------

" -------------------- シンプルMAP --------------------
" Visualモードで選択中のテキストを検索する
vnoremap * :<C-u>call VisualSearch()<CR>
nnoremap <A-j> <C-w>j
nnoremap <A-h> <C-w>h
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
nnoremap Y y$
" Esc SETTINGS
inoremap jj <Esc>
" ------------------- / シンプルMAP -------------------

" -------------------   MyMAP -------------------
" ------------------- / MyMAP -------------------


" -------------------- BK設定 --------------------
" バックアップファイル
let $BK = g:user_vim_dir . '/backup'
if (!isdirectory($BK))
    call mkdir ($BK)
endif
set directory =$BK
set backupdir =$BK
set undodir   =$BK
" ------------------- / BK設定 -------------------

" -------------------- 外部ファイル読み込み --------------------
" ユーザーファイル読み込み
let files = globpath(g:user_vim_dir . '/user_src', "*.vim", 0, 1)
for file in files
    execute 'source' file
endfor

" Spaceのマッピングを外部ファイルで定義
execute 'source' g:user_vim_dir . '/src/space_functions.vim'
" ------------------- / 外部ファイル読み込み -------------------

" -------------------- 関数定義 --------------------
" ファイルをechoする
" @param String path ファイル名
function! EchoFile(path)
    for line in readfile(a:path)
        if (line == "")
            echo "."
        else
            echo line
        endif
    endfor
endfunction

" 選択範囲の文字列で検索
function! VisualSearch()
    " 一時的に無名レジスタの内容を保存
    let l:original_reg = @"
    " 選択範囲を無名レジスタにヤンク
    normal! gv"xy
    " ヤンクしたテキストを変数に格納
    let l:text = @"
    " 元の無名レジスタの内容を復元
    let @" = l:original_reg
    " 改行をVimの検索パターン表現に変換
    let l:escaped_text = substitute(l:text, '\n', '\\n', 'g')
    " 改行以降を削除
    let l:text = substitute(l:text, '\n.*', '', '')
    " 特殊文字のエスケープ
    let l:escaped_text = escape(l:text, '\.*$^~[]')
    " 検索履歴に追加
    call histadd('search', l:escaped_text)
    " 検索パターンの設定
    let @/ = l:escaped_text
    set hlsearch
    " 最初の一致に移動
    normal! n
endfunction

" ------------------- / 関数定義 -------------------

" -------------------- プラグイン設定 --------------------
execute 'source' g:user_vim_dir . '/src/plugins.vim'
" ------------------- / プラグイン設定 -------------------

" -------------------- その他 --------------------
"     Old text                    Command         New text
" --------------------------------------------------------------------------------
"     surr*ound_words             ysiw)           (surround_words)
"     *make strings               ys$"            "make strings"
"     [delete ar*ound me!]        ds]             delete around me!
"     remove <b>HTML t*ags</b>    dst             remove HTML tags
"     'change quot*es'            cs'"            "change quotes"
"     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
"     delete(functi*on calls)     dsf             function calls
" ------------------- / その他 -------------------
