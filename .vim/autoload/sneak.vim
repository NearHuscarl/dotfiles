" map_list is a list of mappings to be mapped to sneak functions after lazyload:
" [<SneakForwardNormal>, <SneakBackwardNormal>, <SneakForwardVisual>, <SneakBackwardVisual>]
function! s:SetupSneakPlugin(map_list) " {{{
	call plug#load('vim-sneak')

	silent! execute 'nnoremap <silent>' . a:map_list[0] . ' :<C-U>call sneak#wrap("",           3, 0, 2, 1)<CR>'
	silent! execute 'nnoremap <silent>' . a:map_list[1] . ' :<C-U>call sneak#wrap("",           3, 1, 2, 1)<CR>'
	silent! execute 'xnoremap <silent>' . a:map_list[2] . ' :<C-U>call sneak#wrap(visualmode(), 3, 0, 2, 1)<CR>'
	silent! execute 'xnoremap <silent>' . a:map_list[3] . ' :<C-U>call sneak#wrap(visualmode(), 3, 1, 2, 1)<CR>'
endfunction
" }}}
function! sneak#LazyloadForwardNormal(map_list) " {{{
	call s:SetupSneakPlugin(a:map_list)
	call sneak#wrap('', 3, 0, 2, 1)
endfunction
" }}}
function! sneak#LazyloadBackwardNormal(map_list) " {{{
	call s:SetupSneakPlugin(a:map_list)
	call sneak#wrap('', 3, 1, 2, 1)
endfunction
" }}}
function! sneak#LazyloadForwardVisual(map_list) " {{{
	call s:SetupSneakPlugin(a:map_list)
	call sneak#wrap(visualmode(), 3, 0, 2, 1)
endfunction
" }}}
function! sneak#LazyloadBackwardVisual(map_list) " {{{
	call s:SetupSneakPlugin(a:map_list)
	call sneak#wrap(visualmode(), 3, 1, 2, 1)
endfunction
" }}}
