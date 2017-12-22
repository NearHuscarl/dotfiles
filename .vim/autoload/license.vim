" ============================================================================
" File:        license.vim
" Description: A function to auto update Last Change time, use with autocmd 
"              BufWrite, and a function for undo/redo mappings to skip
"              jumping to auto updated timestamp
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Thu Dec 07 00:59:16 +07 2017
" Licence:     BSD 3-Clause license
" Note:        N/A
" ============================================================================

let s:date_prefix = 'Last Change: '

" Find the match between line 5 to 15 and replace it with current date
function! license#SetLastChangeBeforeBufWrite(timefstring) " {{{
	let view_info = winsaveview()
	let comment = substitute(&commentstring, '%s', '', '')
	" :help :global
	silent! execute '5,15g/' . comment . ' ' . s:date_prefix
				\ . '/s/' . s:date_prefix . '.*$/' . s:date_prefix . strftime(a:timefstring)
	nohlsearch
	call winrestview(view_info)
endfunction
" }}}
function! license#SkipLicenseDate(action) " {{{
	" Skip seeing changes in license date when doing an undo/redo
	let view_info  = winsaveview()

	if a:action ==# 'undo'
		let key = 'u'
	elseif a:action ==# 'redo'
		let key = "\<C-r>"
	endif

	execute 'normal! ' . key
	let view_info.lnum = line('.')
	let view_info.col = col('.')

	if match(getline('.'), s:date_prefix) != -1
		execute 'normal! ' . key
		let view_info.lnum = line('.')
		let view_info.col = col('.')
	endif
	call winrestview(view_info)
endfunction
" }}}

" vim: nofoldenable
