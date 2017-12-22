" ============================================================================
" File:        ctags.vim
" Description: Update ctags file. Use with autocmd BufWritePost
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Tue Dec 12 11:50:41 +07 2017
" Licence:     BSD 3-Clause license
" Note:        None
" ============================================================================

function! s:EchoHL(msg, hl_group) " {{{
	execute 'echohl ' . a:hl_group
	echomsg a:msg
	echohl None
endfunction
" }}}
function! s:ExecuteCmd(cmd) " {{{
	if has('win32') || has('win64')
		let s:plugged = $HOME.'\vimfiles\plugged\'
	else
		let s:plugged = $HOME.'/.vim/plugged/'
	endif

	if !empty(glob(s:plugged . 'asyncrun.vim'))
		execute 'AsyncRun ' . a:cmd
	else
		call system(a:cmd)
	endif
endfunction
" }}}
function! s:GetTagPath() " {{{
	" Get the closest parent path that contains tags file, if no
	" tags file is found return current dir to create new tags in it
	try
		let tag_path = fnamemodify(tagfiles()[0], ':~:h')
	catch /list index out of range/
		let tag_path = expand('%:~:h')
	endtry
	return tag_path
endfunction
" }}}
" Note: tags file must be created first (manually or by other script)
" before it can get updated by this function
function! ctags#Update() " {{{
	let old_cwd = getcwd()
	let tag_path = s:GetTagPath()

	" tags in $HOME for vimrc
	if tag_path ==# '~'
		redraw
		call s:EchoHL('No tags file found up to $HOME/', 'PreProc')
		return
	else
		let cmd = 'ctags -R -f newtags && mv newtags tags &'
	endif

	execute 'cd ' . tag_path
	call s:ExecuteCmd(cmd)
	execute 'cd ' . old_cwd

	redraw
	call s:EchoHL(tag_path . '/tags has been updated!', 'String')
endfunction
" }}}
function! ctags#Create() " {{{
	call s:ExecuteCmd('ctags -R -f newtags && mv newtags tags &')
	redraw
	call s:EchoHL(fnamemodify(getcwd(), ':~:h') . '/tags has been created!', 'String')
endfunction
" }}}

" vim: nofoldenable
