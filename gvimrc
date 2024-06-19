" -------------------- VimEnter設定（スクリプト読込後に実施） --------------------
" ランダムでcolorを設定
autocmd VimEnter * call SetColorScheme()
autocmd VimEnter * color peachpuff " 気に入ったため
" ------------------- / VimEnter設定 -------------------

" -------------------- GUI設定 --------------------
set guioptions-=m " メニューバーを非表示
set guioptions-=T " ツールバーを非表示
" set guioptions-=r " スクロールバーが非表示
set guioptions-=R " 
set guioptions-=l " 左側のスクロールバーを非表示
set guioptions-=L " 左側のスクロールバーを非表示
set guioptions-=b " ボタンバー（ツールバーの一部で、特定の機能へのショートカットボタンを含む）を非表示
set guifont=MS_Gothic:h12:b
" set guifont=hackgen35-regular:h11:b
" フォントサイズを変更
nnoremap + :let &guifont=substitute(&guifont, '\d\+', '\=submatch(0)+1', '')<CR>
nnoremap - :let &guifont=substitute(&guifont, '\d\+', '\=submatch(0)-1', '')<CR>
" ------------------- / GUI設定 -------------------

" -------------------- 関数定義 --------------------
" ランダムに色スキームを選択して適用する関数
function! SetColorScheme()
    " 色スキームのリストを定義
    let l:colorschemes = [
    \ 'blue', 'darkblue', 'delek', 'desert', 'elflord', 
    \ 'evening', 'industry', 'koehler', 'morning', 'murphy', 'pablo', 
    \ 'peachpuff', 'ron', 'slate', 'torte', 'zellner'
    \ ]
    " 'shine', 'default'
    let index = str2nr(matchstr(reltimestr(reltime()), '\v\d+')) % len(l:colorschemes)
    execute 'color ' . l:colorschemes[index]
endfunction
" ------------------- / 関数定義 -------------------

