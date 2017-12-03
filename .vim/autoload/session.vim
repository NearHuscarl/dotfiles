" ============================================================================
" File:        lazyload.vim
" Description: Functions to lazyload some plugins
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Sun Dec 03 11:34:31 +07 2017
" Licence:     BSD 3-Clause license
" Note:        Need vim-plug
" ============================================================================

function! s:SetupSessionPlugin() " {{{
   call plug#load('vim-misc')
   call plug#load('vim-shell')
   call plug#load('vim-session')
   nnoremap <Leader>so :SessionOpen<CR>
   nnoremap <Leader>sO :SessionOpen!<CR>
   nnoremap <Leader>ss :SessionSave<CR>
   nnoremap <Leader>sS :SessionSave<Space><C-d>
   nnoremap <Leader>sc :SessionClose<CR>
   nnoremap <Leader>sd :SessionDelete<CR>
   nnoremap <Leader>sv :SessionView<CR>
   nnoremap <Leader>sV :SessionView<Space><C-d>
endfunction
" }}}
function! session#LazyOpen() " {{{
   call s:SetupSessionPlugin()
   execute 'SessionOpen'
endfunction
" }}}
function! session#LazyOPEN() " {{{
   call s:SetupSessionPlugin()
   execute 'SessionOpen!'
endfunction
" }}}
function! session#LazySave() " {{{
   call s:SetupSessionPlugin()
   execute 'SessionSave'
endfunction
" }}}
function! session#LazySAVE() " {{{
   call s:SetupSessionPlugin()
   execute "normal! :SessionSave \<C-d>"
endfunction
" }}}
function! session#LazyClose() " {{{
   call s:SetupSessionPlugin()
   execute 'SessionClose'
endfunction
" }}}
function! session#LazyDelete() " {{{
   call s:SetupSessionPlugin()
   execute 'SessionDelete'
endfunction
" }}}
function! session#LazyView() " {{{
   call s:SetupSessionPlugin()
   execute 'SessionView'
endfunction
" }}}
function! session#LazyVIEW() " {{{
   call s:SetupSessionPlugin()
   execute "normal! :SessionView \<C-d>"
endfunction
" }}}
