function! bash#insert_trace(...) " {{{
	let set_trace = 'set -x'
	let unset_trace = 'set +x'
	let line = getline('.')
	let old_formatoption = &formatoptions

	if &formatoptions =~# 'o'
		set formatoptions-=o
	endif

	let visual_mode = a:0
	if visual_mode
		execute "normal! '<O" . set_trace
		execute "normal! '>o" . unset_trace
	else
		call cursor(line, 0)
		execute 'normal! O' . set_trace
		execute 'normal! j'
		execute 'normal! o' . unset_trace
		let &formatoptions = old_formatoption
	endif
endfunction
" }}}
function! bash#remove_trace() " {{{
	" remove set -x and set +x pair
	" search forward for 'set -x' & 'set +x' pair, if not found then search backward
	" if search found, delete those lines
	let set_trace_pattern = '^\s*set -x$'
	let unset_trace_pattern = '^\s*set +x$'
	let line = getline('.')

	call search(unset_trace_pattern, 'c')
	execute 'normal! dd'
	call search(set_trace_pattern, 'bW')
	execute 'normal! dd'
endfunction
" }}}
