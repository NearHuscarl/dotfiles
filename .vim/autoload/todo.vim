" ============================================================================
" File:        todo.vim
" Description: functions for local mappings in todo files
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Wed Sep 27 03:40:58 +07 2017
" Licence:     BSD 3-Clause license
" Note:        N/A
" ============================================================================

" {{{ Wrapper Functions
function! todo#ToggleDone(type)
   call todo#ModifyCheckbox('toggle', 'x', '[', ']')
endfunction
function! todo#ToggleSuspend(type)
   call todo#ModifyCheckbox('toggle', 's', '[', ']')
endfunction
function! todo#TickDone(type)
   call todo#ModifyCheckbox('tick', 'x', '[', ']')
endfunction
function! todo#TickSuspend(type)
   call todo#ModifyCheckbox('tick', 's', '[', ']')
endfunction
function! todo#UntickDone(type)
   call todo#ModifyCheckbox('untick', 'x', '[', ']')
endfunction
function! todo#UntickSuspend(type)
   call todo#ModifyCheckbox('untick', 's', '[', ']')
endfunction
function! todo#UntickAll(type)
   call todo#ModifyCheckbox('untick', 'a', '[', ']')
endfunction
" }}}
function! todo#ModifyCheckbox(action, char, markBegin, markEnd) " {{{
   let viewInfo  = winsaveview()
   let lineBegin = line("'" . a:markBegin)
   let lineEnd   = line("'" . a:markEnd)
   let lineTotal = lineEnd  - lineBegin + 1
   let direction = lineBegin < lineEnd ? "down" : "up"

   while lineTotal > 0
      if a:action == 'tick'
         call todo#TickCheckbox(a:char)
      elseif a:action == 'untick'
         call todo#UntickCheckbox(a:char)
      elseif a:action == 'toggle'
         call todo#ToggleCheckbox(a:char)
      endif

      if direction == "down"
         execute "normal! j"
      else
         execute "normal! k"
      endif
      let lineTotal -= 1
   endwhile
   call winrestview(viewInfo)
endfunction " }}}
function! todo#UntickCheckbox(char) " {{{
   let currentLine = getline('.')
   let curPos = { 'line': getcurpos()[1], 'col': getcurpos()[2] }

   if match(currentLine, '^\s*\[.\]') != -1
      if a:char == 'a'
         execute "normal! ^lr "
      endif
      if a:char == 'x' && match(currentLine, '^\s*\[x\]') != -1
         execute "normal! ^lr "
      endif
      if a:char == 's' && match(currentLine, '^\s*\[s\]') != -1
         execute "normal! ^lr "
      endif
   else
      echo "No checkbox available"
   endif
   call cursor(curPos.line, curPos.col)
endfunction " }}}
function! todo#TickCheckbox(char) " {{{
   let currentLine = getline('.')
   let curPos = { 'line': getcurpos()[1], 'col': getcurpos()[2] }

   if match(currentLine, '^\s*\[.\]') != -1
      if a:char == 'x'
         " Go to the beginning of the line, insert x in checkbox
         execute "normal! ^lrx"
      elseif a:char == 's'
         execute "normal! ^lrs"
      else
         echoerr "Invalid Parameter"
      endif
   else
      echo "No checkbox available"
   endif
   call cursor(curPos.line, curPos.col)
endfunction " }}}
function! todo#ToggleCheckbox(char) " {{{
   let currentLine = getline('.')
   let curPos = { 'line': getcurpos()[1], 'col': getcurpos()[2] }

   if match(currentLine, '^\s*\[ \]') != -1
      if a:char == 'x'
         " Go to the beginning of the line, insert x in checkbox
         execute "normal! ^lrx"
      elseif a:char == 's'
         execute "normal! ^lrs"
      else
         echoerr "Invalid Parameter"
      endif
   elseif match(currentLine, '^\s*\[[sx]\]') != -1
      " Go to the beginning of the line, remove x in checkbox
      execute "normal! ^lr "
   else
      echo "No checkbox available"
   endif
   call cursor(curPos.line, curPos.col)
endfunction " }}}
function! IsInArchive() " {{{
endfunction " }}}
function! AddTaskInArchive() " {{{
endfunction " }}}
function! RemoveTaskInArchive() " {{{
endfunction " }}}
function! todo#InsertNewTask(...) " {{{
   let autoindentOld = &autoindent
   set autoindent
   let currentLine = getline('.')
   let aboveLine = getline(line('.') - 1)
   let text = "[ ] "
   if a:0 == 0
      let indent = ""
   elseif a:1 == 'c'
      let indent = '	'
   elseif a:1 == 'p'
      let indent = ''
   endif

   " match empty line
   if match(currentLine, '^\s*$') == 0
      " line above not empty, new task indented
      if match(aboveLine, '^\s*$') == -1
         execute "normal! ko" . indent . text
      " empty line, new task not indented
      else
         execute "normal! 0Da" . text
      endif
   " not empty line, open newline and insert task
   else
      execute "normal! o" . indent . text
   endif
   " go to insert mode
   call feedkeys('A', 'n')
   call s:RestoreAutoIndent(autoindentOld)
endfunction " }}}
function! s:GetIndent(arg) "{{{
   let indent = ''
   let level = a:arg
   while level > 0
      let indent = indent . ' '
      let level -= 1
   endwhile
   return indent
endfunction " }}}
function! s:RestoreAutoIndent(bool) " {{{
   if a:bool == 1
      set autoindent
   else
      set noautoindent
   endif
endfunction " }}}
function! todo#JumpUpCategory() " {{{
   " \@! -> negative lookahead
   " Match: [abc]
   "        [xterm]
   "        [sass]
   "        [mux]
   " Not Match: [x]
   "            [s]
   "            [ ]
   call search('^\s*\[\([xs ]]\)\@![a-zA-Z0-9 ]*\]', 'b')
endfunction " }}}
function! todo#JumpDownCategory() " {{{
   call search('^\s*\[\([xs ]]\)\@![a-zA-Z0-9 ]*\]')
endfunction " }}}
