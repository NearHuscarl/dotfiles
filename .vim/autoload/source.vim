" ============================================================================
" File:        source.vim
" Description: Source vimrc + current file if it's in autoload/
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Sat Nov 04 22:40:55 +07 2017
" Licence:     BSD 3-Clause license
" Note:        Note
" ============================================================================

function! source#SourceAuto() " {{{
	if @% =~# 'autoload'
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
