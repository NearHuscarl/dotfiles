if has('localmap')
   nmap <buffer> l <plug>GundoMoveDOWN         <bar> ;set guicursor=n:ntCursor<CR>
   nmap <buffer> <expr>h (line('.') < 9) ? "gg <bar> ;set guicursor=n:ntCursor<CR>" : "<plug>GundoMoveUP <bar> ;set guicursor=n:ntCursor<CR>"
   nmap <buffer> j <plug>GundoMoveDown         <bar> ;set guicursor=n:ntCursor<CR>
   nmap <buffer> k <plug>GundoMoveUp           <bar> ;set guicursor=n:ntCursor<CR>
   nmap <buffer> d <plug>GundoRenderChangePreview
   nmap <buffer> f <plug>GundoRenderPreview
   nmap <buffer> p <plug>GundoPlayTo
   nnoremap <buffer> t :call NearFunc#GundoAutoPreviewToggle()<CR>
endif
