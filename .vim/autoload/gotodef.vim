" ============================================================================
" File:        gotodef.vim
" Description: make gd command work again for certain filetypes
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Tue Dec 19 04:16:49 +07 2017
" Licence:     BSD 3-Clause license
" Note:        N/A
" ============================================================================

function! s:is_comment(line) " {{{
	let comment = substitute(&commentstring, '%s', '', '')
	return a:line =~ '^\s*\%(' . comment . '\|$\)'
endfunction
" }}}
function! s:get_function_def_pattern() " {{{
	if &filetype ==# 'python'
		return '^\s*\(class\|def\|async def\)\s\+\h'
	elseif &filetype ==# 'vim'
		return '^\s*fu\%[nction]\>!\?'
	elseif &filetype ==# 'javascript'
		return '^\s*function\s\+\h\w*('
	endif
endfunction
" }}}
function! gotodef#exe() " {{{
	" Fix gd command (:h gd) not working properly outside of C language
	" because gd use a builtin jump motion similar to [[ - go to the previous
	" '{' in the first column which only work for C-like language
	" Filetype support (for now): javascript, python, vimscript
	
	execute 'normal! m`'
	let current_line = line('.')
	let word_under_cur = expand('<cword>')
	let func_def_pattern = s:get_function_def_pattern()

	call search(func_def_pattern, 'bW')
	call search(word_under_cur, 'W')
	while s:is_comment(getline('.')) && line('.') < current_line
		call search(word_under_cur, 'W')
	endwhile
endfunction
" }}}
