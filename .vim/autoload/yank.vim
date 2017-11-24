function! yank#Path() " {{{
	let full_path = expand("%:p")
	let @* = full_path
	let @+ = full_path

	echohl String
	echomsg full_path . ' has been yanked!'
	echohl None
endfunction
" }}}

" vim: nofoldenable
