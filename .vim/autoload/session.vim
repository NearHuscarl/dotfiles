" ============================================================================
" File:        lazyload.vim
" Description: Functions to lazyload some plugins
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Sun Dec 03 13:02:17 +07 2017
" Licence:     BSD 3-Clause license
" Note:        Need vim-plug
" ============================================================================

" map_list is a list of mappings to be mapped to vim-session functions after lazyload:
" [
"   <SessionOpen>,
"   <SessionOPEN>,
"   <SessionSave>,
"   <SessionSAVE>,
"   <SessionSAVE>,
"   <SessionView>,
"   <SessionVIEW>,
"   <SessionClose>,
"   <SessionDelete>,
"   ]
function! s:SetupSessionPlugin(map_list) " {{{
   call plug#load('vim-misc')
   call plug#load('vim-shell')
   call plug#load('vim-session')

	silent! execute 'nnoremap <silent> ' . a:map_list[0] . ' :SessionOpen<CR>'
	silent! execute 'nnoremap <silent> ' . a:map_list[1] . ' :SessionOpen!<CR>'
	silent! execute 'nnoremap <silent> ' . a:map_list[2] . ' :SessionSave<CR>'
	silent! execute 'nnoremap <silent> ' . a:map_list[3] . ' :SessionSave<Space><C-d>'
	silent! execute 'nnoremap <silent> ' . a:map_list[4] . ' :SessionView<CR>'
	silent! execute 'nnoremap <silent> ' . a:map_list[5] . ' :SessionView<Space><C-d>'
	silent! execute 'nnoremap <silent> ' . a:map_list[6] . ' :SessionClose<CR>'
	silent! execute 'nnoremap <silent> ' . a:map_list[7] . ' :SessionDelete<CR>'
endfunction
" }}}
function! session#LazyOpen(map_list) " {{{
   call s:SetupSessionPlugin(a:map_list)
   execute 'SessionOpen'
endfunction
" }}}
function! session#LazyOPEN(map_list) " {{{
   call s:SetupSessionPlugin(a:map_list)
   execute 'SessionOpen!'
endfunction
" }}}
function! session#LazySave(map_list) " {{{
   call s:SetupSessionPlugin(a:map_list)
   execute 'SessionSave'
endfunction
" }}}
function! session#LazySAVE(map_list) " {{{
   call s:SetupSessionPlugin(a:map_list)
   execute "normal! :SessionSave \<C-d>"
endfunction
" }}}
function! session#LazyClose(map_list) " {{{
   call s:SetupSessionPlugin(a:map_list)
   execute 'SessionClose'
endfunction
" }}}
function! session#LazyDelete(map_list) " {{{
   call s:SetupSessionPlugin(a:map_list)
   execute 'SessionDelete'
endfunction
" }}}
function! session#LazyView(map_list) " {{{
   call s:SetupSessionPlugin(a:map_list)
   execute 'SessionView'
endfunction
" }}}
function! session#LazyVIEW(map_list) " {{{
   call s:SetupSessionPlugin(a:map_list)
   execute "normal! :SessionView \<C-d>"
endfunction
" }}}
