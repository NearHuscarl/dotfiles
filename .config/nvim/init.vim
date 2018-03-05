" Program to use for evaluating Python code. Setting this makes startup faster
let g:python3_host_prog = '/usr/bin/python'
let g:loaded_python_provider = 1 " Disable python2

if !exists('os')
	if has('win32') || has('win64')
		let g:os = 'win'
	else
		let g:os = substitute(system('uname'), '\n', '', '')
	endif
endif

if g:os ==# 'win'
	set runtimepath^=~\vimfiles
	set runtimepath+=~\vimfiles\after
	source ~\vimfiles\vimrc
else
	set runtimepath^=~/.vim
	set runtimepath+=~/.vim/after
	source ~/.vim/vimrc
endif

let &packpath = &runtimepath

set inccommand=nosplit " like incsearch, but with command

" {{{ deoplete
let g:deoplete#enable_at_startup = 1
" }}}
