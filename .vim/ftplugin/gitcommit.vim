setlocal nofoldenable

if has('localmap')
   nmap <buffer> <A-j> <C-n>zz
   nmap <buffer> <A-k> <C-p>zz
   nnoremap <silent><buffer> q :q<CR>
endif
