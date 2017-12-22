function! s:echo_hl(msg, hl_group) " {{{
	execute 'echohl ' . a:hl_group
	echo a:msg
	echohl None
endfunction
" }}}
function! toggle#wrap() " {{{
   if &wrap
      set nowrap
      nnoremap 0 ^
      onoremap 0 ^
      nnoremap ^ 0
      onoremap ^ 0
      nnoremap $ $
      call s:echo_hl('[wrap off]', 'DiffText')
   else
      set wrap
      nnoremap 0 g^
      onoremap 0 g^
      nnoremap ^ g0
      onoremap ^ g0
      nnoremap $ g$
      call s:echo_hl('[wrap on]', 'DiffText')
   endif
endfunction
" }}}
function! toggle#menubar() " {{{
   if &guioptions =~# 'm'
      set guioptions-=m
   else
      set guioptions+=m
   endif
endfunction
" }}}
function! toggle#verbose() " {{{
   if !&verbose
      set verbosefile=~/Desktop/verbose.log
      set verbose=15
      call s:echo_hl('set verbose=15', 'DiffText')
   else
      set verbose=0
      set verbosefile=
      call s:echo_hl('set verbose=0', 'DiffText')
   endif
endfunction
" }}}

" vim: nofoldenable
