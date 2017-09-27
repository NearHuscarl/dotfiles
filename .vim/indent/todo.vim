" ============================================================================
" File:        todo.vim
" Description: indent rule for file with todo extension
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Thu Sep 28 02:53:23 +07 2017
" Licence:     BSD 3-Clause license
" Note:        N/A
" ============================================================================

" Only load this indent file when no other was loaded.
if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal autoindent
setlocal indentexpr=GetTodoIndent()

" indentexpr not working when these are set
setlocal nolisp
setlocal nosmartindent

function! GetTodoIndent() " {{{
   let currentLine = getline(v:lnum)
   let prevLine = getline(v:lnum - 1)
   let prevIndent = indent(v:lnum - 1)

   " if the previous line was indenting and is a checkbox, keep indent level
   if prevLine =~ '^\s*\[[xs ]\]'
      return prevIndent
   endif

   " if the previous line was indenting and is a category, indent one more
   if prevLine =~ '^\s*\[\([xs ]]\)\@![a-zA-Z0-9 ]*\]'
      return prevIndent + &shiftwidth
   endif

   " if the previous line was tag, only indent once
   if prevLine =~ '^<\(Archive\|Reminder\|Todo\)>'
      return &shiftwidth
   endif
endfunction " }}}
