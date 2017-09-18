highlight ntCursor guifg=NONE guibg=NONE
set guicursor=c-n-ve-i-r:ntCursor

setlocal nowrap

if has('localmap')
   nnoremap <buffer> h 4k
   nnoremap <buffer> l 4j
   nnoremap <buffer> <Enter> :.cc<CR>:copen<CR>
   nnoremap <buffer> <A-j> :cnext<CR>:copen<CR>
   nnoremap <buffer> <A-k> :cprev<CR>:copen<CR>
   nnoremap <buffer> <A-h> :cfirst<CR>:copen<CR>
   nnoremap <buffer> <A-l> :clast<CR>:copen<CR>
   nnoremap <silent><buffer> q :q<CR>
endif
