function! s:search_function_declaration() " {{{
	if &filetype ==# 'python'
		let function_def_pattern = '^\s*\(class\|def\|async def\)\s\+\h'
	elseif &filetype ==# 'vim'
		let function_def_pattern = '^\s*fu\%[nction]\>!\?'
	else " javascript
		let function_def_pattern = '^\s*function\s\+\h\w*('
	endif
	call search(function_def_pattern, 'bcW')
endfunction
" }}}
function! s:search_function_parenthesis(direction) " {{{
	if a:direction ==# 'forward'
		" call search() instead of normal! /{pattern} to avoid updating jumplist
		call search('\S\@<=(', 'cW')
	elseif a:direction ==# 'backward'
		call search('\S\@<=(', 'bcW')
	endif
endfunction
" }}}
function! operator#function_name_head(inner_or_all) " {{{
	call s:search_function_declaration()
	call s:search_function_parenthesis('forward')
	if a:inner_or_all ==# 'i'
		execute 'normal! hvb'
	elseif a:inner_or_all ==# 'a'
		execute 'normal! vabob'
	endif
endfunction
" }}}
function! operator#function_name(inner_or_all, direction) " {{{
	call s:search_function_parenthesis(a:direction)
	if a:inner_or_all ==# 'i'
		execute 'normal! hvb'
	elseif a:inner_or_all ==# 'a'
		execute 'normal! vabob'
	endif
endfunction
" }}}
