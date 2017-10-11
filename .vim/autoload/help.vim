" A function to search for help on devdoc in vim
" https://gist.github.com/romainl/8d3b73428b4366f75a19be2dad2f0987

function! help#GetHelp(...) " {{{
   if has('win32') || has('win64')
      let open = "start"
   elseif substitute(system('uname'), '\n', '', '') == 'Linux'
      let open = "xdg-open"
   endif

   if a:0 == 0
      call system(open . " 'http://devdocs.io/?q=" . &ft . ' ' . expand('<cword>') . "'")
   elseif a:0 == 1
      " call help#GetHelp('border')
      call system(open . " 'http://devdocs.io/?q=" . &ft . ' ' . a:1 . "'")
   elseif a:0 == 2
      " call help#GetHelp('css', 'border')
      call system(open . " 'http://devdocs.io/?q=" . a:1 . ' ' . a:2 . "'")
   endif
endfunction
" }}}
