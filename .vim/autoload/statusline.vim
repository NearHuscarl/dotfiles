" ============================================================================
" File:        statusline.vim
" Description: Statusline setup for vim
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Fri Dec 01 00:16:46 +07 2017
" Licence:     BSD 3-Clause license
" Note:        N/A
" ============================================================================

function! s:Highlight(group, ...) " {{{
	let gui   = ['guifg', 'guibg']
	let cterm = ['ctermfg', 'ctermbg']
	let command = 'hi ' . a:group

	if (len(a:000) < 1) || (len(a:000) > (len(gui)))
		echoerr "No colour or too many colours specified"
	else
		for i in range(0, len(a:000)-1)
			let command .= ' ' . gui[i]   . '=' . a:000[i].gui
			let command .= ' ' . cterm[i] . '=' . a:000[i].cterm
		endfor
		exe command
	endif
endfunction " }}}
function! statusline#InitModeColor() " {{{
	let mode = mode()
	if mode ==# 'n'
		call s:Highlight("StatusLine", s:normal.fg, s:normal.bg)
	elseif mode ==# 'i'
		call s:Highlight("StatusLine", s:insert.fg, s:insert.bg)
	elseif mode ==# 'v'
		call s:Highlight("StatusLine", s:visual.fg, s:visual.bg)
	elseif mode ==# 'V'
		call s:Highlight("StatusLine", s:vLine.fg, s:vLine.bg)
	elseif mode ==# "\<C-v>"
		call s:Highlight("StatusLine", s:vBlock.fg, s:vBlock.bg)
	elseif mode =~# '\v(R|Rc|Rv|Rx)'
		call s:Highlight("StatusLine", s:replace.fg, s:replace.bg)
	elseif mode =~# '\v(r|rm|r?)'
		call s:Highlight("StatusLine", s:prompt.fg, s:prompt.bg)
	endif
	return ""
endfunction " }}}
function! statusline#GetMode() " {{{
	let mode = mode()
	if mode ==# 'n'
		return "NORMAL"
	elseif mode ==# 'i'
		return "INSERT"
	elseif mode ==# "\<C-v>"
		return "VBLOCK"
	elseif mode ==# 'v'
		return "VISUAL"
	elseif mode ==# 'V'
		return "VLINE"
	elseif mode =~# '\v(R|Rc|Rv|Rx)'
		return "REPLACE"
	elseif mode =~# '\v(r|rm|r?)'
		return "PROMPT"
	endif
endfunction " }}}
function! statusline#SetFileSize() " {{{
	let bytes = getfsize(expand("%:p"))
	if bytes <= 0
		return "0b"
	endif
	if bytes < 1024
		return bytes . "b"
	elseif bytes < 1048576 "1024 x 1024 (1Mb)
		return (bytes / 1024) . "Kb"
	else
		return (bytes / 1024 / 1024) . "Mb"
	endif
endfunction " }}}
function! s:Filename() " {{{
	if expand('%:t') != ''
		return expand('%:t')
	endif
	return 'unnamed'
endfunction " }}}
function! statusline#SetModified() " {{{
	if &modified
		call s:Highlight("User1", s:modified.fg, s:modified.bg)
		return '+'
	endif
	call s:Highlight("User1", s:filename.fg, s:filename.bg)
	return ''
endfunction " }}}
function! s:IsReadOnly() " {{{
	if &readonly
		return '  '
	endif
	return ''
endfunction " }}}
function! s:Filetype() " {{{
	if &filetype != ''
		return &filetype
	endif
	return 'none'
endfunction " }}}
function! s:BufNum() " {{{
	if &filetype != 'help'
		return '  ' . bufnr('%')
	endif
	return '  H'
endfunction " }}}
function! s:GitStatus() " {{{
	if g:loaded_fugitive
		let gitStatus = fugitive#head()
		if gitStatus != ''
			return '│  ' . gitStatus . ' '
		endif
		return ''
	endif
endfunction " }}}
function! statusline#GetLinterStatus() " {{{
	let counts = ale#statusline#Count(bufnr(''))

	let all_errors = counts.error + counts.style_error
	let all_non_errors = counts.total - all_errors

	return counts.total == 0 ? 'OK' : printf('%dW %dE', all_non_errors, all_errors)
endfunction
" }}}
function! statusline#UpdateStatuslineInfo() " {{{
	let g:statuslineFileSize     = statusline#SetFileSize()
	if exists('g:loaded_fugitive')
		let g:statuslineGitStatus = s:GitStatus()
	else
		let g:statuslineGitStatus = ''
	endif
	let g:statuslineFilename     = s:Filename()
	let g:statuslineFiletype     = s:Filetype()
	let g:statuslineIsReadOnly   = s:IsReadOnly()
endfunction
" }}}
function! statusline#SetStatusline() " {{{
	" This function is called when entering new buffer
	if has('statusline')
		"http://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
		"https://vi.stackexchange.com/questions/6505/how-to-cut-trim-line-in-statusline/6506
		"Statusline (requires Powerline font, with highlight groups using Solarized theme)
		set statusline=
		set statusline+=\ %2p%%\ \│                        " Percentage through file in lines as in |CTRL-G|
		set statusline+=\ %{statusline#InitModeColor()}    " Initiate mode color
		set statusline+=%{statusline#GetMode()}\ |         " Show Current mode
		set statusline+=%1*\ |                             " Switch to User1 highlight
		set statusline+=%{g:statuslineFilename}            " Filename
		set statusline+=%{statusline#SetModified()}        " Append "+" after filename if modified
		set statusline+=%{g:statuslineIsReadOnly}\ |       " Is modificable or not
		set statusline+=%2*\ |                             " Switch to User2 highlight
		set statusline+=%=                                 " Switch to the right side
		set statusline+=%<                                 " Where to truncate line
		set statusline+=%{g:statuslineFiletype}\ \│\ |     " Filetype
		set statusline+=%{g:statuslineFileSize}\ \│\ |     " Current file size
		set statusline+=%{statusline#GetLinterStatus()}\ | " Total words in a file
		set statusline+=%{g:statuslineGitStatus}           " Show current git branch
		set statusline+=%*                                 " Switch back to statusline highlight
		set statusline+=\ %03l:%-2v\ |                     " Line number and column number
	endif
endfunction " }}}
" Highlight {{{
let g:statusline_colors = g:colors_name
try
	call near#themes#{g:colors_name}#isAvailable()
catch
	let g:statusline_colors = "solarized"
endtry

" Make variable easier to read
let s:normal  = g:near#themes#{g:statusline_colors}#normal
let s:insert  = g:near#themes#{g:statusline_colors}#insert
let s:visual  = g:near#themes#{g:statusline_colors}#visual
let s:vLine   = g:near#themes#{g:statusline_colors}#vLine
let s:vBlock  = g:near#themes#{g:statusline_colors}#vBlock
let s:replace = g:near#themes#{g:statusline_colors}#replace
let s:prompt  = g:near#themes#{g:statusline_colors}#prompt

let s:inactive  = g:near#themes#{g:statusline_colors}#inactive
let s:filename  = g:near#themes#{g:statusline_colors}#filename
let s:modified  = g:near#themes#{g:statusline_colors}#modified
let s:main      = g:near#themes#{g:statusline_colors}#main
let s:plugin    = g:near#themes#{g:statusline_colors}#plugin
let s:none      = g:near#themes#{g:statusline_colors}#none

" highlight! Statusline cterm=bold gui=bold
" highlight! User4      cterm=bold gui=bold

call s:Highlight("StatusLineNC", s:inactive.fg,  s:inactive.bg)
call s:Highlight("User1",        s:filename.fg,  s:filename.bg)
call s:Highlight("User2",        s:main.fg,      s:main.bg)
call s:Highlight("User4",        s:plugin.fg,    s:plugin.bg)
call s:Highlight("User9",        s:none.fg,      s:none.bg)

command! -nargs=+ Hi call Highlight(<f-args>)
" }}}

" vim: foldmethod=marker
