highlight ntCursor guifg=NONE guibg=NONE
set guicursor=c-n-ve-i-r:ntCursor

if has('localmap')
   nnoremap <buffer> h 4k
   nnoremap <buffer> l 4j
   nnoremap <silent><buffer> q :q<CR>
endif
