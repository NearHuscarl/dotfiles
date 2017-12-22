" ============================================================================
" File:        scss.vim
" Description: custom functions for mappings specifically to scss files
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Sat Oct 21 22:13:09 +07 2017
" Licence:     BSD 3-Clause license
" Note:        N/A
" ============================================================================

function! scss#ToggleInsertImportantRange(type) " {{{
   let range = line("'[") . ',' . line("']")
   execute range . "call scss#ToggleInsertImportant()"
endfunction
" }}}
function! scss#ToggleInsertImportant() " {{{
   let curPos = [line('.'), col('.')]
   if match(getline('.'), '!important;$') != -1
      execute "normal! $11hd3w"
   elseif match(getline('.'), '\(!important\)\@<!;$') != -1
      let text = ' !important'
      execute "normal! $i" . text
   endif
   call cursor(curPos[0], curPos[1])
endfunction
" }}}
function! s:GetCharUnderCursor() " {{{
   return matchstr(getline('.'), '\%' . col('.') . 'c.')
endfunction
" }}}
function! scss#Paste() " {{{
   " Extend paste for hex color
   let curPos = [line('.'), col('.')]

   if @+ =~? '^\(#[a-fA-F0-9]\{6}\>\|#[a-fA-F0-9]\{3}\>\)$' || @+ =~? '^\(rgb\|rgba\)(.*)$'
      if expand("<cWORD>") =~? '\(#[a-fA-F0-9]\{6}\>\|#[a-fA-F0-9]\{3}\>\)'
         if s:GetCharUnderCursor() == '#'
            execute 'normal! "_dehp'
         else
            execute 'normal! B"_dehp'
         endif
      elseif match(getline('.'), '\(rgb\|rgba\)(.*)') != -1
         execute "normal! ^"
         call search('\(rgb\|rgba\)(.*)', 'c')
         execute 'normal! "_df)hp'
      else
         execute "normal! p"
      endif
   else
      execute "normal! p"
   endif
   call cursor(curPos[0], curPos[1])
endfunction
" }}}
function! scss#CopyOrCut(action, default) " {{{
   " Extend copy for hex color
   let curPos = [line('.'), col('.')]
   if expand("<cWORD>") =~? '\(#[a-fA-F0-9]\{6}\>\|#[a-fA-F0-9]\{3}\>\)'
      if s:GetCharUnderCursor() != '#'
         execute 'normal! B'
      endif
      execute 'normal! ' . a:action . 'E'
   elseif match(getline('.'), '\(rgb\|rgba\)(.*)') != -1
      execute "normal! ^"
      call search('\(rgb\|rgba\)(.*)', 'c')
      execute "normal! " . a:action . "f)"
   else
      execute "normal! " . a:default
   endif
   call cursor(curPos[0], curPos[1])
endfunction
" }}}
function! s:Dec2Hex(num) " {{{
   return printf('%x', a:num + 0)
endfunction
function! s:Hex2Dec(num) " {{{
   return ('0x' . a:num) + 0
endfunction
" }}}
function! scss#ToggleHexOrRgb() " {{{
   let curPos = [line('.'), col('.')]
   let color = expand("<cWORD>")
   if color =~? '#[a-fA-F0-9]\{3,6}\>'
      if color =~? '#[a-fA-F0-9]\{6}\>'
         let colorList = [ color[1:2], color[3:4], color[5:6] ]
      elseif color =~? '#[a-fA-F0-9]\{3}\>'
         let colorList = [ color[1] . color[1], color[2] . color[2], color[3] . color[3] ]
      endif

      if s:GetCharUnderCursor() != '#'
         execute 'normal! B'
      endif
      let colorList[0] = s:Hex2Dec(colorList[0]) < 10 ? '0' . s:Hex2Dec(colorList[0]) : s:Hex2Dec(colorList[0])
      let colorList[1] = s:Hex2Dec(colorList[1]) < 10 ? '0' . s:Hex2Dec(colorList[1]) : s:Hex2Dec(colorList[1])
      let colorList[2] = s:Hex2Dec(colorList[2]) < 10 ? '0' . s:Hex2Dec(colorList[2]) : s:Hex2Dec(colorList[2])

      let rgba = 'rgba(' . colorList[0] . ',' . colorList[1] . ',' . colorList[2] . ',1)'

      execute "normal! dEi" . rgba
   elseif match(getline('.'), '\(rgb\|rgba\)(.*)') != -1
      let color = matchstr(getline('.'), '\(rgb\|rgba\)(.*)')
      let colorList = split(substitute(matchstr(color, '\(\d\+\).*\d\+'), ' ', '', 'g'), ',')

      let colorList[0] = strlen(s:Dec2Hex(colorList[0])) == 1 ? '0' . s:Dec2Hex(colorList[0]) : s:Dec2Hex(colorList[0])
      let colorList[1] = strlen(s:Dec2Hex(colorList[1])) == 1 ? '0' . s:Dec2Hex(colorList[1]) : s:Dec2Hex(colorList[1])
      let colorList[2] = strlen(s:Dec2Hex(colorList[2])) == 1 ? '0' . s:Dec2Hex(colorList[2]) : s:Dec2Hex(colorList[2])

      let hexcolor = '#' . colorList[0] . colorList[1] . colorList[2]
      execute "normal! ^"
      call search('\(rgb\|rgba\)(.*)', 'c')
      execute "normal! df)i" . hexcolor
   endif
   call cursor(curPos[0], curPos[1])
endfunction
" }}}

" vim: nofoldenable
