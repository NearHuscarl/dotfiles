" ============================================================================
" File:        license.vim
" Description: A function to auto update Last Change time, use with autocmd 
"              BufWrite, and a function for undo/redo mappings to skip
"              jumping to auto updated timestamp
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Sun Oct 08 12:57:34 +07 2017
" Licence:     BSD 3-Clause license
" Note:        N/A
" ============================================================================

let s:licenseDateRegex = '[A-Z][a-z]\{2} [A-Z][a-z]\{2} \d\@<!\d\{2}\d\@! \d\@<!\d\{2}\d\@!:\d\@<!\d\{2}\d\@!:\d\@<!\d\{2}\d\@! .* \d\@<!\d\{4}\d\@!'

function! license#SetLastChangeBeforeBufWrite() " {{{
   " Find the match between line 5 to 15 and replace it with current date
   " Match: Mon Sep 04 22:51:18 ICT 2017
   "        Mon Aug 14 13:38:15 +07 2017
   "        Mon Aug 14 13:38:15 -07 2017
   "        Tue Aug 15 15:34:13 Novosibirsk Standard Time 2017
   for line in range(5, 15)
      if match(getline(line), s:licenseDateRegex) != -1
         let view_info = winsaveview()
         let time = strftime('%a %b %d %H:%M:%S %Z %Y')
         silent! call cursor(line, 16)
         execute 'normal! "_Da' . time
         call winrestview(view_info)
         return
      endif
   endfor
endfunction " }}}

function! license#SkipLicenseDate(action) " {{{
   " Skip seeing changes in license date when doing an undo/redo
   let bang = ''
   let viewInfo  = winsaveview()

   if a:action == 'undo'
      " map u to this function so bang is used to avoid recursion
      let key = "u"
      let bang = "!"
   elseif a:action == 'redo'
      let key = "\<C-r>"
   endif

   execute "normal" . bang . " " . key
   let viewInfo.lnum = line('.')
   let viewInfo.col = col('.')

   if match(getline('.'), s:licenseDateRegex) != -1
      execute "normal" . bang . " " . key
      let viewInfo.lnum = line('.')
      let viewInfo.col = col('.')
   endif
   call winrestview(viewInfo)
endfunction " }}}

" vim: nofoldenable
