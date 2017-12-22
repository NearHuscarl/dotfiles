setlocal omnifunc=csscomplete#CompleteCSS

nnoremap <silent><buffer> <Leader>B :call CSSBeautify()<CR>
nnoremap <silent><buffer> <Leader>i :call css#ToggleInsertImportant()<CR>
nnoremap <silent><buffer> <Leader>I :set opfunc=css#ToggleInsertImportantRange<CR>g@
nnoremap <silent><buffer> p :call css#Paste()<CR>
nnoremap <silent><buffer> yw :call css#CopyOrCut('y', 'yw')<CR>
nnoremap <silent><buffer> dw :call css#CopyOrCut('d', 'dw')<CR>
nnoremap <silent><buffer> <Leader><Leader>c :call css#ToggleHexOrRgb()<CR>
