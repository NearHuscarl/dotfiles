if has('localmap')
	nmap <buffer> l <plug>GundoMoveDOWN
	nmap <buffer> <expr>h (line('.') < 9) ? "gg" : "<plug>GundoMoveUP"
	nmap <buffer> j <plug>GundoMoveDown
	nmap <buffer> k <plug>GundoMoveUp
	nmap <buffer> d <plug>GundoRenderChangePreview
	nmap <buffer> f <plug>GundoRenderPreview
	nmap <buffer> p <plug>GundoPlayTo
	nnoremap <buffer> t :call NearFunc#GundoAutoPreviewToggle()<CR>
endif
