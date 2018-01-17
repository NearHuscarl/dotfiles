" Program to use for evaluating Python code. Setting this makes startup faster
let g:python3_host_prog = '/usr/bin/python'
let g:loaded_python_provider = 1 " Disable python2

set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vim/vimrc

set inccommand=nosplit " like incsearch, but with command

" {{{ deoplete
let g:deoplete#enable_at_startup = 1
" }}}
