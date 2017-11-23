" ============================================================================
" File:        source.vim
" Description: Source vimrc + current file if it's in autoload/
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Fri Nov 24 01:12:46 +07 2017
" Licence:     BSD 3-Clause license
" Note:        Note
" ============================================================================

function! source#SourceAuto() " {{{
	if expand('%:p:h') =~# 'autoload$'
		let filename = expand('%:t')
		execute 'runtime autoload/' . filename
	endif

	source $MYVIMRC
	if exists(':YcmRestartServer')
		execute 'YcmRestartServer'
	endif
	nohlsearch
endfunction
" }}}

" vim: nofoldenable
