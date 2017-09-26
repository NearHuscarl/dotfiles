" ============================================================================
" File:        todo.vim
" Description: Vim syntax file: todo
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Tue Sep 26 03:03:42 +07 2017
" Licence:     BSD 3-Clause license
" Note:        todo file used to take note, reminder, and manage daily tasks
" ============================================================================

if exists("b:current_syntax")
  finish
endif

syn keyword todoType contained Archive Reminder Todo
syn region  todoTag          start=+<[^/]+   end=+>+ contains=todoType
syn region  todoTaskCategory start="^\["     end="\]"
syn match   todoComment      '^\s*#.*$'
syn match   todoDone         "^\s*\[x\].*$"
syn match   todoSuspend      "^\s*\[s\].*$"
syn match   todoNotDone      "^\s*\[ \].*$"

" Tell vim what color to highlight
hi def link todoTag          String
hi def link todoType         Function
hi def link todoTaskCategory Type
hi def link todoNotDone      PreProc
hi def link todoComment      Comment
hi def link todoSuspend      Statement
hi def link todoDone         String

let b:current_syntax = "todo"
