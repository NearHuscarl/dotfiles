" A function to search for help on devdoc in vim
" https://gist.github.com/romainl/8d3b73428b4366f75a19be2dad2f0987

if has('win32') || has('win64')
   let s:open = "start"
elseif substitute(system('uname'), '\n', '', '') == 'Linux'
   let s:open = "xdg-open"
endif

function! help#GetHelpOxfordDictionary(...) " {{{
   let baseUrl = "http://www.oxfordlearnersdictionaries.com/definition/english/"
   if a:1 == 'cursor' && a:0 == 1
      call system(s:open . " '" . baseUrl . expand('<cword>') . "'")
   elseif a:1 == 'manual' && a:0 == 2
      call system(s:open . " '" . baseUrl . a:2 . "'")
   elseif
      echoerr 'Too many or too few arguments'
   endif
endfunction
" }}}

function! help#GetHelp(...) " {{{
   " Specific way to search help on devdoc
   if a:0 == 0
      call system(s:open . " 'http://devdocs.io/?q=" . &ft . ' ' . expand('<cword>') . "'")
   elseif a:0 == 1
      " call help#GetHelp('border')
      call system(s:open . " 'http://devdocs.io/?q=" . &ft . ' ' . a:1 . "'")
   elseif a:0 == 2
      " call help#GetHelp('css', 'border')
      call system(s:open . " 'http://devdocs.io/?q=" . a:1 . ' ' . a:2 . "'")
   endif
endfunction
" }}}
