" ============================================================================
" File:        todo.vim
" Description: functions for local mappings in todo files
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Mon Oct 23 17:05:30 +07 2017
" Licence:     BSD 3-Clause license
" Note:        N/A
" ============================================================================

try
   call plug#load('vim-easy-align')
endtry
" {{{ Wrapper Functions
function! todo#ToggleDoneVisual(type)
   call todo#ModifyCheckbox('toggle', 'x', '<', '>')
endfunction
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
   let range = lineBegin . ',' . lineEnd

   if a:action == 'tick'
      execute range . "call todo#TickCheckbox(a:char)"
   elseif a:action == 'untick'
      execute range . "call todo#UntickCheckbox(a:char)"
   elseif a:action == 'toggle'
      execute range . 'call todo#ToggleCheckbox(a:char)'
   endif

   call winrestview(viewInfo)
endfunction " }}}
function! todo#UntickCheckbox(char) " {{{
   let currentLine = getline('.')

   " Untick all
   if a:char == 'a'
      if match(currentLine, '^\s*\[[sx]\]\C') != -1
         execute "normal! ^lr "
      elseif match(currentLine, '^\s*\[[SX]\]\C') != -1
         execute "normal! ^lr_"
      endif
   endif

   if match(currentLine, '^\s*\[[sx]\]\C') != -1
      execute "normal! ^lr "
   elseif match(currentLine, '^\s*\[[SX]\]\C') != -1
      execute "normal! ^lr_"
   endif 
endfunction " }}}
function! todo#TickCheckbox(char) " {{{
   let currentLine = getline('.')

   if match(currentLine, '^\s*\[[^' . a:char . ']\]') != -1
      if match(currentLine, '^\s*\[[sx ]\]\C') != -1
         execute "normal! ^lr" . a:char
      elseif match(currentLine, '^\s*\[[SX_]\]\C') != -1
         execute "normal! ^lr" . toupper(a:char)
      endif
   endif
endfunction " }}}
function! todo#ToggleCheckbox(char) " {{{
   let currentLine = getline('.')

   if match(currentLine, '^\s*\[ \]') != -1
      execute "normal! ^lr" . a:char
   elseif match(currentLine, '^\s*\[_\]') != -1
      execute "normal! ^lr" . toupper(a:char)
   elseif match(currentLine, '^\s*\[[sx]\]\C') != -1
      execute "normal! ^lr "
   elseif match(currentLine, '^\s*\[[SX]\]\C') != -1
      execute "normal! ^lr_"
   endif
endfunction " }}}
function! todo#InsertNewTask(char) " {{{
   let autoindentOld = &autoindent
   set autoindent
   if a:char ==# 'c'
      let text = "[ ] "
   elseif a:char ==# 'p'
      let text = "[_] "
      let end = "# END"
      execute "normal! o\<Tab>" . end . "\<Esc>k"
   endif

   " match empty line
   if match(getline('.'), '^\s*$') != -1
      execute "normal! cc" . text
   " not empty line, open newline and insert task
   else
      execute "normal! o" . text
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
   let line = search('^\s*\[\([xs ]\]\)\@![a-zA-Z0-9 ]*\]', 'nb')
   " Use G and | instead of search() to add to the jumplist
   execute "normal! " . line . "G0"
endfunction " }}}
function! todo#JumpDownCategory() " {{{
   let line = search('^\s*\[\([xs ]\]\)\@![a-zA-Z0-9 ]*\]', 'n')
   execute "normal! " . line . "G0"
endfunction " }}}
function! todo#Delete() " {{{
   let currentLine  = getline('.')

   if match(currentLine, '^\s*\[[XS_]\]') != -1
      execute "normal! jzcdd"
   else
      execute "normal! dd"
   endif
endfunction " }}}
function! todo#TrimWhitespace(lineArg) " {{{
   let line = substitute(a:lineArg, '\s\+$', '', '')
   let line = substitute(line, '^\s\+', '', '')
   return line
endfunction " }}}
function! todo#SearchBackward(lineNumArg, ...) " {{{
   let lineNum = a:lineNumArg

   while lineNum > 0
      let lineNum = prevnonblank(lineNum - 1)
      for regex in a:000
         if getline(lineNum) =~# regex
            return {'regex': regex, 'lineNum': lineNum}
         endif
      endfor
   endwhile
   return -1
endfunction " }}}
function! todo#ToggleHighlightTask() " {{{
   let cursorInfo = [line('.'), col('.')]

   if match(getline('.'), '^\s*\[.\].*\*\*$') != -1
      execute "normal! $xxx"
   elseif match(getline('.'), '^\s*\[.\].*\(\*\*\)\@<!$') != -1
      let hl = ' **'
      execute "normal! A" . hl
   endif
   call cursor(cursorInfo[0], cursorInfo[1])
endfunction " }}}
