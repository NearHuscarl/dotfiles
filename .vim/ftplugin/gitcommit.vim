setlocal nofoldenable
setlocal nolist

if has('localmap')
	nmap <buffer> <A-j> <C-n>zz| " Next file
	nmap <buffer> <A-k> <C-p>zz| " Prev file
	nmap <buffer> t O|           " Jump to the revision under the cursor in a new tab.
	nmap <buffer> v S|           " Jump to the revision under the cursor in a new vertical split
endif
