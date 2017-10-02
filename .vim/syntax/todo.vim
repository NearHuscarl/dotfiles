" ============================================================================
" File:        todo.vim
" Description: Vim syntax file: todo
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Mon Oct 02 16:43:26 +07 2017
" Licence:     BSD 3-Clause license
" Note:        todo file used to take note, reminder, and manage daily tasks
" ============================================================================

if exists("b:current_syntax")
  finish
endif

syn keyword todoType contained Archive Reminder Todo
syn region todoTag              start=+<[^/]+   end=+>+ contains=todoType
syn match todoTaskCategory       "^\s*\[\([xsXS _]\]\)\@![a-zA-Z0-9 ]*\]" nextgroup=todoTaskCategoryNumber
syn match todoArchiveDate        "^\s*\d\@<!\d\{2}\d\@!:\d\@<!\d\{2}\d\@!:\d\@<!\d\{2}\d\@! \d\@<!\d\{2}\d\@!\/\d\@<!\d\{2}\d\@!\/\d\@<!\d\{4}\d\@! [A-Z][a-z][a-z]" nextgroup=todoArchiveCategory
syn match todoArchiveCategory    "\[[a-zA-Z ]\{2,}\]" nextgroup=todoTaskCategoryNumber
syn match todoTaskCategoryNumber "\[[0-9]\]"
syn match todoComment            '^\s*#.*$'
syn match todoDone               "\[[xX]\] .*$"
syn match todoSuspend            "^\s*\[[sS]\].*$"
syn match todoNotDone            "^\s*\[[ _]\].*$"

" Tell vim what color to highlight
hi def link todoTag                String
hi def link todoType               Function
hi def link todoTaskCategory       Type
hi def link todoTaskCategoryNumber Identifier
hi def link todoNotDone            PreProc
hi def link todoComment            Comment
hi def link todoSuspend            Statement
hi def link todoArchiveDate        Statement
hi def link todoArchiveCategory    Type
hi def link todoDone               String

let b:current_syntax = "todo"
