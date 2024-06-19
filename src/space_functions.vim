" メニュー項目の設定
let menu = {
    \   '1': {'method': v:null, 'desc': 'ファイルを開く'}
    \ , '2': {'method': 'OpenVimrc', 'desc': 'vim設定ファイルを開く'}
    \ , '3': {'method': 'OpenTree', 'desc': 'Fernを開く'}
    \ , '4': {'method': 'RecentFile', 'desc': '最近開いたファイルを開く'}
    \ , '5': {'method': 'InsertCurrentDate', 'desc': '日付と曜日を挿入する'}
    \ , '6': {'method': 'SetColorScheme', 'desc': 'テーマの変更（GUI限定）'}
    \ , 'y': {'method': 'SetClipboard', 'desc': 'クリップボードにコピー'}
    \ , 'p': {'method': 'PasteClipboard', 'desc': 'クリップボードを貼り付け'}
\ }

" ユーザー定義辞書とマージ
if exists('g:menuList') && !empty(g:menuList)
    " 辞書マージ用関数
    function! MergeDicts(dict1, dict2)
    let result = copy(a:dict1)
    for [key, value] in items(a:dict2)
        let result[key] = value
    endfor
    return result
    endfunction

    let menu = MergeDicts(g:menuList, menu)
endif

let g:menuList = menu

" メニューを表示してユーザー入力に応じたアクションを実行する関数
function! ShowMenu()
    let l:cmdheight = &cmdheight

    let l:sortedKeys = sort(keys(g:menuList))

    " メニューの表示
    let &cmdheight = len(g:menuList) + 3
    echo '-------------------------------------------'
    for l:key in l:sortedKeys
        echo l:key . ': ' . g:menuList[l:key]['desc']
    endfor
    echo '-------------------------------------------'

    " ユーザーの入力を待つ
    let l:user_input = nr2char(getchar())
    let &cmdheight = l:cmdheight

    " 選択されたメニュー項目の実行
    if has_key(g:menuList, l:user_input)
        if exists('*' . g:menuList[l:user_input]['method'])
            execute 'call ' . g:menuList[l:user_input]['method'] . '()'
        else
            echo '関数がありません／' . g:menuList[l:user_input]['method']
        endif
    else
        echo 'そのキーは設定されていません／' . l:user_input
    endif
endfunction

" 現在のモードが引数に指定されたモードのいずれかであるかを判定する関数
function! IsCurrentMode(modes)
    let l:current_mode = mode()
    for mode in a:modes
        " 各モードと現在のモードを比較
        if mode == 'insert'
            if l:current_mode =~ '^[iR]'
                return 1
            endif
        elseif mode == 'normal'
            if l:current_mode == '' || l:current_mode == 'c' || l:current_mode == 'n'
                return 1
            endif
        elseif mode == 'visual'
            if l:current_mode =~ '^v'
                return 1
            endif
        else
            echoerr 'Unknown mode: ' . mode
        endif
    endfor
    return 0
endfunction

" Vim設定ファイルを開くための関数
function! OpenVimrc()
    " ファイル選択リストの設定
    let l:fileList = [
        \   g:user_vim_dir . '/vimrc',
        \   g:user_vim_dir . '/gvimrc',
        \   g:user_vim_dir . '/space_functions.vim',
    \ ]
    let l:result = ReturnUserSelected(l:fileList)
    if l:result isnot v:null
        execute ':tabe ' . l:result
    endif
endfunction

" Fernをトグルする関数
function! OpenTree()
" ディレクトリ選択リストの設定
    let l:dirList = [
        \   '現在のファイルのパス'
        \ , g:user_vim_dir
    \ ]
    if exists('g:fernList') && !empty(g:fernList)
        let l:dirList = l:dirList + g:fernList
    endif
    let l:result = ReturnUserSelected(l:dirList)
    if l:result == '現在のファイルのパス'
        Fern %:h -reveal=% -drawer -width=35
        return
    endif
    if l:result isnot v:null
        execute 'Fern ' . l:result . ' -drawer -toggle -width=35'
    endif
endfunction

" 最近開いたファイルを開く
function! RecentFile()
    execute ':browse oldfiles'
endfunction

" 日付と曜日を挿入する関数
function! InsertCurrentDate()
    let l:days = ['日', '月', '火', '水', '木', '金', '土']
    let l:date = strftime("%Y-%m-%d")
    let l:day = l:days[strftime("%w")]
    let l:result = l:date . '(' . l:day . ')'
    execute 'normal! A' . l:result
endfunction


" 選択されたテキストをクリップボードにコピーする関数
function! SetClipboard()
    normal! gv"+y
endfunction

" クリップボードの内容を貼り付ける関数
function! PasteClipboard()
    normal "+P
endfunction

function! ReturnUserSelected(array)
    redraw

    let l:cmdheight = &cmdheight
    let &cmdheight = len(a:array) + 4

    echo '-------------------------------------------'
    echo '選択してください'
    for i in range(len(a:array))
        echo (i + 1) . ': ' . a:array[i]
    endfor
    echo '-------------------------------------------'

    let &cmdheight = l:cmdheight

    " ユーザーの入力に基づいてディレクトリを開く
    let l:user_input = nr2char(getchar())
    if l:user_input >= 1 && l:user_input <= len(a:array)
        return a:array[l:user_input - 1]
    else
        echo 'そのキーは設定されていません／' . l:user_input
        return v:null
    endif
endfunction

" Spaceキーにメニュー表示関数をマッピング
nnoremap <Space> :call ShowMenu()<CR>
vnoremap <Space> :<C-u>call ShowMenu()<CR>
