" Open ide with path is current buffer's to debug

function! ide#Open(ideName) " {{{
	let path = expand('%p')

	if has('win32') || has('win64')
		let s:plugged = $HOME.'\vimfiles\plugged\'
	else
		let s:plugged = $HOME.'/.vim/plugged/'
	endif

	let cmd = a:ideName . ' ' . path
	if !empty(glob(s:plugged . 'asyncrun.vim'))
		execute 'AsyncRun ' . cmd
	else
		execute '!' . cmd
	endif
endfunction
" }}}

" vim: nofoldenable
