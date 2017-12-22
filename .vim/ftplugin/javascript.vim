setlocal omnifunc=javascriptcomplete#CompleteJS

nnoremap <silent><buffer> <Leader>B :call JsBeautify()<CR>
nnoremap <silent> gd :call gotodef#exe()<CR>
