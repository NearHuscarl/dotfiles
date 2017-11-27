" ============================================================================
" File:        ctags.vim
" Description: Update ctags file. Use with autocmd BufWritePost
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Mon Nov 27 07:12:25 +07 2017
" Licence:     BSD 3-Clause license
" Note:        None
" ============================================================================

" Note: tags file must be created first (manually or by other script)
" before it can get updated by this function
function! ctags#Update() " {{{
	let cmd = 'ctags -R -f newtags && mv newtags tags &'
	let old_cwd = getcwd()
	" Get the closest parent path that contains tags file
	let tag_path = fnamemodify(tagfiles()[0], ':~:h')

	if has('win32') || has('win64')
		let s:plugged = $HOME.'\vimfiles\plugged\'
	else
		let s:plugged = $HOME.'/.vim/plugged/'
	endif

	execute 'cd ' . tag_path
	if !empty(glob(s:plugged . 'asyncrun.vim'))
		execute 'AsyncRun ' . cmd
	else
		call system(cmd)
	endif
	execute 'cd ' . old_cwd

	redraw
	echohl String
	echomsg tag_path . '/tags has been updated!'
	echohl None
endfunction
" }}}

" vim: nofoldenable
