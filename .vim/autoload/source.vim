" ============================================================================
" File:        source.vim
" Description: Source vimrc + current file if it's in autoload/
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Sun Dec 17 15:55:52 +07 2017
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
function! s:EchoHL(msg, hl_group) " {{{
	execute 'echohl ' . a:hl_group
	echomsg a:msg
	echohl None
endfunction
" }}}
function! source#Vimfile() " {{{
	" Note: This function cannot source the file contain itself (autoload/source.vim)
	" Because it cannot be redefined while still executing.
	if expand('%:p') =~# 'autoload\/source\.vim'
		return
	endif

	for dirname in ['after', 'autoload', 'ftdetect', 'ftplugin', 'indent']
		" dirname = 'autoload' => match ../autoload/.. or ../autoload
		if expand('%:p:h') =~# '\(\/' . dirname . '\/\|\/' . dirname . '$\)'
			" /home/near/.vim/autoload/a/b/f.vim => autoload/a/b/f.vim
			let file_path = matchlist(expand('%:p'), '.*\(' . dirname . '.*$\)')[1]

			execute 'runtime ' . file_path
			redraw
			call s:EchoHL(file_path . ' has been sourced!', 'String')
			return
		endif
	endfor

	redraw
	call s:EchoHL('current file cannot be sourced!', 'PreProc')
endfunction
" }}}
function! source#Xresources() " {{{
	let cmd = 'xrdb $HOME/.Xresources'

	if has('win32') || has('win64')
		let s:plugged = $HOME.'\vimfiles\plugged\'
	else
		let s:plugged = $HOME.'/.vim/plugged/'
	endif

	if expand('%:p') =~# '\.Xresources'
		if !empty(glob(s:plugged . 'asyncrun.vim'))
			execute 'AsyncRun ' . cmd
		else
			execute '!' . cmd
		endif

		redraw
		call s:EchoHL('~/.Xresources has been sourced!', 'String')
	endif
endfunction
" }}}

" vim: nofoldenable
