" ============================================================================
" File:        retab.vim
" Description: An improved version of retab command which convert spaces into
"              tabs for indent only
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Sun Nov 05 01:46:20 +07 2017
" Licence:     BSD 3-Clause license
" Note:        Note
" ============================================================================

" To convert tabs into space:
" :set expandtab
" :set retab
" To convert spaces into tabs using &tabstop as tab width:
" :set noexpandtab
" :set retab!

" The following function convert leading spaces into tabs, ignore spaces after
" the first non-whitespace character
function! retab#Space2Tab() " {{{
	let leadingWhitespaceRegex = '\(^ *\)\@<= \{' . &tabstop . '}'
	if &gdefault
		execute 's/' . leadingWhitespaceRegex . '/\t/e'
	else
		execute 's/' . leadingWhitespaceRegex . '/\t/eg'
	endif
endfunction
" }}}
" Expand all found spaces into tabs and vice versa
function! retab#Space2TabAll() " {{{
	let oldExpandTab = &expandtab
	set noexpandtab
	retab!
	let &expandtab = oldExpandTab
endfunction
" }}}
function! retab#Tab2SpaceAll() " {{{
	let oldExpandTab = &expandtab
	set expandtab
	retab
	let &expandtab = oldExpandTab
endfunction
" }}}
