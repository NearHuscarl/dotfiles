function! git#GetRootDir() " {{{
	" Get git top directory of current file
	let old_cwd = getcwd()
	execute 'lcd ' . expand('%:p:h')
	let git_dir = substitute(system('git rev-parse --show-toplevel'), '\n', '', '')
	let isnotgitdir = matchstr(git_dir, '^fatal:.*')

	execute 'lcd ' . old_cwd
	if isnotgitdir
		return ''
	else
		return git_dir
	endif
endfunction
" }}}

" vim: nofoldenable
