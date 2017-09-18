highlight ntCursor guifg=NONE guibg=NONE
set guicursor=c-n-ve-i-r:ntCursor

if has('localmap')
   nnoremap <buffer> h 4k
   nnoremap <buffer> l 4j
   nnoremap <silent><buffer> q :q<CR>

   nmap <buffer> o go <Bar> ;set guicursor=n:ntCursor<CR>
   nmap <buffer> x gx <Bar> ;set guicursor=n:ntCursor<CR>
   nmap <buffer> v gv <Bar> ;set guicursor=n:ntCursor<CR>
   nmap <buffer> t T  <Bar> ;set guicursor=n:ntCursor<CR>
endif

