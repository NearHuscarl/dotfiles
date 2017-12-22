setlocal commentstring=#\ %s

let sync_i3_win = '$HOME/script/bin/sync_i3_win.py'

if exists('*ExistsFile')
	if ExistsFile('$HOME/.vim/plugged/asyncrun.vim/')
		nnoremap <buffer> - :execute 'w <Bar> AsyncRun python ' . sync_i3_win<CR>
	else
		nnoremap <buffer> - :execute 'w <Bar> !python ' . sync_i3_win<CR>
	endif
endif
