" ============================================================================
" File:        todo.vim
" Description: Custom mappings for todo file, see syntax/todo.vim
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Wed Oct 25 02:34:56 +07 2017
" Licence:     BSD 3-Clause license
" Note:        N/A
" ============================================================================

setlocal commentstring=#%s
setlocal foldmethod=indent

" let todoIndentLevel = 3

nnoremap <silent><buffer> q :q<CR>

nnoremap <silent><buffer> f          :set opfunc=todo#ToggleDone<CR>g@l|            " Fixed
nnoremap <silent><buffer> <Leader>d  :set opfunc=todo#ToggleDone<CR>g@
nnoremap <silent><buffer> s          :set opfunc=todo#ToggleSuspend<CR>g@l
nnoremap <silent><buffer> <Leader>s  :set opfunc=todo#ToggleSuspend<CR>g@
xnoremap <silent><buffer> <Leader>d  :<C-u>call todo#ToggleDoneVisual('block')<CR>

nnoremap <silent><buffer> td         :set opfunc=todo#TickDone<CR>g@
nnoremap <silent><buffer> ts         :set opfunc=todo#TickSuspend<CR>g@

nnoremap <silent><buffer> tS         :set opfunc=todo#UntickSuspend<CR>g@
nnoremap <silent><buffer> tD         :set opfunc=todo#UntickDone<CR>g@
nnoremap <silent><buffer> tA         :set opfunc=todo#UntickAll<CR>g@

nnoremap <silent><buffer> th    :call todo#ToggleHighlightTask()<CR>

nnoremap <silent><buffer> ti    :call todo#InsertNewTask('c')<CR>|  " Make new child task
nnoremap <silent><buffer> tI    :call todo#InsertNewTask('p')<CR>|  " Make new parent task

nnoremap <silent><buffer> <A-p> :call todo#JumpUpCategory()<CR>zz
nnoremap <silent><buffer> <A-n> :call todo#JumpDownCategory()<CR>zz

" nnoremap <silent><buffer> dd    :call todo#Delete()<CR>
nnoremap <silent><buffer> tr    :call todo#Restore()<CR>
" dd to delete task and subtask
