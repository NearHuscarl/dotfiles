function! s:EchoHL(msg, hl_group) " {{{
	execute 'echohl ' . a:hl_group
	echomsg a:msg
	echohl None
endfunction
" }}}
function! syntax#GetGroup() " {{{
	" Get highlight group of word under the cursor
	let synID = synID(line('.'), col('.'), 1)
	call s:EchoHL(synIDattr(synID, 'name') . ' => ' . synIDattr(synIDtrans(synID), 'name'), 'String')
endfunction
" }}}
function! syntax#YankFgColor() " {{{
	" Only work in GUI (gvim)
	call s:YankColor('fg')
endfunction
" }}}
function! syntax#YankBgColor() " {{{
	" Only work in GUI (gvim)
	call s:YankColor('bg')
endfunction
" }}}
function! s:YankColor(layer) " {{{
	let color_hex = synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), a:layer)

	if empty(color_hex)
		call s:EchoHL('No color detected' ,'PreProc')
		return
	endif

	let @* = color_hex
	let @+ = color_hex

	call s:EchoHL('fg color ' . color_hex . ' has been copied to clipboard' ,'String')
endfunction
" }}}

" vim: nofoldenable
