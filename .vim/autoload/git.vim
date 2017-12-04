function! git#GetRootDir() " {{{
	let git_dir = substitute(system('git rev-parse --show-toplevel'), '\n', '', '')
	let isnotgitdir = matchstr(git_dir, '^fatal:.*')

	if isnotgitdir
		return ''
	else
		return git_dir
	endif
endfunction
" }}}
