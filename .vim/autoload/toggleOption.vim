" vim: nofoldenable

function! toggleOption#Wrap() " {{{
   if &wrap
      set nowrap
      nnoremap 0 ^
      onoremap 0 ^
      nnoremap ^ 0
      onoremap ^ 0
      nnoremap $ $
      echo "wrap off"
   else
      set wrap
      nnoremap 0 g^
      onoremap 0 g^
      nnoremap ^ g0
      onoremap ^ g0
      nnoremap $ g$
      echo "wrap on"
   endif
endfunction
" }}}
function! toggleOption#MenuBar() " {{{
   if &guioptions =~# 'm'
      set guioptions-=m
   else
      set guioptions+=m
   endif
endfunction
" }}}
function! toggleOption#Verbose() " {{{
   if !&verbose
      set verbosefile=~/Desktop/verbose.log
      set verbose=15
      echo "Set verbose=15"
   else
      set verbose=0
      set verbosefile=
      echo "Set verbose=0"
   endif
endfunction
" }}}
