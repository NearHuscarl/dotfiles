" ============================================================================
" File:        source.vim
" Description: Source vimrc + current file if it's in autoload/
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Sat Nov 25 06:03:27 +07 2017
" Licence:     BSD 3-Clause license
" Note:        Note
" ============================================================================

function! source#Vimrc() " {{{
	source $MYVIMRC
	if exists(':YcmRestartServer')
		execute 'YcmRestartServer'
	endif
	nohlsearch
endfunction
" }}}
" Note: This function cannot source the file contain itself (autoload/source.vim)
" Because it cannot be redefined while still executing. workaround is manually
" call runt autoload/source.vim
function! source#Other() " {{{
	for dirname in ['after', 'autoload', 'colors', 'ftdetect', 'ftplugin', 'indent']
		" dirname = 'autoload' => match ../autoload/.. or ../autoload
		if expand('%:p:h') =~# '\(\/' . dirname . '\/\|\/' . dirname . '$\)'
			let file_path = dirname . '/' . expand('%:t')

			execute 'runtime ' . file_path
			echohl String
			echomsg file_path . ' has been sourced!'
			echohl None

			return
		endif
	endfor

	echohl PreProc
	echomsg 'current file cannot be sourced!'
	echohl None
endfunction
" }}}

" vim: nofoldenable
