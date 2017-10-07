" vim: nofoldenable

function! css#ToggleInsertImportant() " {{{
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
