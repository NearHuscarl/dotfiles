" ============================================================================
" File:        todo.vim
" Description: Custom mappings for todo file, see syntax/todo.vim
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Wed Sep 27 03:41:12 +07 2017
" Licence:     BSD 3-Clause license
" Note:        N/A
" ============================================================================

setlocal commentstring=#%s
setlocal foldmethod=indent

" let todoIndentLevel = 3

nnoremap <silent><buffer> q :q<CR>
nnoremap <silent><buffer> td :set opfunc=todo#ToggleDone<CR>g@_
nnoremap <silent><buffer> ts :set opfunc=todo#ToggleSuspend<CR>g@_
nnoremap <silent><buffer> ttd :set opfunc=todo#ToggleDone<CR>g@
nnoremap <silent><buffer> tts :set opfunc=todo#ToggleSuspend<CR>g@
nnoremap <silent><buffer> tks :set opfunc=todo#TickSuspend<CR>g@
nnoremap <silent><buffer> tkd :set opfunc=todo#TickDone<CR>g@
nnoremap <silent><buffer> tus :set opfunc=todo#UntickSuspend<CR>g@
nnoremap <silent><buffer> tud :set opfunc=todo#UntickDone<CR>g@
nnoremap <silent><buffer> tua :set opfunc=todo#UntickAll<CR>g@
nnoremap <silent><buffer> ti :call todo#InsertNewTask()<CR>|                " Make new task (same level)
nnoremap <silent><buffer> tc :call todo#InsertNewTask('c')<CR>|             " Make new child task
nnoremap <silent><buffer> tp :call todo#InsertNewTask('p')<CR>|             " Make new parent task
nnoremap <silent><buffer> <A-p> :call todo#JumpUpCategory()<CR>zz
nnoremap <silent><buffer> <A-n> :call todo#JumpDownCategory()<CR>zz
