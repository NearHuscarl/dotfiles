" ============================================================================
" File:        .vimrc
" Description: Vim settings
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Tue Dec 05 10:17:58 +07 2017
" Licence:     BSD 3-Clause license
" Note:        This is a personal vim config. therefore most likely not work 
"              on your machine
" ============================================================================

" {{{ Variables

if !exists('os')
	if has('win32') || has('win64')
		let os = 'win'
	else
		let os = substitute(system('uname'), '\n', '', '')
	endif
endif

let is_nvim = 0
if has('nvim')
	let is_nvim = 1
endif

if g:os ==# 'win'
	let s:autoload = $HOME.'\vimfiles\autoload\'
	let s:plugged  = $HOME.'\vimfiles\plugged\'
	let s:session  = $HOME.'\vimfiles\session\'
	let s:snippet  = $HOME.'\vimfiles\snippet\'
	let s:swapfile = $HOME.'\vimfiles\swapfiles//'
	let s:undo     = $HOME.'\vimfiles\undo\'
else
	let s:autoload = $HOME.'/.vim/autoload/'
	let s:plugged  = $HOME.'/.vim/plugged/'
	let s:session  = $HOME.'/.vim/session/'
	let s:snippet  = $HOME.'/.vim/snippet/'
	let s:swapfile = $HOME.'/.vim/swapfiles//'
	let s:undo     = $HOME.'/.vim/undo/'
endif

let mapleader = "\<Space>"

" }}}
"{{{ Function
function! ExistsFile(path) " {{{
	return !empty(glob(a:path))
endfunction
" }}}
function! s:BufferIsEmpty() " {{{
	 if (line('$') == 1 && getline(1) ==# '') && (filereadable(@%) == 0)
		  return 1
	 endif
	 return 0
endfunction
" }}}
function! s:CloseEmptyBuffer() " {{{
	let t:NumOfWin = winnr('$')
	while t:NumOfWin >= 1
		execute 'wincmd p'
		if s:BufferIsEmpty()
			while s:BufferIsEmpty() && t:NumOfWin >= 1
				execute 'bdelete'
				let t:NumOfWin -= 1
			endwhile
		endif
		let t:NumOfWin -= 1
	endwhile
endfunction
" }}}
"}}}
"{{{ Basic Setup

autocmd!

if g:os ==# 'Linux' && !has('gui_running') && !is_nvim
	" Fix alt key not working in gnome-terminal
	" if \e not work, replace with  (<C-v><C-[>)
	let charList = [
				\ 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',
				\ 'p','q','r','s','t','u','v','w','x','y','z','1','2','3','4',
				\ '5','6','7','8','9','0', ',', '.', '/', ';',"'",'\','-','=']
	for char in charList
		execute 'set <A-' .char. ">=\e" .char
		execute "imap \e" .char. ' <A-' .char. '>'
	endfor
	" execute "set <A-]>=\e]"
	" execute "inoremap \e] <A-]>"

	execute 'set <A-[>=<C-[>'
	execute "inoremap \e[ <c-[>"
endif

set fileformat=unix
set t_Co=256                                       "More color
set encoding=utf-8                                 "Enable the use of icon or special char
scriptencoding utf-8                               "Need this for nerdtree to work properly

filetype on
filetype plugin on
filetype indent on
syntax on                                          "Color my code

if !exists('g:colors_name')
	try
		colorscheme flat
	catch /Cannot find color scheme/
		colorscheme evening
	endtry
endif

set hidden                                         "Make buffer hidden once modified

set ignorecase                                     "Ignore case when searching words
set smartcase                                      "Overwrite ignorecase if query contains uppercase
set incsearch                                      "Vim start searching while typing characters
set hlsearch                                       "Highlight all search matchs
set gdefault                                       "Substitute with flag g by default

set cursorline                                     "Highlight current line
set selection=inclusive                            "Last character is included in an operation
set scrolloff=4                                    "Min lines at 2 ends where cursor start to scroll

set wildmenu                                       "Visual Autocomplete in cmd menu
set wildmode=list:full
set completeopt=menu,longest
set complete-=i                                    "An attempt to make YCM faster

if has('GUI_running')
	" :put =&guifont
	if g:os ==# 'win'
		set guifont=Fura_Code_Light:h8:cANSI:qDRAFT,Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
	else
		set guifont=DejaVu\ Sans\ Mono\ Bold\ 8
	endif
	set guioptions-=m                               "Remove menu bar
	set guioptions-=T                               "Remove toolbar
	set guioptions-=r                               "Remove right-hand scroll bar
	set guioptions-=L                               "Remove left-hand scroll bar
endif

set selectmode=mouse                               "Trigger select mode when using mouse
set nomousefocus                                   "Hover mouse wont trigger other pane
set backspace=indent,eol,start                     "Backspace behave like in other app
set confirm                                        "Confirm to quit when quit without save

set laststatus=2
if has('persistent_undo')                          "check if your vim version supports it
	set undofile                                    "turn on the feature
	let &undodir = s:undo                           "Location to store undo files
	set undolevels=2000                             "Number of changes that can be undo
	set undoreload=5000                             "Number of max lines to be saved for undo
endif
let &directory = s:swapfile
"Set directory for swap files
set autoindent                                     "Copy indent from current line when insert newline
set clipboard^=unnamed                             "Use * register (use Ctrl+C, Ctrl+X or Ctrl+V)
set clipboard^=unnamedplus                         "Use + register (use Mouse selection or Middlemouse)

set number                                         "Set line number on startup
set relativenumber                                 "Choose relave number to make moving between line easier
set numberwidth=2                                  "Number Column width

set nobackup                                       "No fucking backup
set noshowmode                                     "Dont show --INSERT-- or --VISUAL--
set showmatch                                      "Highlight matching parenthesis when make the other one
set showcmd                                        "Show command as you type

set textwidth=0                                    "No insert newline when max width reached
set wrapmargin=0                                   "Number of chars outside the width limit before wrapping (disable)
set formatoptions-=t                               "Keep textwidth setting in existing files
set formatoptions+=j                               "Remove a comment leader when joining lines 
set wrap                                           "Turn off auto wrap
set showbreak=⤷\                                  "Characters at the start of wrapped lines
if has('linebreak')
	set linebreak                                   "Wrap long lines at last words instead of the last characters
	set breakindent                                 "Keep the indent level after wrapping
endif

set synmaxcol=228                                  "Maximum column for syntax highlighting
set lazyredraw                                     "An attempt to make scrolling smoother

set list                                           "Enable listchars option
set listchars=tab:\│\ ,extends:»,precedes:«,trail:·,nbsp:·
" set expandtab                                      "When press tab, convert into n spaces
set tabstop=3                                      "Set how many columns a tab count for
set shiftwidth=3                                   "Set how many column is indented with >> and <<
set softtabstop=3                                  "How many column insert when press tab
set smarttab                                       "Insert tab according to shiftwidth
set backspace=2                                    "Backspace normal behaviour

set diffopt+=vertical                              "Open diff window in vertical split
set diffopt+=context:1000                          "No fold in diff mode

set noerrorbells                                   "Disable error beep
set novisualbell                                   "Disable flashing error
set t_vb=                                          "Disable error beep in terminal
set belloff=all                                    "Just shut the fuck up

if has('mksession')
	set sessionoptions-=options                     "Do not store settings and mappings in session
endif

set tags=./tags;/                                  "Search for tags file in current dir up to root
set history=10000                                  "Set number of commands and search to be remembered
set grepprg=rg\ --vimgrep

set wildignore+=*.7z,*.bin,*.doc,*.docx,*.exe,*.ico,*.gif,*.jpg,*.jpeg,*.mp3,*.otf,*.pak,*.pdf
set wildignore+=*.png,*.ppt,*.pptx,*.rar,*.swp,*.sfdm,*.xls,*.xlsx,*.xnb,*.zip

if has('folding')
	set foldenable
	set foldmethod=marker
	" set foldopen=all
endif

if has('GUI_running') && has('windows')
	set guitablabel=\[%N\]\ %t\ %M                  "Tabs only display file name rather than path+filename
endif
let @n = "0f>a\<CR>\<Esc>$F<i\<CR>\<Esc>j"         "Newline per tag if not
"}}}
" {{{ Mappings

" {{{ Open / Source file
nnoremap <Leader>tv :edit $MYVIMRC<Bar>CloseEmptyBuffer<CR>
nnoremap <silent>,v :call source#Vimrc()<CR>
nnoremap <silent>,, :call source#Vimfile()<CR>
" }}}
" {{{ Movement
nnoremap ;   :|                                    "No need to shift ; anymore to enter command mode
nnoremap gh  h|                                    "Move 1 character to the right
nnoremap gl  l|                                    "Move 1 character to the left
nnoremap :   =|                                    "Indent + motion
nnoremap :: ==|                                    "Indent

vnoremap l  ;
vnoremap h  ,
vnoremap gh h
vnoremap gl l
vnoremap :  =
vnoremap :: ==
" }}}
" {{{ Buffer
nnoremap <silent><A-'> :bnext<CR>|                 "Go to the next buffer
nnoremap <silent><A-;> :bprevious<CR>|             "Go to the previous buffer
nnoremap <silent><A-e> :enew<CR>|                  "Edit new buffer
nnoremap <silent><A-b> :buffer#<CR>|               "Switch between last buffers
nnoremap <silent><Leader>q :bprevious <Bar>:bdelete #<CR>| "Delete current buffer
nnoremap <silent><Leader>x :e#<CR>|                "Open last closed buffer (not really)
" }}}
" {{{ Pane
nnoremap <A-m>     <C-w>w|                         "Cycle through panes
nnoremap <A-n>     <C-w>W|                         "Cycle through panes (backward)
nnoremap <A-r>     <C-w>r|                         "Rotate pane down/right
nnoremap <A-R>     <C-w>R|                         "Rotate pane up/left
nnoremap <Leader>L <C-w>L|                         "Move current pane to the far left
nnoremap <Leader>H <C-w>H|                         "Move current pane to the far right
nnoremap <Leader>K <C-w>K|                         "Move current pane to the very top
nnoremap <Leader>J <C-w>J|                         "Move current pane to the very bottom
" }}}
" {{{ Tab
nnoremap <silent><Leader><Tab> :tabnew<CR>|        "Make a new tab
nnoremap <silent><A-,> :tabprevious<CR>|           "Go to next tab
nnoremap <silent><A-.> :tabnext<CR>|               "Go to previous tab
" }}}
" {{{ Resize window
nnoremap <silent><A--> :vert res -5<CR>|           "Decrease window width by 5
nnoremap <silent><A-=> :vert res +5<CR>|           "Increase window width by 5
nnoremap <silent><A-_> :resize -5<CR>|             "Decrease window height by 5
nnoremap <silent><A-+> :resize +5<CR>|             "Increase window height by 5
" }}}
" {{{ Jump
nnoremap gy g<C-]>zz|                              "Jump to definition (Open tag list if there are more than 1 tag)
nnoremap gk <C-t>zz|                               "Jump back between tag
nnoremap gj :tag<CR>zz|                            "Jump forward between tag
nnoremap <A-\> :OpenTagInVSplit<CR>zz|             "Open tag in vertical split
nnoremap ' `|                                      "' to jump to mark (line and column)
nnoremap ` '|                                      "` to jump to mark (line)
nnoremap j gj|                                     "j version that treat wrapped line as another line
nnoremap k gk|                                     "k version that treat wrapped line as another line

if has('jumplist')
	nnoremap <A-o> <C-o>|                           "Jump back (include non-tag jump)
	nnoremap <S-o> <C-i>|                           "Jump forward (include non-tag jump)
	nnoremap <A-9> g;|                              "Jump backward
	nnoremap <A-0> g,|                              "Jump forward
endif

if &wrap
	nnoremap 0 g^|    "Go to the first non-blank character of the line, treat wrapped line as another line
	onoremap 0 g^
	nnoremap ^ g0|    "Go to the first character of the line, treat wrapped line as another line
	onoremap ^ g0
	nnoremap $ g$|    "$ version that treat wrapped line as another line
else
	nnoremap 0 ^|     "Go to the first non-blank character of the line
	onoremap 0 ^
	nnoremap ^ 0|     "Go to the first character of the line
	onoremap ^ 0
endif


nnoremap { {zz|                                    "Jump between paragraph (backward) and zz
nnoremap } }zz|                                    "Jump between paragraph (forward) and zz
" nnoremap n nzzzo
" nnoremap N Nzzzo
" }}}
" {{{ Fold
" nnoremap <A-j> zjzz
" nnoremap <A-k> zk[zzz
nnoremap z[ zo[z|                                  "Open fold, jump at the start and zz
nnoremap z] zo]z|                                  "Open fold, jump at the end and zz
nnoremap ]z ]zzz|                                  "jump at the end and zz
nnoremap [z [zzz|                                  "jump at the start and zz
nnoremap <Leader>z zMzv|                           "Open current fold and close all other fold outside
" }}}
" {{{ Diff
nnoremap <silent> L  :call diff#JumpForward('L')<CR>|  "In diff mode: go to next change
nnoremap <silent> H  :call diff#JumpBackward('H')<CR>| "In diff mode: go to previous change
nnoremap <silent> du :call diff#DiffUpdate('')<CR>|    "Update diff if it doesnt update automatically
" nnoremap <silent> q  :call diff#Quit('q')<CR>|         "Quit Key in diff
" }}}
" {{{ Help
nnoremap Kc K|                                     "Help for word under cursor
nnoremap <silent> Ke :call help#GetHelpOxfordDictionary('cursor')<CR>
nnoremap Kd :GetHelp<Space>|                       "Search for help on (d)evdoc
nnoremap Kh :OpenHelpInTab<CR>|                    "Open help about the word under cursor
nnoremap Ka
			\ :grep! "<C-R><C-W>"<CR><Bar>
			\ :copen 20<CR>|                          "Find word under cursor in current working directory
" }}}
" {{{ Pair
nnoremap <silent>]t :tnext<CR>|                    "Go to next tag in the tag list
nnoremap <silent>[t :tprevious<CR>|                "Go to next tag in the tag list
nnoremap <silent>]c ]czz|                          "Jump forward change and zz
nnoremap <silent>[c [czz|                          "Jump backward change and zz
nnoremap <silent>]q :cnext<CR>|                    "Jump to the next quickfix item
nnoremap <silent>[q :cprev<CR>|                    "Jump to the previous quickfix item
nnoremap <silent>]Q :clast<CR>|                    "Jump to the previous quickfix item
nnoremap <silent>[Q :cfirst<CR>|                   "Jump to the previous quickfix item
" }}}
" {{{ Insert Mode
inoremap <A-9> <C-w>|                              "Delete previous word
inoremap <A-0> <Esc>lmaed`axi|                     "Delete next word
inoremap <A-Space> <BS>|                           "Delete 1 character
inoremap <A-;> <C-Left>|                           "Go to the previous word
inoremap <A-'> <C-Right>|                          "Go to the next word
inoremap <A-r> <C-r>|                              "Insert register ...
inoremap <A-m> <Esc>zzli|                          "Make current line the center of window
inoremap <S-Tab> <C-p>|                            "Go to previous selection in comepletion menu
inoremap <A-v> <C-v>|                              "Insert special character
" }}}
" {{{ Popup
inoremap <expr><A-n>   pumvisible() ? "\<Down>"        : "\<C-n>"
inoremap <expr><A-p>   pumvisible() ? "\<Up>"          : ""
inoremap <expr><A-j>   pumvisible() ? "\<C-x>\<Down>"  : "\<Down>"
inoremap <expr><A-k>   pumvisible() ? "\<C-x>\<Up>"    : "\<Up>"
inoremap <expr><A-h>   pumvisible() ? "\<C-x>\<Left>"  : "\<Left>"
inoremap <expr><A-l>   pumvisible() ? "\<C-x>\<Right>" : "\<Right>"
inoremap <expr><A-,>   pumvisible() ? "\<PageUp>"      : "\<Home>"
inoremap <expr><A-.>   pumvisible() ? "\<PageDown>"    : "\<End>"
inoremap <expr><A-e>   pumvisible() ? "\<C-y>"         : ""
inoremap <expr><A-u>   pumvisible() ? "\<C-x>"         : "\<Esc>0Di"

" |-------+-----------------------------------------------------+---------------------------------|
" |       |                               Pop up visible                                          |
" |-------+-----------------------------------------------------+---------------------------------|
" |  key  |                       on                            |              off                |
" |-------+-----------------------------------------------------+---------------------------------|
" | <A-n> | Select next match in completion menu                | Open completion menu            |
" | <A-p> | Select previous match in completion menu            |                                 |
" | <A-j> | Turn off completion menu and go down one line       | Go down one line                |
" | <A-k> | Turn off completion menu and go up one line         | Go up one line                  |
" | <A-h> | Turn off completion menu and go 1 char to the left  | Go 1 char to the left           |
" | <A-l> | Turn off completion menu and go 1 char to the right | Go 1 char to the right          |
" | <A-,> | Go up 1 page in completion menu                     | Go to the beginning of the line |
" | <A-.> | Go down 1 page in completion menu                   | Go to the end of the line       |
" | <A-e> | Choose match                                        |                                 |
" | <A-u> | Turn off completion menu                            | Delete current line             |
" |-------+-----------------------------------------------------+---------------------------------|
" }}}
" {{{ Change mode
inoremap <A-i> <Esc><Esc>|                         "Switch to normal mode from insert mode
vnoremap <A-i> <Esc>|                              "Switch to normal mode from visual mode
snoremap <A-i> <Esc>|                              "Switch to normal mode from select mode
cnoremap <A-i> <C-c>|                              "Switch to normal mode from command mode
" }}}
" {{{ Visual mode
nnoremap gV `[v`]|                                 "Visual select the last inserted text

vnoremap $ $h
vnoremap <silent><A-k> 6<C-y>6k|                  "Scroll 6 lines above
vnoremap <silent><A-j> 6<C-e>6j|                  "Scroll 6 lines below
vnoremap <silent><A-l> 12<C-e>12j|                "Scroll 12 lines above
vnoremap <silent><A-h> 12<C-y>12k|                "Scroll 12 lines below

vnoremap Kh y:OpenHelpInTab <C-r>"<CR>|           "Open help about the word under cursor
vnoremap Ka
			\ y:grep! "<C-R>""<CR><Bar>
			\ :copen 20<CR>|                          "Find word under cursor in current working directory
vnoremap ; <Esc>:'<,'>|                            "Execute command in visual range

nnoremap <A-v> <C-q>|                              "Visual block
vnoremap <A-v> <C-q>|                              "Visual block (Use to switch to VBlock from Visual)
" }}}
" {{{ Command mode
cnoremap <A-k> <C-r><C-w>|                         "Insert word under cursor
cnoremap <A-a> <C-r><C-a>|                         "Insert WORD under cursor
cnoremap <A-9> <C-w>|                              "Delete previous word
cnoremap <A-0> <C-Right><C-w><BS>|                 "Delete forward word (Work for 1 whitespace only)
cnoremap <A-Space> <BS>|                           "Delete 1 character
cnoremap <A-u> <End><C-u>|                         "Delete current line
cnoremap <A-;> <C-Left>|                           "Backward one word
cnoremap <A-'> <C-Right>|                          "Forward one nail word
cnoremap <A-j> <C-n>|                              "Go to the next command in history
cnoremap <A-k> <C-p>|                              "Go to the previous command in history
cnoremap <A-n> <C-g>|                              "Next search in command mode
cnoremap <A-p> <C-t>|                              "Previous search in command mode
cnoremap <A-h> <Left>|                             "Go to the left one character
cnoremap <A-l> <Right>|                            "Go to the right one character
cnoremap <A-,> <Home>|                             "Move to the beginning of the line
cnoremap <A-.> <End>|                              "Move to the end of the line
cnoremap <silent><A-y> <C-f>yy:q<CR>|              "Copy command content
cnoremap <A-r> <C-r>*|                             "Paste yanked text in command line
" }}}
" {{{ Replace
vnoremap <Leader>rf y:Replace %s/\<<C-r>"\>/|           "Replace selected word in this file
vnoremap <Leader>rb y:Replace bufdo %s/\<<C-r>"\>/|     "Replace selected word across buffers
nnoremap <Leader>rk  :Replace %s/\<<C-r><C-w>\>/|       "Replace current word in this file
nnoremap <Leader>rK  :Replace bufdo %s/\<<C-r><C-w>\>/| "Replace current word across buffers
nnoremap <Leader>rf  :Replace %s/|                      "Replace in this file
nnoremap <Leader>rb  :Replace bufdo %s/|                "Replace across buffers
nnoremap <Leader>rr  :Replace |                         "Replace with custom range
" }}}
" {{{ Misc
nnoremap U :later 1f<CR>|                          "Go to the latest change
imap < <|                                          "Pathetic attempt to fixing < map
cmap < <
nnoremap << <_|                                    " << not working
nnoremap <F8> mzggg?G`z|                           "Encrypted with ROT13, just for fun
nnoremap Q @q|                                     "Execute macro
vnoremap > >gv|                                    "Make indent easier
vnoremap < <gv|                                    "Make indent easier
nnoremap yp :call yank#Path()<CR>|                 "Yank and show current path

if ExistsFile(s:autoload . 'license.vim')
	nnoremap <silent>u     :call license#SkipLicenseDate('undo')<CR>
	nnoremap <silent><A-u> :call license#SkipLicenseDate('redo')<CR>
else
	nnoremap <silent><A-u> <C-r>
endif

nnoremap <A-p> ciw<C-r>*<esc>|                     "Paste over a word
nnoremap <silent><A-F1> :ToggleMenuBar<CR>|        "Toggle menu bar
nnoremap <silent><Leader>N :nohlsearch<CR>|        "diable highlight result
nnoremap <A-Space> a<Space><Left><esc>|            "Insert a whitespace
nnoremap <Enter> o<Esc>|                           "Make new line
nnoremap Y y$|                                     "Make Y yank to endline (same behaviours as D or R)
nnoremap <C-w> :ToggleWrap<CR>|                    "Toggle wrap option
nnoremap <silent>- :w<CR>|                         "Write changes
nnoremap <silent><Leader>- :SudoWrite<CR>|         "Write changes with sudo
nnoremap <silent><Leader>tV :ToggleVerbose<CR>
nnoremap <silent><Leader>o :call ide#Open('code')<CR>| "Open vscode of current file to debug
nnoremap <silent><Leader><CR> :ExecuteFile<CR>|    "Run executable file (python, ruby, bash..)
nnoremap <Leader><Leader><CR> :ExecuteFile<Space>| "Same with argument
nnoremap <silent><Leader>R :redraw!<CR>
nnoremap <silent><Leader>c :call syntax#GetGroup()<CR>
" }}}
" {{{ Abbreviation
cabbrev vbnm verbose<Space>nmap
cabbrev vbim verbose<Space>imap
cabbrev vbvm verbose<Space>vmap
cabbrev vbcm verbose<Space>cmap
" }}}
" {{{ Command difinition
if ExistsFile(s:autoload . 'help.vim')
	command! -nargs=* GetHelp silent! call help#GetHelp(<f-args>)
endif
if ExistsFile(s:autoload . 'toggleOption.vim')
	command! ToggleMenuBar call toggleOption#MenuBar()
	command! ToggleVerbose call toggleOption#Verbose()
	command! ToggleWrap    call toggleOption#Wrap()
endif
command! ToggleHeader                           call utils#ToggleHeader()
command! -nargs=? -complete=help OpenHelpInTab  call utils#OpenHelpInTab(<q-args>)
command! CloseEmptyBuffer                       call <SID>CloseEmptyBuffer()
command! -nargs=+ -complete=command RedirInTab  call utils#RedirInTab(<q-args>)
command! -nargs=+ ExistsInTab                   echo utils#ExistsInTab(<f-args>)
command! OpenTagInVSplit                        call utils#OpenTagInVSplit()
command! TrimWhitespace                         call utils#TrimWhitespace()
command! MakeSymlink                            call utils#MakeSymlink()
command! -range=% Space2Tab      <line1>,<line2>call retab#Space2Tab()
command! -range=% Space2TabAll   <line1>,<line2>call retab#Space2TabAll()
command! -range=% Tab2SpaceAll   <line1>,<line2>call retab#Tab2SpaceAll()
command! SudoWrite                              w !sudo tee > /dev/null %
command! -nargs=* -bar ExecuteFile              call execute#File(<q-args>)
command! -nargs=1 -bar Replace                  call substitute#Exe(<q-args>)
" }}}

" }}}
"{{{ Vim-plug
call plug#begin(s:plugged)

" Essential
Plug 'bling/vim-bufferline'
Plug '/usr/share/vim/vimfiles'
Plug 'junegunn/fzf.vim'
Plug 'haya14busa/incsearch.vim', {'on': [
			\ '<Plug>(incsearch-forward)',
			\ '<Plug>(incsearch-backward)',
			\ '<Plug>(incsearch-stay)',
			\ '<Plug>(incsearch-nohl-n)',
			\ '<Plug>(incsearch-nohl-N)',
			\ '<Plug>(incsearch-nohl-*)',
			\ '<Plug>(incsearch-nohl-#)',
			\ '<Plug>(incsearch-nohl-g*)',
			\ '<Plug>(incsearch-nohl-g#)'
			\ ]}
" Plug 'haya14busa/is.vim', {'on': [
" 			\ '<Plug>(is-n)',
" 			\ '<Plug>(is-N)',
" 			\ '<Plug>(is-*)',
" 			\ '<Plug>(is-#)',
" 			\ '<Plug>(is-scroll-f)',
" 			\ '<Plug>(is-scroll-b)'
" 			\ ]}
Plug 'vim-utils/vim-man', {'on': []}
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-fugitive'
Plug 'skywind3000/asyncrun.vim'
Plug 'w0rp/ale'
Plug 'mhinz/vim-startify'

Plug 'xolox/vim-misc', {'on': []}
Plug 'xolox/vim-shell', {'on': []}
Plug 'xolox/vim-session', {'on': []}

" Other
Plug 'justinmk/vim-sneak', {'on': [
			\ '<Plug>Sneak_f',
			\ '<Plug>Sneak_F',
			\ '<Plug>Sneak_t',
			\ '<Plug>Sneak_T'
			\ ]}

Plug 'suan/vim-instant-markdown'
Plug 'terryma/vim-smooth-scroll'

" Filetype
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'maksimr/vim-jsbeautify'
Plug 'hdima/python-syntax'
Plug 'hail2u/vim-css3-syntax'
Plug 'tmhedberg/SimpylFold'

Plug 'altercation/vim-colors-solarized'
Plug 'ap/vim-css-color'

Plug 'junegunn/vim-easy-align', {'on': '<Plug>(EasyAlign)'}

Plug 'tpope/vim-commentary', {'on': [
		 \ '<Plug>Commentary',
		 \ '<Plug>CommentaryLine'
		 \ ]}
Plug 'honza/vim-snippets'
Plug 'sirver/ultisnips', {'on': [
			\ 'UltiSnipsEdit',
			\ 'UltiSnipsEdit!'
			\ ]}
Plug 'mattn/emmet-vim', {'on': ['EmmetInstall']}
Plug 'jiangmiao/auto-pairs' ", {'on': []}
Plug 'tpope/vim-surround', {'on': [
			\ '<Plug>Ysurround',
			\ '<Plug>Dsurround',
			\ '<Plug>Csurround',
			\ '<Plug>CSurround',
			\ '<Plug>Ysurround',
			\ '<Plug>YSurround',
			\ '<Plug>Yssurround',
			\ '<Plug>YSsurround',
			\ '<Plug>YSsurround',
			\ '<Plug>VSurround',
			\ '<Plug>VgSurround'
			\ ]}
Plug 'Ron89/thesaurus_query.vim', {'on': [
			\ 'ThesaurusQueryReplaceCurrentWord',
			\ 'Thesaurus',
			\ 'ThesaurusQueryReplace'
			\ ]}

Plug 'Valloric/YouCompleteMe'
" Plug 'shougo/neocomplete.vim', {'on': []}
" Plug 'Shougo/neoinclude.vim',  {'on': []}
" Plug 'Shougo/neco-syntax',     {'on': []}
" Plug 'Shougo/neco-vim',        {'on': []}

Plug 'gioele/vim-autoswap'
Plug 'Konfekt/FastFold'

Plug 'NearHuscarl/gundo.vim', {'on': 'GundoToggle'}

Plug 'drmikehenry/vim-fontsize', {'on': [
			\ '<Plug>FontsizeInc',
			\ '<Plug>FontsizeDec'
			\ ]}
" Plug 'powerline/fonts'
call plug#end()

let g:plug_window = 'vertical botright new'

nnoremap <Leader>pc :PlugClean<CR>|                    "Clean directory
nnoremap <Leader>pC :PlugClean!<CR>|                   "Clean directory
nnoremap <Leader>ps :PlugStatus<CR>|                   "Check plugin status
nnoremap <Leader>pd :PlugDiff<CR>|                     "Show changes between update
nnoremap <Leader>pi :PlugInstall<Space><C-d>|          "Install new plugin
nnoremap <Leader>pv :PlugUpgrade<CR>|                  "Update vim-plug
nnoremap <Leader>pu :PlugUpdate<Space><C-d>|           "Update other plugins
nnoremap <Leader>pU :PlugUpdate<CR>|                   "Update all plugins
"}}}
" {{{ Ale
let g:ale_fixers            = {}
let g:ale_fixers.javascript = ['eslint']
let g:ale_fixers.python     = ['pylint']
let g:ale_fixers.scss       = ['scsslint']
let g:ale_fixers.vim        = ['vint']
let g:ale_sign_error           = ''
let g:ale_sign_warning         = ''
let g:ale_lint_on_text_changed = 0

nmap [a <Plug>(ale_previous_wrap)zz
nmap ]a <Plug>(ale_next_wrap)zz
" }}}
"{{{ Auto Pairs
autocmd CursorHold,CursorHoldI * :silent! all autopairs#AutoPairsTryInit()
let g:AutoPairsMoveCharacter      = ''
let g:AutoPairsShortcutJump       = ''
let g:AutoPairsShortcutToggle     = ''
let g:AutoPairsShortcutFastWrap   = ''
let g:AutoPairsShortcutBackInsert = ''
"}}}
" {{{ AsyncRun
" Async with Fugitive
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
" }}}
"{{{ Bufferline
let g:bufferline_rotate              = 2
let g:bufferline_solo_highlight      = 1
"}}}
"{{{ Commentary
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine
nmap gCC gggcG
"}}}
"{{{ FastFold
let g:fastfold_fold_command_suffixes  = []
let g:fastfold_fold_movement_commands = []
let g:fastfold_skip_filetypes         = ['vim', 'py']
"}}}
"{{{ Fugitive
nnoremap <Leader>gs  :Gstatus<CR>|                              "Git status in vim!
nnoremap <Leader>ga  :Git add %:p<CR>|                          "Git add in vim!
nnoremap <Leader>gbl :Gblame<CR>|                               "Git blame in vim!
nnoremap <Leader>gw  :Gwrite<CR>|                               "Git write in vim!
nnoremap <Leader>gr  :Gread<CR>|                                "Git read in vim!
nnoremap <Leader>gd  :Gdiff<CR>|                                "Git diff in vim!
nnoremap <Leader>gP  :Gpull<CR>|                                "Git pull in vim!
nnoremap <Leader>gp  :Gpush<CR>|                                "Git push in vim!
nnoremap <Leader>gm  :Gmove<CR>|                                "Git move in vim!
nnoremap <Leader>gc  :Gcommit<CR>|                              "Git commmit in vim!
nnoremap <Leader>gbr :Gbrowse<CR>|                              "Open current file on github
nnoremap <Leader>gk  :Ggrep! <C-r><C-w><CR><CR>|                "Find word under (k)ursor in repo
nnoremap <Leader>gl  :Glog!<CR><Bar>:bot copen<CR>|             "Load all version before
nnoremap <Leader>ggc :Glog! --grep= -- %<C-Left><C-Left><Left>| "Search for commit message
nnoremap <Leader>ggd :Glog! -S -- %<C-Left><C-Left><Left>|      "Search content in diffs history
"}}}
"{{{ Fzf
let g:fzf_option='
			\ --bind=alt-k:up,alt-j:down
			\ --bind=alt-h:backward-char,alt-l:forward-char
			\ --bind=alt-n:backward-word,alt-m:forward-word
			\ --bind=alt-i:abort,alt-d:kill-line,alt-e:jump,alt-t:toggle
			\ --color=hl:$THEME_HL2,hl+:$THEME_HL,bg+:$THEME_BG_ALT
			\ --color=info:$THEME_MAIN,pointer:$THEME_MAIN,marker:$THEME_MAIN2
			\ --color=spinner:$THEME_MAIN,border:$THEME_MAIN
			\ --prompt=\>\ 
			\ --multi'
let g:grep_cmd = 'rg
			\ --column --line-number --no-heading
			\ --hidden --ignore-case --follow --color "always" '

command! -nargs=+ Grep
			\ call fzf#vim#grep(g:grep_cmd . shellescape(<q-args>), 0, {'options': g:fzf_option}, 0)
command! -nargs=? -complete=dir Files
			\ call fzf#vim#files(<q-args>, {
			\   'options': g:fzf_option,
			\   'source': 'rg --files --hidden --follow --no-messages'
			\ }, 0)

command! GitFiles execute 'Files ' . git#GetRootDir()
command! Colors   call fzf#vim#colors({'options': g:fzf_option}, 0)
command! MRU      call fzf#vim#history({'options': g:fzf_option}, 0)
command! Helptags call fzf#vim#helptags({'options': g:fzf_option}, 0)
command! Tags     call fzf#vim#tags(<q-args>, {'options': g:fzf_option}, 0)
command! Maps     call fzf#vim#maps(<q-args>, {'options': g:fzf_option}, 0)
command! Lines    call fzf#vim#lines({'options': g:fzf_option}, 0)
command! Buffers  call fzf#vim#buffers({'options': g:fzf_option}, 0)

nnoremap gr :Grep<Space>
nnoremap <Leader>ep :GitFiles<CR>|    "Fzf files in the whole git repo
nnoremap <Leader>ef :Files<CR>|       "Fzf files from cwd
nnoremap <Leader>eh :Files $HOME<CR>
nnoremap <Leader>em :MRU<CR>
nnoremap <Leader>h  :Helptags<CR>
nnoremap <Leader>j  :Tags<CR>
nnoremap <Leader>m  :Maps<CR>
nnoremap <Leader>l  :Lines<CR>
nnoremap <Leader>b  :Buffers<CR>
"}}}
"{{{ Incsearch
let g:incsearch#auto_nohlsearch = 1
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

map n  <Plug>(incsearch-nohl-n)zzzo
map N  <Plug>(incsearch-nohl-N)zzzo
map *  <Plug>(incsearch-nohl-*)zzzo
map #  <Plug>(incsearch-nohl-#)zzzo
map g* <Plug>(incsearch-nohl-g*)zzzo
map g# <Plug>(incsearch-nohl-g#)zzzo
"}}}
"{{{ is.vim
" nmap n <Plug>(is-n)zozz
" nmap N <Plug>(is-N)zozz
" nmap * <Plug>(is-*)zozz
" nmap # <Plug>(is-#)zozz
"}}}
"{{{ Gundo
if has('python3') && !has('python')
	let g:gundo_prefer_python3 = 1
endif

nnoremap <Leader>u :GundoToggle<CR>
let gundo_map_move_older = ''
let gundo_map_move_newer = ''
let g:gundo_preview_height   = 11
let g:gundo_preview_bottom   = 1
let g:gundo_right            = 0
let g:gundo_help             = 0
let g:gundo_return_on_revert = 0
let g:gundo_auto_preview     = 1
"}}}
"{{{ Easy Align
vnoremap ga <Esc>:'<,'>EasyAlign // dl<Left><Left><Left><Left>| " Align with delimiter aligned left
nmap ga <Plug>(EasyAlign)
let g:easy_align_ignore_groups = []       " Vim Align ignore comment by default
"}}}
"{{{ Emmet
let g:user_emmet_install_global = 0

autocmd CursorHold,CursorHoldI *.html EmmetInstall
let g:user_emmet_mode='i'
let g:user_emmet_leader_key    = '<A-o>'
let g:user_emmet_next_key      = '<A-o>n'
let g:user_emmet_prev_key      = '<A-o>p'
let g:user_emmet_removetag_key = '<A-o>r'
"}}}
"{{{ Fontsize
let g:fontsize#defaultSize = 8
nmap <silent><A-Up>   <Plug>FontsizeInc
nmap <silent><A-Down> <Plug>FontsizeDec
"}}}
" {{{ Python Syntax
let python_highlight_all = 1
" }}}
"{{{ Session
let g:session_directory    = s:session
let g:session_autoload     = 'no'
let g:session_autosave     = 'yes'
let g:session_autosave_to  = 'AutoSave'
let g:session_default_name = 'Default'

"OpenSession -> SessionOpen 
"ViewSession -> SessionView 
let g:session_command_aliases = 1
let g:session_map_list = [
			\ '<Leader>so',
			\ '<Leader>sO',
			\ '<Leader>ss',
			\ '<Leader>sS',
			\ '<Leader>sv',
			\ '<Leader>sV',
			\ '<Leader>sc',
			\ '<Leader>sd',
			\ ]

nnoremap <silent><Leader>so :call session#LazyOpen(session_map_list)<CR>
nnoremap <silent><Leader>sO :call session#LazyOPEN(session_map_list)<CR>
nnoremap <silent><Leader>ss :call session#LazySave(session_map_list)<CR>
nnoremap <silent><Leader>sS :call session#LazySAVE(session_map_list)<CR>
nnoremap <silent><Leader>sv :call session#LazyView(session_map_list)<CR>
nnoremap <silent><Leader>sV :call session#LazyVIEW(session_map_list)<CR>
nnoremap <silent><Leader>sc :call session#LazyClose(session_map_list)<CR>
nnoremap <silent><Leader>sd :call session#LazyDelete(session_map_list)<CR>
"}}}
"{{{ SimpylFold
let g:SimpylFold_fold_docstring = 0
let b:SimpylFold_fold_docstring = 0
"}}}
"{{{ Smooth Scroll
nnoremap <silent> <A-j> :call smooth_scroll#down(6, 0, 2)<CR>
nnoremap <silent> <A-k> :call smooth_scroll#up(6, 0, 2)<CR>
nnoremap <silent> <A-l> :call smooth_scroll#down(15, 0, 3)<CR>
nnoremap <silent> <A-h> :call smooth_scroll#up(15, 0, 3)<CR>
" nnoremap <silent> H     :call smooth_scroll#up(40, 0, 10)<CR>
" nnoremap <silent> L     :call smooth_scroll#down(40, 0, 10)<CR>
if g:os ==# 'win'
	let s:smoothScrollPath = '~\vimfiles\plugged\vim-smooth-scroll\autoload\smooth_scroll.vim'
else
	let s:smoothScrollPath = '~/.vim/plugged/vim-smooth-scroll/autoload/smooth_scroll.vim'
endif
if !ExistsFile(s:smoothScrollPath)
	nnoremap <silent><A-l> 10<C-e>10j
	nnoremap <silent><A-h> 10<C-y>10k
endif
"}}}
"{{{ Sneak
let g:sneak#use_ic_scs = 1          " Case determined by 'ignorecase' and 'smartcase'
let g:sneak#absolute_dir = 1        " Movement in sneak not based on sneak search direction

if ExistsFile(s:plugged . 'vim-sneak')
	nmap <silent> l <Plug>Sneak_;
	nmap <silent> h <Plug>Sneak_,
	vmap <silent> l <Plug>Sneak_;
	vmap <silent> h <Plug>Sneak_,
else
	nnoremap l ;| "Repeat latest f, F, t or T command (forward)
	nnoremap h ,| "Repeat latest f, F, t or T command (backward)
endif

nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
vmap f <Plug>Sneak_f
vmap F <Plug>Sneak_F

nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
vmap t <Plug>Sneak_t
vmap T <Plug>Sneak_T

" 3 characters search instead
let g:sneak_map_list = ['s', 'S']
nnoremap <silent>s :call sneak#LazyloadForwardNormal(sneak_map_list)<CR>
nnoremap <silent>S :call sneak#LazyloadBackwardNormal(sneak_map_list)<CR>
"}}}
"{{{ Startify
function! s:center_header(lines) abort
	let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
	let centered_lines = map(copy(a:lines),
				\ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
	return centered_lines
endfunction
let g:startify_custom_header = s:center_header(startify#fortune#cowsay())
let g:startify_custom_indices = [
			\ 'a','b','c','d','f','h','l','m','n','o',
			\ 'p','r','s','t','u','v','w','x','y','z']
let g:startify_list_order = [
			\ ['Session:'],   'sessions',
			\ ['MRU:'],       'files',
			\ ['MRU (cwd):'], 'dir',
			\ ['bookmarks:'], 'bookmarks',
			\ ['commands:'],  'commands',
			\ ]
"}}}
"{{{ Surround
nmap ds  <Plug>Dsurround
nmap cs  <Plug>Csurround
nmap cS  <Plug>CSurround
nmap ys  <Plug>Ysurround
nmap yS  <Plug>YSurround
nmap yss <Plug>Yssurround
nmap ySs <Plug>YSsurround
xmap s   <Plug>VSurround
xmap gs  <Plug>VgSurround
"}}}
"{{{ Thesaurus Query
"Require internet
if has('python3')
	let g:tq_python_version          = 3
	let g:tq_online_backends_timeout = 0.6

	nnoremap <Leader>to :Thesaurus<Space>
	nnoremap Kt :ThesaurusQueryReplaceCurrentWord<CR>
	vnoremap Kt y:ThesaurusQueryReplace <C-r>"<CR>
endif
"}}}
"{{{ Vim-man
" ../vim-man/plugin/man.vim
command! -nargs=* -bar -complete=customlist,man#completion#run Man
			\ call plug#load('vim-man')
			\|call man#get_page('horizontal', <f-args>)
"}}}
"{{{ Neocomplete
let g:neocomplete#enable_at_startup                 = 1 " Use neocomplete.
let g:neocomplete#enable_smart_case                 = 1 " Use smartcase.
let g:NeoCompleteAutoCompletionLength               = 3 " Set minimum char to trigger Autocomplete
let g:neocomplete#sources#syntax#min_keyword_length = 3 " Set minimum syntax keyword length.
let g:neocomplete#enable_auto_delimiter             = 1
let g:neocomplete#auto_complete_delay               = 100
let g:neocomplete#sources#omni#functions            = ['cpp']
"}}}
" {{{ Youcompleteme
let g:ycm_semantic_triggers = {
	 \   'css':  [ 're!^\s{3,}', 're!^\t{1,}', 're!:\s'],
	 \   'scss': [ 're!^\s{3,}', 're!^\t{1,}', 're!:\s'],
	 \ }
let g:ycm_key_list_select_completion = []
" }}}
"{{{ Ultisnips
nnoremap <Leader>U :UltiSnipsEdit<CR>|                            " Open new file to define snippets
nnoremap <Leader><Leader>U :UltiSnipsEdit!<CR>|                   " Open all available files to select
inoremap <silent><Tab> <C-r>=ultisnips#Lazyload()<CR>

let g:UltiSnipsSnippetsDir = s:snippet                             " Custom snippets stored here
let g:UltiSnipsSnippetDirectories  = ['UltiSnips', 'snippet']        " Directories list for ultisnips to search
let g:UltiSnipsEditSplit           = 'normal'
" let g:UltiSnipsExpandTrigger       = "<Tab>"
let g:UltiSnipsListSnippets        = '<C-e>'
let g:UltiSnipsJumpForwardTrigger  = '<A-j>'
let g:UltiSnipsJumpBackwardTrigger = '<A-k>'
"}}}
"{{{ Autocmd
augroup Statusline
	autocmd!
	autocmd VimEnter * call statusline#SetStatusline()
	autocmd BufEnter * silent! call statusline#UpdateStatuslineInfo()
	autocmd CursorHold * let g:statuslineFileSize = statusline#SetFileSize()
augroup END

augroup SaveView
	autocmd!
	" Save view when switch buffer
	autocmd BufEnter * if exists('b:winView') | call winrestview(b:winView) | endif
	autocmd BufLeave * let b:winView = winsaveview()
	" Save cursor position when open new file
	autocmd BufReadPost *
				\ if line("'\"") >= 1 && line("'\"") <= line("$")
				\|  execute "normal! g`\""
				\|endif
augroup END

augroup SwitchBuffer
	autocmd!
	autocmd BufEnter * set cursorline | silent! lcd %:p:h
	autocmd BufEnter * set number relativenumber
	autocmd BufLeave * set nocursorline
	autocmd BufLeave * set norelativenumber
augroup END

autocmd BufEnter * if (&diff || &ft == 'gundo') | set timeout timeoutlen=0 | endif
autocmd BufLeave * if (&diff || &ft == 'gundo') | set timeout& timeoutlen& | endif

autocmd BufEnter *.html let g:AutoPairs["<"] = '>'
autocmd BufLeave *.html unlet g:AutoPairs["<"]

autocmd QuickFixCmdPost * cwindow
autocmd CursorHold * nohlsearch

autocmd FocusLost * if &modified && filereadable(expand("%:p")) | write | endif
autocmd BufWritePre * call license#SetLastChangeBeforeBufWrite()

autocmd BufWritePost *.py,*.js,*vimrc call ctags#Update()

" Auto resize panes when window is resized
autocmd VimResized * wincmd =

if has('gui_running')
	if g:os ==# 'Linux'
		autocmd VimEnter *
					\ if executable('wmctrl')
					\|   call system('wmctrl -i -b add,maximized_vert,maximized_horz -r '.v:windowid)
					\|endif
	elseif g:os ==# 'win'
		autocmd GUIEnter * simalt ~x            "Open vim in maximum winow size
	endif
endif
"}}}
"{{{ Highlight Group
call statusline#SetHighlight()
if !exists(g:colors_name)
	highlight link ALEErrorSign PreProc
	highlight link ALEWarningSign Statement
	highlight link ALEInfoSign Type

	highlight link Sneak Search

	highlight link StartifyHeader  Question
	highlight link StartifyBracket Normal
	highlight link StartifyNumber  Statement
	highlight link StartifyPath    Comment
	highlight link StartifyFile    String
	highlight link StartifySlash   Comment
endif
"}}}

" flink eh --hide-pointer --geometry 1000x600 --zoom fill
" feh --hide-pointer --thumbnails --thumb-height 60 --thumb-width 100 --index-info "" --geometry 1000x600 --image-bg black
