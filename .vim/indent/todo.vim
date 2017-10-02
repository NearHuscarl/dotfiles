" ============================================================================
" File:        todo.vim
" Description: indent rule for file with todo extension
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Mon Oct 02 03:01:43 +07 2017
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

function! s:GetCategoryNum(lineArg) " {{{
   let line = todo#TrimWhitespace(a:lineArg)
   return line[strlen(line) - 2]
endfunction " }}}
function! s:SearchBackwardCategory(lineNumArg) " {{{
   let categoryRegex = '^\s*\[\([xsXS _]\]\)\@![a-zA-Z0-9 ]*\] \[[0-9]\]'
   let tagRegex = '^<\(Archive\|Reminder\|Todo\)>'
   let result = todo#SearchBackward(a:lineNumArg, categoryRegex, tagRegex)

   if result.regex ==# categoryRegex
      return { 'num': s:GetCategoryNum(getline(result.lineNum)), 'indent': indent(result.lineNum) }
   elseif result.regex ==# tagRegex
      return { 'num': 'N/A', 'indent': indent(result.lineNum) }
   endif
   return { 'num': 0, 'indent': 0 }
endfunction " }}}
function! s:SearchBackwardCheckbox(lineNumArg) " {{{
   let parentCheckboxRegex = '^\s*\[[XS_]\].*'
   let checkboxRegex = '^\s*\[[xs ]\].*'
   let categoryRegex = '^\s*\[\([xsXS _]\]\)\@![a-zA-Z0-9 ]*\] \[[0-9]\]'
   let tagRegex = '^<\(Archive\|Reminder\|Todo\)>'
   let ENDcommentRegex = '^\s*# END'
   let result = todo#SearchBackward(a:lineNumArg, parentCheckboxRegex, checkboxRegex, categoryRegex, tagRegex, ENDcommentRegex)

   if result.regex ==# parentCheckboxRegex
      return { 'type': 'pcheckbox', 'indent': indent(result.lineNum) }
   elseif result.regex ==# checkboxRegex
      return { 'type': 'checkbox', 'indent': indent(result.lineNum) }
   elseif result.regex ==# categoryRegex
      return { 'type': 'category', 'indent': indent(result.lineNum) }
   elseif result.regex ==# tagRegex
      return { 'type': 'tag', 'indent': indent(result.lineNum) }
   elseif result.regex ==# ENDcommentRegex
      return { 'type': 'ENDcomment', 'indent': indent(result.lineNum) }
   endif
   return { 'type': 'none', 'indent': 0 }
endfunction " }}}
function! GetTodoIndent() " {{{
   let currentLine = getline(v:lnum)
   let prevLine = getline(v:lnum - 1)
   let prevIndent = indent(v:lnum - 1)

   " if current line is a category search upward for nearest category:
   "     if nearest line is a category with num less than current line, indent right 1
   "     if nearest line is a category with num larger than current line, indent left 1
   "     if nearest line is a category with num equal to current line, keep indent level
   "     if found tag instead of category, its the main category: indent once
   " if current line is a (checkbox|comment|emptyLine), search upward for the nearest checkbox
   "     if nearest line is parent checkbox: indent right 1
   "     if nearest line is child checkbox: keep indent level
   "     if nearest line is a category or tag: indent right 1
   "     if nearest line is "# END" without quote, indent left 1

   " if current line is a checkbox, comment or empty line
   if currentLine =~# '\(^\s*\[[xs XS_]\]\|^\s*#\|^\s*$\)'
      let result = s:SearchBackwardCheckbox(v:lnum)

      if result.type == 'pcheckbox' || result.type == 'category'
         return result.indent + &shiftwidth
      elseif result.type == 'checkbox' || result.type == 'none'
         return result.indent
      elseif result.type == 'tag'
         return result.indent + &shiftwidth
      elseif result.type == 'ENDcomment'
         return result.indent - &shiftwidth
      endif
   endif

   " if current line is a category
   if currentLine =~# '^\s*\[\([xsXS _]\]\)\@![a-zA-Z0-9 ]*\] \[[0-9]\]'
      let currentCategoryNum = s:GetCategoryNum(currentLine)
      let prevCategory       = s:SearchBackwardCategory(v:lnum)

      if prevCategory.num != 'N/A'
         return prevCategory.indent + &shiftwidth * (currentCategoryNum - prevCategory.num)
      else
         return prevCategory.indent + &shiftwidth
      endif
   endif

endfunction " }}}
