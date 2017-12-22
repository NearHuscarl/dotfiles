" ============================================================================
" File:        ultisnips.vim
" Description: Ultisnips hack to use tab to expand snippet, popup or insert
"              literal tab depend on the context
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Wed Dec 06 14:35:11 +07 2017
" Licence:     BSD 3-Clause license
" Note:        None
" ============================================================================

" Try to expand snippet from ultisnips
" If not work, try to expand popup
" If not work, insert a literal tab
function! ultisnips#Expand() " {{{
	call UltiSnips#ExpandSnippet()
	if g:ulti_expand_res == 0
		if pumvisible()
			return "\<C-n>\<C-x>"
		else
			call UltiSnips#JumpForwards()
			if g:ulti_jump_forwards_res == 0
				return s:InsertTab()
				" return "\<Tab>"
			endif
		endif
	endif
	return ''
endfunction
" }}}
function! s:InsertTab() " {{{
	" Insert literal tab if cursor is before the first non whitespace character
	" else use expandtab option to insert n equivalent spaces
	if s:IsLeadingWhitespace()
		return "\<Tab>"
	else
		" Not sure how to make use of (expandtab|noexpandtab) yet
		" This function is mimics expandtab setting
		return s:InsertSpace()
	endif
endfunction
" }}}
function! s:IsLeadingWhitespace() " {{{
	let line = getline('.')
	let fromCursorToEOL = '\%>' . (col('.') - 1) . 'c.*'
	let queryRegex = substitute(line, fromCursorToEOL, '', '')

	if s:IsBlankLine(queryRegex)
		return 1
	endif
	return 0
endfunction
" }}}
function! s:IsBlankLine(line) " {{{
	if match(a:line, '^\s*$') != -1
		return 1
	endif
	return 0
endfunction
" }}}
function! s:InsertSpace() " {{{
	let tabWidth = &shiftwidth
	let space = ''
	while tabWidth > 0
		let space .= "\<Space>"
		let tabWidth -= 1 
	endwhile
	return space
endfunction
" }}}
function! ultisnips#Lazyload() " {{{
	" lazyload ultisnips make cursor move -> restore cursor pos
	let viewInfo  = winsaveview()
	call plug#load('ultisnips')
	call winrestview(viewInfo)

	inoremap <silent><Tab> <C-R>=ultisnips#Expand()<CR>
	return ultisnips#Expand()
endfunction
" }}}
