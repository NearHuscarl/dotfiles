function! diff#JumpForward(defaultKey) " {{{
   if &diff
      execute "normal! ]czz"
   else
      execute strlen(a:defaultKey) != 0 ? "normal! " . a:defaultKey : ""
   endif
endfunction
" }}}
function! diff#JumpBackward(defaultKey) " {{{
   if &diff
      execute "normal! [czz"
   else
      execute strlen(a:defaultKey) != 0 ? "normal! " . a:defaultKey : ""
   endif
endfunction
" }}}
function! diff#DiffUpdate(defaultKey) " {{{
   if &diff
      execute "diffupdate"
   else
      execute strlen(a:defaultKey) != 0 ? "normal! " . a:defaultKey : ""
   endif
endfunction
" }}}
function! diff#Quit(defaultKey) " {{{
   if &diff
      execute "quit"
   else
      execute strlen(a:defaultKey) != 0 ? "normal! " . a:defaultKey : ""
   endif
endfunction
" }}}
