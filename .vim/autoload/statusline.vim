" ============================================================================
" File:        statusline.vim
" Description: Statusline setup for vim
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Thu Sep 14 08:56:20 +07 2017
" Licence:     BSD 3-Clause license
" Note:        N/A
" ============================================================================

"[|| Highlight()
function! s:Highlight(group, ...)
   let l:gui   = ['guifg', 'guibg']
   let l:cterm = ['ctermfg', 'ctermbg']
   let l:command = 'hi ' . a:group

   if (len(a:000) < 1) || (len(a:000) > (len(l:gui)))
      echoerr "No colour or too many colours specified"
   else
      for i in range(0, len(a:000)-1)
         let l:command .= ' ' . l:gui[i]   . '=' . a:000[i].gui
         let l:command .= ' ' . l:cterm[i] . '=' . a:000[i].cterm
      endfor
      exe l:command
   endif
endfunc 
command! -nargs=+ Hi call Highlight(<f-args>)
"||]
"[||InitModeColor()
function! statusline#InitModeColor()
   let l:mode = mode()
   if l:mode ==# 'n'
      call s:Highlight("StatusLine", s:normal.fg, s:normal.bg)
   elseif l:mode ==# 'i'
      call s:Highlight("StatusLine", s:insert.fg, s:insert.bg)
   elseif l:mode ==# 'v'
      call s:Highlight("StatusLine", s:visual.fg, s:visual.bg)
   elseif l:mode ==# 'V'
      call s:Highlight("StatusLine", s:vLine.fg, s:vLine.bg)
   elseif l:mode ==# "\<C-v>"
      call s:Highlight("StatusLine", s:vBlock.fg, s:vBlock.bg)
   elseif l:mode =~# '\v(R|Rc|Rv|Rx)'
      call s:Highlight("StatusLine", s:replace.fg, s:replace.bg)
   elseif l:mode =~# '\v(r|rm|r?)'
      call s:Highlight("StatusLine", s:prompt.fg, s:prompt.bg)
   endif
   return ""
endfunction
"||]
"[||GetMode()]
function! statusline#GetMode()
   let l:mode = mode()
   if l:mode ==# 'n'
      return "NORMAL"
   elseif l:mode ==# 'i'
      " echo "ahahhah"
      " hi User2 ctermfg=1 ctermbg=4
      return "INSERT"
   elseif l:mode ==# "\<C-v>"
      return "VBLOCK"
   elseif l:mode ==# 'v'
      return "VISUAL"
   elseif l:mode ==# 'V'
      return "VLINE"
   elseif l:mode =~# '\v(R|Rc|Rv|Rx)'
      return "REPLACE"
   elseif l:mode =~# '\v(r|rm|r?)'
      return "PROMPT"
   endif
endfunction
"||]
"[||SetFileSize()
function! statusline#SetFileSize()
    let bytes = getfsize(expand("%:p"))
    if bytes <= 0
        return "0b"
    endif
    if bytes < 1024
        return bytes . "b"
    elseif bytes < 1048576 "1024 x 1024 (1Mb)
        return (bytes / 1024) . "Kb"
    else
        return (bytes / 1048576) . "Mb"
    endif
endfunction
"||]
"[||SetWordCount()
function! statusline#SetWordCount()
   "CtrlP fucked-up workaround
   if expand('%:t') == 'ControlP' || expand('%:t') == 'LustyExplorer--BufferGrep'
      return g:wordCount
   endif

   let l:old_status = v:statusmsg
   let position = getpos(".")
   exe ":silent normal g\<C-g>"
   let l:stat = v:statusmsg
   let g:wordCount = 0
   if l:stat != '--No lines in buffer--'
     let g:wordCount = str2nr(split(v:statusmsg)[11]) "CtrlP error here
     let v:statusmsg = l:old_status
   endif
   call setpos('.', position)
   if g:wordCount == 1
      return g:wordCount . " Word"
   endif
   return g:wordCount . " Words"
endfunction
"||]
"[||Filename()
function! s:Filename()
   if expand('%:t') != ''
      return expand('%:t')
   endif
   return 'unnamed'
endfunction
"||]
"[||SetModified()
function! statusline#SetModified()
   if &modified
      call s:Highlight("User1", s:modified.fg, s:modified.bg)
      return '+'
   endif
   call s:Highlight("User1", s:filename.fg, s:filename.bg)
   return ''
endfunction
"||]
"[||IsReadOnly()
function! s:IsReadOnly()
   if &readonly
      return '  '
   endif
   return ''
endfunction
"||]
"[||SetLastModified()
function! statusline#SetLastModified()
   if strftime(("%d/%m/%y %T"), getftime(expand('%:t'))) != '(Invalid)'
      return strftime(("%d/%m/%y %T"), getftime(expand('%:t')))
   endif
   return 'No last saved'
endfunction
"||]
"[||Filetype()
function! s:Filetype()
   if &filetype != ''
      return &filetype
   endif
   return 'none'
endfunction
"||]
"[||BufferNumber()
function! s:BufNum()
   if &filetype != 'help'
      return '  ' . bufnr('%')
   endif
   return '  H'
endfunction
"||]
"[||GitStatus()
function! s:GitStatus()
   if g:loaded_fugitive
      let l:gitStatus = fugitive#head()
      if l:gitStatus != ''
         return ' ' . l:gitStatus . ' '
      endif
      return ''
   endif
endfunction
"||]
"[||CtrlP_Statusline()
function! statusline#CtrlPStatusline1(...)
   let focus   = '%4* '.a:1.' |'
   let byfname = ' '.a:2.' %*'
   let regex   = a:3 ? ' regex %*' : ''
   let prv     = '%1* '  . a:4 . ' '
   let item    = '%9* '  . a:5 . ' '
   let nxt     = '%1* '  . a:6 . ' |'
   let marked  = ' '.a:7.' '
   let dir     = '%=%4*%< ' . getcwd() . ' %*'
   return focus.byfname.regex.prv.item.nxt.marked.dir
endfunction

function! statusline#CtrlPStatusline2(...)
   let len = '%4* ' . a:1 . ' %1*'
   let dir = '%=%<%4* ' . getcwd() . ' %*'
   return len.dir
endfunction
"||]
"[||SetStatusline()
" This function is called when entering new buffer
function! statusline#SetStatusline()
   if has('statusline')

      let g:fileSize     = statusline#SetFileSize()
      let g:wordCount    = statusline#SetWordCount()
      let g:lastModified = statusline#SetLastModified()

      if exists('g:loaded_fugitive')
         let g:gitStatus = s:GitStatus()
      else
         let g:gitStatus = ''
      endif
      let g:filename     = s:Filename()
      let g:filetype     = s:Filetype()
      let g:bufnumber    = s:BufNum()
      let g:isReadOnly   = s:IsReadOnly()

      "http://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
      "https://vi.stackexchange.com/questions/6505/how-to-cut-trim-line-in-statusline/6506
      "Statusline (requires Powerline font, with highlight groups using Solarized theme)
      setlocal statusline=
      setlocal statusline+=%{g:bufnumber}\ \|\ |              "Buffer number
      setlocal statusline+=%{statusline#InitModeColor()} "Initiate mode color
      setlocal statusline+=%{statusline#GetMode()}\ |    "Show Current mode
      setlocal statusline+=%1*\ |                             "Switch to User1 highlight
      setlocal statusline+=%{g:filename}                      "Filename
      setlocal statusline+=%{statusline#SetModified()}   "Append "+" after filename if modified
      setlocal statusline+=%{g:isReadOnly}\ |                 "Is modificable or not
      setlocal statusline+=%2*\|\ |                           "Switch to User2 highlight
      setlocal statusline+=%{g:lastModified}\ |               "Last save time
      setlocal statusline+=%=                                 "Switch to the right side
      setlocal statusline+=%<                                 "Where to truncate line
      setlocal statusline+=%{g:filetype}\ \|\ |               "Filetype
      setlocal statusline+=%{g:fileSize}\ \|\ |               "Current file size
      setlocal statusline+=%{g:wordCount}\ |                  "Total words in a file
      setlocal statusline+=%3*                                "Switch to User3 highlight
      setlocal statusline+=%{g:gitStatus}                     "Show current git branch
      setlocal statusline+=%*                                 "Switch back to statusline highlight
      setlocal statusline+=\ %2p%%\ \|                        "Percentage through file in lines as in |CTRL-G|
      setlocal statusline+=\ %03l:%-2v\ |                     "Line number and column number

   endif
endfunction
"||]

let g:statusline_colors = g:colors_name
try
   call near#themes#{g:colors_name}#isAvailable()
catch
   let g:statusline_colors = "solarized"
endtry

" Make variable easier to read
let s:normal  = g:near#themes#{g:statusline_colors}#normal
let s:insert  = g:near#themes#{g:statusline_colors}#insert
let s:visual  = g:near#themes#{g:statusline_colors}#visual
let s:vLine   = g:near#themes#{g:statusline_colors}#vLine
let s:vBlock  = g:near#themes#{g:statusline_colors}#vBlock
let s:replace = g:near#themes#{g:statusline_colors}#replace
let s:prompt  = g:near#themes#{g:statusline_colors}#prompt

let s:inactive = g:near#themes#{g:statusline_colors}#inactive
let s:filename = g:near#themes#{g:statusline_colors}#filename
let s:modified = g:near#themes#{g:statusline_colors}#modified
let s:main     = g:near#themes#{g:statusline_colors}#main
let s:branch   = g:near#themes#{g:statusline_colors}#branch
let s:plugin   = g:near#themes#{g:statusline_colors}#plugin
let s:none     = g:near#themes#{g:statusline_colors}#none

" highlight! Statusline cterm=bold gui=bold
" highlight! User4      cterm=bold gui=bold

call s:Highlight("StatusLineNC", s:inactive.fg, s:inactive.bg)
call s:Highlight("User1",        s:filename.fg, s:filename.bg)
call s:Highlight("User2",        s:main.fg,     s:main.bg)
call s:Highlight("User3",        s:branch.fg,   s:branch.bg)
call s:Highlight("User4",        s:plugin.fg,   s:plugin.bg)
call s:Highlight("User9",        s:none.fg,     s:none.bg)
