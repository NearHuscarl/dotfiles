" ============================================================================
" File:        statusline.vim
" Description: Statusline setup for vim
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Tue Dec 05 03:02:05 +07 2017
" Licence:     BSD 3-Clause license
" Note:        N/A
" ============================================================================

function! s:Highlight(group, ...) abort " {{{
	let gui   = ['guifg', 'guibg']
	let cterm = ['ctermfg', 'ctermbg']
	let command = 'highlight ' . a:group

	if len(a:000) < 1 || len(a:000) > len(gui)
		echoerr "No colour or too many colours specified"
	else
		for i in range(0, len(a:000)-1)
			let command .= ' ' . gui[i]   . '=' . a:000[i].gui
			let command .= ' ' . cterm[i] . '=' . a:000[i].cterm
		endfor
		execute command
	endif
endfunction " }}}
function! statusline#InitModeColor() abort " {{{
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
function! statusline#GetMode() abort " {{{
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
function! statusline#SetFileSize() abort " {{{
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
function! s:Filename() abort " {{{
	if expand('%:t') != ''
		return expand('%:t')
	endif
	return 'unnamed'
endfunction " }}}
function! statusline#SetModified() abort " {{{
	if &modified
		call s:Highlight("StatusLineFilename", s:modified.fg, s:modified.bg)
		return '+'
	endif
	call s:Highlight("StatusLineFilename", s:filename.fg, s:filename.bg)
	return ''
endfunction " }}}
function! s:IsReadOnly() abort " {{{
	if &readonly
		return '  '
	endif
	return ''
endfunction " }}}
function! s:Filetype() abort " {{{
	if &filetype != ''
		return &filetype
	endif
	return 'none'
endfunction " }}}
function! s:BufNum() abort " {{{
	if &filetype != 'help'
		return '  ' . bufnr('%')
	endif
	return '  H'
endfunction " }}}
function! s:GitStatus() abort " {{{
	if exists('g:loaded_fugitive') && g:loaded_fugitive
		let gitStatus = fugitive#head()
		if gitStatus != ''
			return '│  ' . gitStatus . ' '
		endif
	endif
	return ''
endfunction " }}}
function! statusline#GetLinterStatus() abort " {{{
	if exists('g:loaded_ale_dont_use_this_in_other_plugins_please')
				\ && g:loaded_ale_dont_use_this_in_other_plugins_please
		let counts = ale#statusline#Count(bufnr(''))
		let all_errors = counts.error + counts.style_error
		let all_non_errors = counts.total - all_errors

		return counts.total == 0 ? 'OK' : printf('%dW %dE', all_non_errors, all_errors)
	endif
	return ''
endfunction
" }}}
function! statusline#UpdateStatuslineInfo() abort " {{{
	let g:statuslineFileSize   = statusline#SetFileSize()
	let g:statuslineGitStatus  = s:GitStatus()
	let g:statuslineFilename   = s:Filename()
	let g:statuslineFiletype   = s:Filetype()
	let g:statuslineIsReadOnly = s:IsReadOnly()
endfunction
" }}}
function! statusline#SetStatusline() abort " {{{
	" This function is called when entering new buffer
	call statusline#SetHighlight()

	if has('statusline')
		"http://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
		"https://vi.stackexchange.com/questions/6505/how-to-cut-trim-line-in-statusline/6506
		"Statusline (requires Powerline font, with highlight groups using Solarized theme)
		set statusline=
		set statusline+=\ %2p%%\ \│                        " Percentage through file in lines
		set statusline+=\ %{statusline#InitModeColor()}    " Initiate mode color
		set statusline+=%{statusline#GetMode()}\ |         " Show Current mode
		set statusline+=%#StatusLineFilename#\ |           " Switch to StatusLineFilename highlight
		set statusline+=%{g:statuslineFilename}            " Filename
		set statusline+=%{statusline#SetModified()}        " Append "+" after filename if modified
		set statusline+=%{g:statuslineIsReadOnly}\ |       " Is modificable or not
		set statusline+=%#StatusLineMain#\ |               " Switch to StatusLineMain highlight
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
function! statusline#SetHighlight() abort " {{{
	" Custom statusline highlight (User1, StatusLineMain...)
	if !exists('g:statusline_colors') || g:statusline_colors != g:colors_name
		let g:statusline_colors = g:colors_name
		try
			call statusline#{g:colors_name}#isAvailable()
		catch /Unknown function/
			let g:statusline_colors = "solarized"
		endtry
	endif

	" Make variable easier to read
	let s:normal  = g:statusline#{g:statusline_colors}#normal
	let s:insert  = g:statusline#{g:statusline_colors}#insert
	let s:visual  = g:statusline#{g:statusline_colors}#visual
	let s:vLine   = g:statusline#{g:statusline_colors}#vLine
	let s:vBlock  = g:statusline#{g:statusline_colors}#vBlock
	let s:replace = g:statusline#{g:statusline_colors}#replace
	let s:prompt  = g:statusline#{g:statusline_colors}#prompt

	let s:inactive  = g:statusline#{g:statusline_colors}#inactive
	let s:filename  = g:statusline#{g:statusline_colors}#filename
	let s:modified  = g:statusline#{g:statusline_colors}#modified
	let s:main      = g:statusline#{g:statusline_colors}#main
	let s:plugin    = g:statusline#{g:statusline_colors}#plugin
	let s:none      = g:statusline#{g:statusline_colors}#none

	" highlight! Statusline cterm=bold gui=bold
	" highlight! StatusLinePlugin cterm=bold gui=bold

	call s:Highlight('StatusLineNC',       s:inactive.fg,  s:inactive.bg)
	call s:Highlight('StatusLineFilename', s:filename.fg,  s:filename.bg)
	call s:Highlight('StatusLineMain',     s:main.fg,      s:main.bg)
	call s:Highlight('StatusLinePlugin',   s:plugin.fg,    s:plugin.bg)
	call s:Highlight('StatusLineNone',     s:none.fg,      s:none.bg)
endfunction
" }}}

" vim: foldmethod=marker
