" ============================================================================
" File:        execute.vim
" Description: Run executable file
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Mon Nov 27 07:04:22 +07 2017
" Licence:     BSD 3-Clause license
" Note:        None
" ============================================================================

function! execute#File(...) " {{{
	let current_file =  expand('%:p')
	let term_cmd = &filetype . ' ' . current_file
	let term_flag = ' --hold '
	let arg = (a:0 != 0 ? a:1 : '')

	if !executable(current_file)
		echoerr 'File not executable'
		return
	endif

	" i3 will float window if window title name is Floating
	" see more at i3 config ($HOME/.config/i3/config)
	if executable('i3')
		let term_flag .= '--title=Floating'
	endif

	if empty($TERMINAL)
		let $TERMINAL = 'xterm'
	endif

	try
		call system('$TERMINAL -e "' . term_cmd . ' ' . arg . '"' . term_flag)
	endtry
endfunction
" }}}

" vim: nofoldenable
