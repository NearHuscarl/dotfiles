" Program to use for evaluating Python code. Setting this makes startup faster
let g:loaded_python_provider = 1 " Disable python2

if !exists('os')
	if has('win32') || has('win64')
		let g:os = 'win'
	else
		let g:os = substitute(system('uname'), '\n', '', '')
	endif
endif

if g:os ==# 'win'
	let g:python3_host_prog = 'E:\Program Files\Python36\python'
	set runtimepath^=~\vimfiles
	set runtimepath+=~\vimfiles\after
	source ~\vimfiles\vimrc
else
	let g:python3_host_prog = '/usr/bin/python'
	set runtimepath^=~/.vim
	set runtimepath+=~/.vim/after
	source ~/.vim/vimrc
endif

let &packpath = &runtimepath

set inccommand=nosplit " like incsearch, but with command

" terminal mode {{{
" open terminal in 1/3 screen height vertical split
command! -nargs=* Term execute 'belowright ' .winheight(0)/4 ' split' | terminal <args>
tnoremap <Esc> <C-\><C-n>
tnoremap <A-n> <C-\><C-n><C-W>W
tnoremap <A-m> <C-\><C-n><C-W>w

augroup OpenTerminalInInsertMode
	autocmd!
	autocmd BufWinEnter,WinEnter term://* startinsert
augroup END
" }}}
" {{{ deoplete
let g:deoplete#enable_at_startup = 1
" }}}
