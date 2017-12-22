setlocal iskeyword+=$ " viw select '$var' instead of '$'var or $'var'

nnoremap <silent><buffer> <Leader>d :call bash#insert_trace()<CR>
nnoremap <silent><buffer> <Leader>D :call bash#remove_trace()<CR>
vnoremap <silent><buffer> <Leader>d :call bash#insert_trace(1)<CR>
vnoremap <silent><buffer> <Leader>D :call bash#remove_trace(1)<CR>
