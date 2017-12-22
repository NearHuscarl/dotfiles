" Custom filetype detect
autocmd BufRead,BufNewFile *.todo *.Todo set ft=todo

autocmd BufWritePost *after/*.vim,*autoload/*.vim,*colors/*.vim,*ftdetect/*.vim,*ftplugin/*.vim,*indent/*.vim
			\ call source#Vimfile()
" Note: source#Vimfile() cannot source the file contain itself (autoload/source.vim)
" Because it cannot be redefined while still executing.
autocmd BufWritePost *autoload/source.vim
			\ runtime autoload/source.vim
			\|redraw
			\|echohl String | echo 'autoload/source.vim has been source!' | echohl None

autocmd BufWritePost *.Xresources call source#Xresources()

" Macro to bulkre(n)ame audio file (ranger):
" [EDM] Infectious - Tobu.mp3 -> [EDM] Tobu - Infectious.mp3
autocmd BufRead,BufNewFile *tmp/ let @n='0f vf-d$F.i -Ã©€klp€klxxj'

" Lazyload ultisnips (for syntax)
autocmd BufRead *.snippets silent! call plug#load('ultisnips')
