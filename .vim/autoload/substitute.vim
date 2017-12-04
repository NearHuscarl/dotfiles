" substitute command which do 3 more things
"    shut up when no pattern found
"    restore cursor position
"    no highlight cursor after substitute
function! substitute#Exe(sub_cmd) " {{{
	let save_view = winsaveview()
	let bufnum = bufnr('%')
	try
		execute a:sub_cmd
	catch /Pattern not found/
		echohl PreProc
		echomsg 'No pattern found to substitute'
		echohl None
	endtry
	execute 'buffer ' . bufnum
	call winrestview(save_view)
endfunction
" }}}
