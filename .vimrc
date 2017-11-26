" ============================================================================
" File:        .vimrc
" Description: Vim settings
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Mon Nov 27 02:09:02 +07 2017
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

if g:os == 'win'
	let $MYVIMRC   = $HOME.'\_vimrc'
	let s:autoload = $HOME.'\vimfiles\autoload\'
	let s:plugged  = $HOME.'\vimfiles\plugged\'
	let s:session  = $HOME.'\vimfiles\session\'
	let s:snippet  = $HOME.'\vimfiles\snippet\'
	let s:swapfile = $HOME.'\vimfiles\swapfiles//'
	let s:undo     = $HOME.'\vimfiles\undo\'
else
	let $MYVIMRC   = $HOME.'/.vimrc'
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
	 if (line('$') == 1 && getline(1) == '') && (filereadable(@%) == 0)
		  return 1
	 endif
	 return 0
endfunction
" }}}
function! s:CloseEmptyBuffer() " {{{
	let t:NumOfWin = winnr('$')
	while t:NumOfWin >= 1
		execute "wincmd p"
		if s:BufferIsEmpty()
			while s:BufferIsEmpty() && t:NumOfWin >= 1
				execute "bdelete"
				let t:NumOfWin -= 1
			endwhile
		endif
		let t:NumOfWin -= 1
	endwhile
endfunction
" }}}
function! s:Eatchar(pat) " {{{
	let c = nr2char(getchar(0))
	return (c =~ a:pat) ? '' : c
endfunction
" }}}
"}}}
"{{{ Basic Setup

autocmd!

if g:os ==? 'linux' && !has('gui_running')
	" Fix alt key not working in gnome-terminal
	" if \e not work, replace with  (<C-v><C-[>)
	let charList = [
				\ 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',
				\ 'p','q','r','s','t','u','v','w','x','y','z','1','2','3','4',
				\ '5','6','7','8','9','0', ',', '.', '/', ';',"'",'\','-','=']
	for char in charList
		execute "set <A-" .char. ">=\e" .char
		execute "imap \e" .char. " <A-" .char. ">"
	endfor
	" execute "set <A-]>=\e]"
	" execute "inoremap \e] <A-]>"

	execute "set <A-[>=<C-[>"
	execute "inoremap \e[ <c-[>"
endif

set fileformat=unix
set t_Co=256                                       "More color
set encoding=utf-8                                 "Enable the use of icon or special char
scriptencoding utf-8                               "Need this for nerdtree to work properly
syntax on                                          "Color my code

filetype on
filetype plugin on
filetype indent on

try
	colorscheme flat
catch /E185/
	colorscheme evening
endtry

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
set wildmode=list:longest,full
set wildchar=<A-e>
set completeopt=menu,longest
set complete-=i                                    "An attempt to make YCM faster

if has('GUI_running')
	" :put =&guifont
	if g:os == 'win'
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
set showmatch                                      "Highlight matching parenthesis when make the other one
set showcmd                                        "Show command as you type

set textwidth=0                                    "No insert newline when max width reached
set wrapmargin=0                                   "Number of chars outside the width limit before wrapping (disable)
set formatoptions-=t                               "Keep textwidth setting in existing files
set formatoptions+=j                               "Remove a comment leader when joining lines 
set wrap                                           "Turn off auto wrap
set showbreak=>>\                                  "Characters at the start of wrapped lines
if has('linebreak')
	set linebreak                                   "Wrap long lines at last words instead of the last characters
	set breakindent                                 "Keep the indent level after wrapping
endif

set synmaxcol=228                                  "Maximum column for syntax highlighting
set lazyredraw                                     "An attempt to make scrolling smoother

set list                                           "Enable listchars option
set listchars=tab:\|\ ,extends:»,precedes:«,trail:¥,nbsp:_
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
nnoremap <A-'> :bnext<CR>|                         "Go to the next buffer
nnoremap <A-;> :bprevious<CR>|                     "Go to the previous buffer
nnoremap <A-e> :enew<CR>|                          "Edit new buffer
nnoremap <A-b> :buffer#<CR>|                       "Switch between last buffers
nnoremap <Leader>q :bprevious <Bar>:bdelete #<CR>| "Delete current buffer
nnoremap <Leader>x :e#<CR>|                        "Open last closed buffer (not really)
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
nnoremap <Leader><Tab> :tabnew<CR>|                "Make a new tab
nnoremap <A-,> :tabprevious<CR>|                   "Go to next tab
nnoremap <A-.> :tabnext<CR>|                       "Go to previous tab
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
nnoremap ]t :tnext<CR>|                            "Go to next tag in the tag list
nnoremap [t :tprevious<CR>|                        "Go to next tag in the tag list
nnoremap ]c ]czz|                                  "Jump forward change and zz
nnoremap [c [czz|                                  "Jump backward change and zz
nnoremap ]q :cnext<CR>|                            "Jump to the next quickfix item
nnoremap [q :cprev<CR>|                            "Jump to the previous quickfix item
nnoremap ]Q :clast<CR>|                            "Jump to the previous quickfix item
nnoremap [Q :cfirst<CR>|                           "Jump to the previous quickfix item
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
inoremap <A-i> <Esc><Right>|                       "Switch to normal mode from insert mode
vnoremap <A-i> <Esc>|                              "Switch to normal mode from visual mode
snoremap <A-i> <Esc>|                              "Switch to normal mode from select mode
cnoremap <A-i> <C-c>|                              "Switch to normal mode from command mode
" }}}
" {{{ Visual mode
nnoremap gV `[v`]|                                 "Visual select the last inserted text

vnoremap $ $h
vnoremap <silent> <A-k> 2<C-y>2k2<C-y>2k2<C-y>2k|  "Scroll 2 line above
vnoremap <silent> <A-j> 2<C-e>2j2<C-e>2j2<C-e>2j|  "Scroll 2 line below
vnoremap <silent> <A-l> 5<C-e>5j5<C-e>5j5<C-e>5j|  "Scroll 5 line above
vnoremap <silent> <A-h> 5<C-y>5k5<C-y>5k5<C-y>5k|  "Scroll 5 line below

vnoremap Kh y:OpenHelpInTab <C-r>"<CR>|           "Open help about the word under cursor
vnoremap Ka
			\ y:grep! "<C-R>""<CR><Bar>
			\ :copen 20<CR>|                          "Find word under cursor in current working directory
vnoremap <Leader>a y:Ag <C-r>"<Space>|             "Ag search (just like grep but faster)
vnoremap <Leader>c y:CtrlP <C-r>"<CR>|             "CtrlP search
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
vnoremap <Leader>rf y:%s/<C-r>"/|                  "Replace in whole file with query is the selected word
vnoremap <Leader>rb y:bufdo %s/<C-r>"/|            "Replace across opening buffers with query is the selected word
vnoremap <Leader>rr 
			\y:.,.+s/<C-r>"/<Home>
			\<Right><Right><Right><Right>|            "Replace from current line to ... with query is the selected word
nnoremap <Leader>rf :%s/|                          "Replace in whole file
nnoremap <Leader>rb :bufdo %s/|                    "Replace across opening buffers
nnoremap <Leader>rr :.,.+s//<Left><Left><Left>|    "Replace from current line to ...
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
	nnoremap <silent> u     :call license#SkipLicenseDate('undo')<CR>
	nnoremap <silent> <A-u> :call license#SkipLicenseDate('redo')<CR>
else
	nnoremap <silent> <A-u> <C-r>
endif

nnoremap <A-p> ciw<C-r>*<esc>|                     "Paste over a word
nnoremap <A-F1> :ToggleMenuBar<CR>|                "Toggle menu bar
nnoremap <Leader>N :nohlsearch<CR>|                "diable highlight result
nnoremap <A-Space> a<Space><Left><esc>|            "Insert a whitespace
nnoremap <Enter> o<Esc>|                           "Make new line
nnoremap Y y$|                                     "Make Y yank to endline (same behaviours as D or R)
nnoremap <C-w> :ToggleWrap<CR>|                    "Toggle wrap option
nnoremap <C-o> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
nnoremap <silent>- :w<CR>|                         "Write changes
nnoremap <silent><Leader>- :SudoWrite<CR>|         "Write changes with sudo
nnoremap <silent><Leader>tV :ToggleVerbose<CR>
nnoremap <Leader>o    :call ide#Open('code')<CR>|  "Open vscode of current file to debug
nnoremap <Leader><CR> :ExecuteFile<CR>|            "Run executable file (python, ruby, bash..)
nnoremap <Leader><Leader><CR> :ExecuteFile<Space>| "Same with argument
" }}}
" {{{ Abbreviation
cabbrev vbnm verbose<Space>nmap
cabbrev vbim verbose<Space>imap
cabbrev vbvm verbose<Space>vmap
cabbrev vbcm verbose<Space>cmap

cabbrev cund  C:\Users\Near\Desktop<C-r>=s:Eatchar('\m\s\<Bar>/')<CR>
cabbrev dprf  D:\Program Files<C-r>=s:Eatchar('\m\s\<Bar>/')<CR>
cabbrev dprf8 D:\Program Files (x86)<C-r>=s:Eatchar('\m\s\<Bar>/')<CR>
cabbrev dprfp D:\Program Files\Github\plugged<C-r>=s:Eatchar('\m\s\<Bar>/')<CR>
cabbrev eprf  E:\Program Files<C-r>=s:Eatchar('\m\s\<Bar>/')<CR>
cabbrev eprf8 E:\Program Files (x86)<C-r>=s:Eatchar('\m\s\<Bar>/')<CR>
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
command! ToggleHeader                           call near#utils#ToggleHeader()
command! -nargs=? -complete=help OpenHelpInTab  call near#utils#OpenHelpInTab(<q-args>)
command! CloseEmptyBuffer                       call <SID>CloseEmptyBuffer()
command! -nargs=+ -complete=command RedirInTab  call near#utils#RedirInTab(<q-args>)
command! -nargs=+ ExistsInTab                   echo near#utils#ExistsInTab(<f-args>)
command! OpenTagInVSplit                        call near#utils#OpenTagInVSplit()
command! TrimWhitespace                         call near#utils#TrimWhitespace()
command! MakeSymlink                            call near#utils#MakeSymlink()
command! -range=% Space2Tab      <line1>,<line2>call retab#Space2Tab()
command! -range=% Space2TabAll   <line1>,<line2>call retab#Space2TabAll()
command! -range=% Tab2SpaceAll   <line1>,<line2>call retab#Tab2SpaceAll()
command! SudoWrite                              w !sudo tee > /dev/null %
command! -nargs=* -bar ExecuteFile              call execute#File(<q-args>)
" }}}

" }}}
"{{{ Vim-plug
call plug#begin(s:plugged)

" Essential
Plug 'bling/vim-bufferline'
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
Plug 'tpope/vim-fugitive'
Plug 'skywind3000/asyncrun.vim'
Plug 'w0rp/ale'

Plug 'xolox/vim-misc', {'on': []}
Plug 'xolox/vim-shell', {'on': []}
Plug 'xolox/vim-session', {'on': []}
" Plug 'xolox/vim-easytags'

" Other
Plug 'justinmk/vim-sneak', {'on': [
			\ '<Plug>Sneak_s',
			\ '<Plug>Sneak_S',
			\ '<Plug>Sneak_f',
			\ '<Plug>Sneak_F',
			\ '<Plug>Sneak_t',
			\ '<Plug>Sneak_T'
			\ ]}

Plug 'airblade/vim-rooter'
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
Plug 'dhruvasagar/vim-table-mode', {'on': 'TableModeToggle'}
Plug 'ap/vim-css-color'
Plug 'whatyouhide/vim-gotham'
Plug 'lifepillar/vim-solarized8'

Plug 'junegunn/limelight.vim',  {'on': 'Limelight!!'}
Plug 'junegunn/goyo.vim',       {'on': 'Goyo'}
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

let g:plug_window = "vertical botright new"

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
let g:ale_sign_error           = '!!'
let g:ale_sign_warning         = '>>'
let g:ale_lint_on_text_changed = 0

nmap [a <Plug>(ale_previous_wrap)zz
nmap ]a <Plug>(ale_next_wrap)zz

hi! link ALEErrorSign PreProc
hi! link ALEWarningSign Statement
hi! link ALEInfoSign Type
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
nnoremap <Leader>gst :Gstatus<CR>|                 "Git status in vim!
nnoremap <Leader>ga  :Git add %:p<CR>|             "Git add in vim!
nnoremap <Leader>gbl :Gblame<CR>|                  "Git blame in vim!
nnoremap <Leader>gw  :Gwrite<CR>|                  "Git write in vim!
nnoremap <Leader>gr  :Gread<CR>|                   "Git read in vim!
nnoremap <Leader>gd  :Gdiff<CR>|                   "Git diff in vim!
nnoremap <Leader>gD  :Gdiff<Space><C-d>|           "Git diff in vim!
nnoremap <Leader>gpl :Gpull<CR>|                   "Git pull in vim!
nnoremap <Leader>gPL :Gpull<Space><C-d>|           "Git pull in vim!
nnoremap <Leader>gps :Gpush<CR>|                   "Git push in vim!
nnoremap <Leader>gPS :Gpush<Space><C-d>|           "Git push in vim!
nnoremap <Leader>gm  :Gmove<CR>|                   "Git move in vim!
nnoremap <Leader>gM  :Gmove<Space><C-d>|           "Git move in vim!
nnoremap <Leader>gc  :Gcommit<CR>|                 "Git commmit in vim!
nnoremap <Leader>gC  :Gcommit<Space><C-d>|         "Git commmit in vim!
nnoremap <Leader>gbr :Gbrowse<CR>|                 "Open current file on github
nnoremap <Leader>gBR :Gbrowse<Space><C-d>|         "Open current file on github
nnoremap <Leader>gg  :Ggrep! <C-r><C-w><CR><CR>|   "Find word under cursor in repo
nnoremap <Leader>gl
			\ :Glog!<CR><Bar>
			\ :bot copen<CR>|                         "Load all version before
nnoremap <Leader>gL  :Glog!<Space><C-d>|           "Load all version before
nnoremap <Leader>gsc :Glog! --grep= -- %<C-Left><C-Left><Left>| "Search for commit message
nnoremap <Leader>gsd :Glog! -S -- %<C-Left><C-Left><Left>|      "Search content in diffs history
nnoremap <silent><Leader>gh 
			\ :!"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "https://github.com/NearHuscarl/.vimrc/commits/master/_vimrc"<CR><CR>
"}}}
"{{{ fzf
" Recommend: use with vim-rooter
let g:rg_command = '
  \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
  \ -g "*.{js,json,php,md,html,config,py,conf,vim}"
  \ -g "{.vimrc,config}"
  \ -g "!{.git,node_modules,vendor,.local,undo}/*" '

" let g:fzf_colors =
" \ { 'fg':      ['fg', 'Normal'],
"   \ 'bg':      ['bg', 'Normal'],
"   \ 'hl':      ['fg', 'Conditional'],
"   \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"   \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
"   \ 'hl+':     ['fg', 'PreProc'],
"   \ 'info':    ['fg', 'String'],
"   \ 'prompt':  ['fg', 'Conditional'],
"   \ 'pointer': ['fg', 'String'],
"   \ 'marker':  ['fg', 'PreProc'],
"   \ 'spinner': ['fg', 'String'],
"   \ 'header':  ['fg', 'Comment'] }

let g:fzfOpt='--bind=
			\alt-k:up,
			\alt-j:down,
			\alt-i:abort,
			\alt-h:backward-char,
			\alt-l:forward-char,
			\alt-n:backward-word,
			\alt-m:forward-word,
			\alt-e:jump,
			\alt-t:toggle,
			\alt-d:kill-line
			\ --color=info:6,bg+:8,hl+:1,hl:3,pointer:6,marker:1,spinner:6
			\ --multi'

let g:fzf_action = {
  \ 'alt-enter': 'tab split',
  \ 'alt-h': 'split',
  \ 'alt-v': 'vsplit' }

" Show all except binary
command! -bang FilesAll
			\ call fzf#run({
			\  'source': 'rg $HOME /etc/systemd --files --no-ignore --hidden --follow --no-messages --glob "!{undo,.local}/*"',
			\  'sink': 'edit',
			\  'options': g:fzfOpt
			\ })

" Show all in / except binary
" Will update when more files need to be searched
command! -bang FilesRoot
			\ call fzf#run({
			\  'source': 'rg /etc/systemd --files --no-ignore --hidden --follow --no-messages',
			\  'sink': 'edit',
			\  'options': g:fzfOpt
			\ })

" Unlike fzf#vim#files, respect .gitignore
command! -bang -nargs=1 FilesRepo
			\ call fzf#run({
			\  'source': 'rg ' . <args> . ' --files --hidden --no-messages',
			\  'sink': 'edit',
			\  'options': g:fzfOpt
			\ })

command! -bang -nargs=* Grep
			\ call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, {'options': g:fzfOpt}, <bang>0)
command! -bang -nargs=? -complete=dir Files
			\ call fzf#vim#files(<q-args>, {
			\   'options': g:fzfOpt,
			\   'source': 'rg --files --no-ignore --hidden --follow --no-messages --glob "!{undo,.local}/*"'
			\ }, <bang>0)
command! -bang Colors
			\ call fzf#vim#colors({'options': g:fzfOpt}, <bang>0)
command! -bang -nargs=* History
			\ call fzf#vim#history({'options': g:fzfOpt}, <bang>0)
command! -bang Helptags
			\ call fzf#vim#helptags({'options': g:fzfOpt}, <bang>0)
command! -bang Tags
			\ call fzf#vim#tags(<q-args>, {'options': g:fzfOpt}, <bang>0)
command! -bang Maps
			\ call fzf#vim#maps(<q-args>, {'options': g:fzfOpt}, <bang>0)
command! -bang -nargs=* Lines
			\ call fzf#vim#lines({'options': g:fzfOpt}, <bang>0)
command! -bang -nargs=? -complete=buffer Buffers
			\ call fzf#vim#buffers({'options': g:fzfOpt}, <bang>0)

nnoremap <Leader>ep  :FilesRepo FindRootDirectory()<CR>|                   "Current (p)roject root directory
nnoremap <Leader>erh :FilesRepo "$HOME/"<CR>
nnoremap <Leader>erf :FilesRepo "$HOME/Github/FCC-Exercise-Archive/"<CR>
nnoremap <Leader>erp :FilesRepo "$HOME/Github/LearnPythonTheHardWay/"<CR>
nnoremap <Leader>erw :FilesRepo "$HOME/Github/NearHuscarl.github.io/"<CR>

nnoremap gr :Grep<Space>
nnoremap <Leader>rg :Grep<CR>
nnoremap <Leader>e/ :FilesRoot<CR>
nnoremap <Leader>ef :Files<CR>
" Manually call Rooter because sometimes rooter fail to run automatically
nnoremap <Leader>eh :Files $HOME<CR>
nnoremap <Leader>ea :FilesAll<CR>
nnoremap <Leader>em :History<CR>
nnoremap <Leader>h  :Helptags<CR>
nnoremap <Leader>j  :Tags<CR>
nnoremap <Leader>m  :Maps<CR>
nnoremap <Leader>l  :Lines<CR>
nnoremap <Leader>b  :Buffers<CR>
"}}}
"{{{ vim-rooter
let g:rooter_silent_chdir = 1
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
let gundo_map_move_older = ""
let gundo_map_move_newer = ""
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
"{{{ Easy Tag
let g:easytags_opts = ['--exclude=*vim/plugged/']
let g:easytags_async = 1
let g:easytags_dynamic_files = 2
let g:easytags_events = ['BufWritePost']
let g:easytags_auto_highlight = 0
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
"{{{ Goyo
let g:goyo_width  = 110
let g:goyo_height = 100
let g:goyo_enable = 0

nnoremap <silent>go :call near#utils#ToggleGoyo(goyo_enable)<CR>
"}}}
"{{{ Limelight
nmap <silent>gLL ;Limelight!!<CR>
nmap gLl <Plug>(Limelight)|                  "Motion (normal mode)
xmap gLl <Plug>(Limelight)|                  "Motion (viusal mode)
let g:limelight_priority = -1                      "Do not overrule hlsearch
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

nnoremap <silent><Leader>so :call lazyload#SessionOpen()<CR>
nnoremap <silent><Leader>sO :call lazyload#SessionOPEN()<CR>
nnoremap <silent><Leader>ss :call lazyload#SessionSave()<CR>
nnoremap <silent><Leader>sS :call lazyload#SessionSAVE()<CR>
nnoremap <silent><Leader>sc :call lazyload#SessionClose()<CR>
nnoremap <silent><Leader>sd :call lazyload#SessionDelete()<CR>
nnoremap <silent><Leader>sv :call lazyload#SessionView()<CR>
nnoremap <silent><Leader>sV :call lazyload#SessionVIEW()<CR>
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
if g:os == 'win'
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
let g:sneak#label_esc = "\<A-i>"
let g:sneak#absolute_dir = 1        " Movement in sneak not based on sneak search direction

if ExistsFile(s:plugged . 'vim-sneak')
	nmap <silent> l <Plug>Sneak_;
	nmap <silent> h <Plug>Sneak_,
	vmap <silent> l <Plug>Sneak_;
	vmap <silent> h <Plug>Sneak_,
else
	nnoremap l   ;|                                    "Repeat latest f, F, t or T command (forward)
	nnoremap h   ,|                                    "Repeat latest f, F, t or T command (backward)
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
nnoremap <silent> s :<C-U>call sneak#wrap('',           3, 0, 2, 1)<CR>
nnoremap <silent> S :<C-U>call sneak#wrap('',           3, 1, 2, 1)<CR>
xnoremap <silent> s :<C-U>call sneak#wrap(visualmode(), 3, 0, 2, 1)<CR>
xnoremap <silent> S :<C-U>call sneak#wrap(visualmode(), 3, 1, 2, 1)<CR>
onoremap <silent> s :<C-U>call sneak#wrap(v:operator,   3, 0, 2, 1)<CR>
onoremap <silent> S :<C-U>call sneak#wrap(v:operator,   3, 1, 2, 1)<CR>
hi Sneak guifg=white guibg=magenta ctermfg=15 ctermbg=5
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
"{{{ Table Mode
inoremap <A-t> <Esc>:TableModeToggle<CR>a
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
inoremap <silent><Tab> <C-r>=lazyload#UltiSnips()<CR>

let g:UltiSnipsSnippetsDir = s:snippet                             " Custom snippets stored here
let g:UltiSnipsSnippetDirectories  = ["UltiSnips","snippet"]        " Directories list for ultisnips to search
let g:UltiSnipsEditSplit           = 'normal'
" let g:UltiSnipsExpandTrigger       = "<Tab>"
let g:UltiSnipsListSnippets        = "<C-e>"
let g:UltiSnipsJumpForwardTrigger  = "<A-j>"
let g:UltiSnipsJumpBackwardTrigger = "<A-k>"
"}}}
"{{{ Autocmd
call statusline#SetStatusline()
augroup Statusline
	autocmd!
	autocmd BufEnter * silent! call statusline#UpdateStatuslineInfo()
	autocmd BufWritePost * let g:statuslineLastModified = statusline#SetLastModified()
	autocmd CursorHold * let g:statuslineFileSize  = statusline#SetFileSize()
	autocmd CursorHold * let g:statuslineWordCount = statusline#SetWordCount()
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

autocmd BufEnter * if (&diff || &ft == 'gundo') | set timeout timeoutlen=0   | endif
autocmd BufLeave * if (&diff || &ft == 'gundo') | set timeout& timeoutlen& | endif

autocmd BufEnter *.html let g:AutoPairs["<"] = '>'
autocmd BufLeave *.html unlet g:AutoPairs["<"]

autocmd QuickFixCmdPost * cwindow
autocmd CursorHold * nohlsearch

autocmd FocusLost * if &modified && filereadable(expand("%:p")) | write | endif
autocmd BufWritePre * call license#SetLastChangeBeforeBufWrite()

autocmd BufWritePost *.py,*.js call ctags#Update()

" " Save fold when leaving vim
" autocmd BufWinLeave * silent! mkview
" autocmd BufWinEnter * silent! loadview

if has('gui_running')
	if g:os == 'linux'
		autocmd VimEnter *
					\ if executable('wmctrl')
					\|   call system('wmctrl -i -b add,maximized_vert,maximized_horz -r '.v:windowid)
					\|endif
	elseif g:os == 'win'
		autocmd GUIEnter * simalt ~x            "Open vim in maximum winow size
	endif
endif
"}}}

" feh --hide-pointer --geometry 1000x600 --zoom fill
" feh --hide-pointer --thumbnails --thumb-height 60 --thumb-width 100 --index-info "" --geometry 1000x600 --image-bg black
