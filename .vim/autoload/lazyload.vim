" ============================================================================
" File:        lazyload.vim
" Description: Functions to lazyload some plugins
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Wed Oct 04 10:13:47 +07 2017
" Licence:     BSD 3-Clause license
" Note:        Need vim-plug
" ============================================================================

function! s:SetupSessionPlugin() " {{{
   call plug#load('vim-misc')
   call plug#load('vim-session')
   nnoremap <Leader>so :SessionOpen<CR>
   nnoremap <Leader>ss :SessionSave<CR>
   nnoremap <Leader>sS :SessionSave<Space><C-d>
   nnoremap <Leader>sc :SessionClose<CR>
   nnoremap <Leader>sd :SessionDelete<CR>
   nnoremap <Leader>sv :SessionView<CR>
   nnoremap <Leader>sV :SessionView<Space><C-d>
endfunction
" }}}
function! lazyload#SessionOpen() " {{{
   call s:SetupSessionPlugin()
   execute "SessionOpen"
endfunction
" }}}
function! lazyload#SessionSave() " {{{
   call s:SetupSessionPlugin()
   execute "SessionSave"
endfunction
" }}}
function! lazyload#SessionSAVE() " {{{
   call s:SetupSessionPlugin()
   execute "normal! :SessionSave \<C-d>"
endfunction
" }}}
function! lazyload#SessionClose() " {{{
   call s:SetupSessionPlugin()
   execute "SessionClose"
endfunction
" }}}
function! lazyload#SessionDelete() " {{{
   call s:SetupSessionPlugin()
   execute "SessionDelete"
endfunction
" }}}
function! lazyload#SessionView() " {{{
   call s:SetupSessionPlugin()
   execute "SessionView"
endfunction
" }}}
function! lazyload#SessionVIEW() " {{{
   call s:SetupSessionPlugin()
   execute "normal! :SessionView \<C-d>"
endfunction
" }}}
