" ============================================================================
" File:        todo.vim
" Description: Vim syntax file: todo
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Mon Oct 23 17:06:28 +07 2017
" Licence:     BSD 3-Clause license
" Note:        todo file used to take note, reminder, and manage daily tasks
" ============================================================================

if exists("b:current_syntax")
  finish
endif

syn match todoTaskCategory       "^\s*\[\([xsXS _]\]\)\@![a-zA-Z0-9 ]*\]" nextgroup=todoTaskCategoryNumber
syn match todoTaskCategoryNumber "\(\[\([xsXS _]\]\)\@![a-zA-Z0-9 ]\{2,}\] \+\)\@<=\[\d\]"

syn match todoComment            '^\s*#.*$'
syn match todoDone               "^\s*\[[xX]\].*\(\*\*\)\@<!$"
syn match todoNotDone            "^\s*\[[ _]\].*\(\*\*\)\@<!$"
syn match todoSuspend            "^\s*\[[sS]\].*\(\*\*\)\@<!$"

syn match todoDoneHighlight      "\(^\s*\)\@<=\[[xX]\].*\(\*\*\)$"
syn match todoNotDoneHighlight   "\(^\s*\)\@<=\[[ _]\].*\(\*\*\)$"
syn match todoSuspendHighlight   "\(^\s*\)\@<=\[[sS]\].*\(\*\*\)$"

" Custom highlight group
hi TodoDoneHighlight    ctermbg=black ctermfg=green  guibg=black guifg=green  cterm=reverse gui=reverse
hi TodoNotDoneHighlight ctermbg=black ctermfg=red    guibg=black guifg=red    cterm=reverse gui=reverse
hi TodoSuspendHighlight ctermbg=black ctermfg=yellow guibg=black guifg=yellow cterm=reverse gui=reverse

" Tell vim what color to highlight
hi def link todoTaskCategory       Type
hi def link todoTaskCategoryNumber Identifier

hi def link todoComment            Comment
hi def link todoDone               String
hi def link todoNotDone            PreProc
hi def link todoSuspend            Statement

hi def link todoDoneHighlight      TodoDoneHighlight
hi def link todoNotDoneHighlight   DiffDelete
hi def link todoSuspendHighlight   DiffChange

let b:current_syntax = "todo"
