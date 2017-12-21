" ==================================================================
" File:        flat.vim
" Description: flat colorscheme
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Fri Dec 22 02:32:23 +07 2017
" Licence:     BSD 3-Clauses
" ==================================================================

" Name         Hex      Rgb                 Xterm
" ==================================================================
" dark         #1F2D3A  rgb(31, 45, 58)     0
" darkred      #C0392B  rgb(192, 57, 43)    1
" green        #27AE60  rgb(39, 174, 96)    2
" yellow       #F39C12  rgb(243, 156, 18)   3
" blue         #2980B9  rgb(41, 128, 185)   4
" purple       #8E44AD  rgb(142, 68, 173)   5
" cyan         #16A085  rgb(22, 160, 133)   6
" gray         #84888B  rgb(132, 136, 139)  7
" darkgray     #2C3E50  rgb(44, 62, 80)     8
" red          #E74C3C  rgb(231, 76, 60)    9
" lightgreen   #2ECC71  rgb(46, 204, 113)   10
" lightyellow  #F1C40F  rgb(241, 196, 15)   11
" lightblue    #3498DB  rgb(52, 152, 219)   12
" violet       #9B59B6  rgb(155, 89, 182)   13
" lightcyan    #2AA198  rgb(42, 161, 152)   14
" white        #ECF0F1  rgb(236, 240, 241)  15

hi clear

if exists('syntax_on')
	syntax reset
endif

let colors_name = 'flat'
set background=dark

if ($TERM =~ '256' || &t_Co >= 256) || has('gui_running')
	hi Normal        ctermfg=15   ctermbg=0    guifg=#ECF0F1 guibg=#1F2D3A cterm=NONE      gui=NONE
	hi LineNr        ctermfg=7    ctermbg=0    guifg=#84888B guibg=#1F2D3A cterm=NONE      gui=NONE
	hi FoldColumn    ctermfg=7    ctermbg=0    guifg=#84888B guibg=#1F2D3A cterm=NONE      gui=NONE
	hi Folded        ctermfg=7    ctermbg=0    guifg=#84888B guibg=#1F2D3A cterm=NONE      gui=NONE
	hi MatchParen    ctermfg=11   ctermbg=0    guifg=#F1C40F guibg=#1F2D3A cterm=NONE      gui=NONE
	hi SignColumn    ctermfg=7    ctermbg=0    guifg=#84888B guibg=#1F2D3A cterm=NONE      gui=NONE
	hi Comment       ctermfg=7    ctermbg=NONE guifg=#84888B guibg=NONE    cterm=NONE      gui=NONE
	hi Conceal       ctermfg=15   ctermbg=NONE guifg=#ECF0F1 guibg=NONE    cterm=NONE      gui=NONE
	hi Constant      ctermfg=9    ctermbg=NONE guifg=#E74C3C guibg=NONE    cterm=NONE      gui=NONE
	hi Error         ctermfg=1    ctermbg=NONE guifg=#C0392B guibg=NONE    cterm=reverse   gui=reverse
	hi Identifier    ctermfg=4    ctermbg=NONE guifg=#2980B9 guibg=NONE    cterm=NONE      gui=NONE
	hi Ignore        ctermfg=NONE ctermbg=NONE guifg=NONE    guibg=NONE    cterm=NONE      gui=NONE
	hi PreProc       ctermfg=9    ctermbg=NONE guifg=#E74C3C guibg=NONE    cterm=NONE      gui=NONE
	hi Special       ctermfg=9    ctermbg=NONE guifg=#E74C3C guibg=NONE    cterm=NONE      gui=NONE
	hi Statement     ctermfg=3    ctermbg=NONE guifg=#F39C12 guibg=NONE    cterm=NONE      gui=NONE
	hi String        ctermfg=6    ctermbg=NONE guifg=#16A085 guibg=NONE    cterm=NONE      gui=NONE
	hi Todo          ctermfg=NONE ctermbg=NONE guifg=NONE    guibg=NONE    cterm=reverse   gui=reverse
	hi Type          ctermfg=13   ctermbg=NONE guifg=#9B59B6 guibg=NONE    cterm=NONE      gui=NONE
	hi Underlined    ctermfg=6    ctermbg=NONE guifg=#16A085 guibg=NONE    cterm=underline gui=underline
	hi NonText       ctermfg=7    ctermbg=NONE guifg=#84888B guibg=NONE    cterm=NONE      gui=NONE
	hi Pmenu         ctermfg=15   ctermbg=8    guifg=#ECF0F1 guibg=#2C3E50 cterm=NONE      gui=NONE
	hi PmenuSbar     ctermfg=NONE ctermbg=8    guifg=NONE    guibg=#2C3E50 cterm=NONE      gui=NONE
	hi PmenuSel      ctermfg=0    ctermbg=6    guifg=#1F2D3A guibg=#16A085 cterm=NONE      gui=NONE
	hi PmenuThumb    ctermfg=6    ctermbg=6    guifg=#16A085 guibg=#16A085 cterm=NONE      gui=NONE
	hi ErrorMsg      ctermfg=0    ctermbg=1    guifg=#1F2D3A guibg=#C0392B cterm=NONE      gui=NONE
	hi ModeMsg       ctermfg=0    ctermbg=10   guifg=#1F2D3A guibg=#2ECC71 cterm=NONE      gui=NONE
	hi MoreMsg       ctermfg=6    ctermbg=NONE guifg=#16A085 guibg=NONE    cterm=NONE      gui=NONE
	hi Question      ctermfg=10   ctermbg=NONE guifg=#2ECC71 guibg=NONE    cterm=NONE      gui=NONE
	hi WarningMsg    ctermfg=1    ctermbg=NONE guifg=#C0392B guibg=NONE    cterm=NONE      gui=NONE
	hi TabLine       ctermfg=3    ctermbg=8    guifg=#F39C12 guibg=#2C3E50 cterm=NONE      gui=NONE
	hi TabLineFill   ctermfg=8    ctermbg=8    guifg=#2C3E50 guibg=#2C3E50 cterm=NONE      gui=NONE
	hi TabLineSel    ctermfg=8    ctermbg=3    guifg=#2C3E50 guibg=#F39C12 cterm=NONE      gui=NONE
	hi Cursor        ctermfg=NONE ctermbg=NONE guifg=NONE    guibg=NONE    cterm=reverse   gui=reverse
	hi CursorColumn  ctermfg=NONE ctermbg=8    guifg=NONE    guibg=#2C3E50 cterm=NONE      gui=NONE
	hi CursorLineNr  ctermfg=14   ctermbg=8    guifg=#2AA198 guibg=#2C3E50 cterm=NONE      gui=NONE
	hi CursorLine    ctermfg=NONE ctermbg=8    guifg=NONE    guibg=#2C3E50 cterm=NONE      gui=NONE
	hi helpLeadBlank ctermfg=NONE ctermbg=NONE guifg=NONE    guibg=NONE    cterm=NONE      gui=NONE
	hi helpNormal    ctermfg=NONE ctermbg=NONE guifg=NONE    guibg=NONE    cterm=NONE      gui=NONE
	hi StatusLine    ctermfg=15   ctermbg=4    guifg=#ECF0F1 guibg=#2980B9 cterm=NONE      gui=NONE
	hi StatusLineNC  ctermfg=3    ctermbg=8    guifg=#F39C12 guibg=#2C3E50 cterm=NONE      gui=NONE
	hi Visual        ctermfg=15   ctermbg=4    guifg=#ECF0F1 guibg=#2980B9 cterm=NONE      gui=NONE
	hi VisualNOS     ctermfg=15   ctermbg=7    guifg=#ECF0F1 guibg=#84888B cterm=underline gui=underline
	hi VertSplit     ctermfg=8    ctermbg=8    guifg=#2C3E50 guibg=#2C3E50 cterm=NONE      gui=NONE
	hi WildMenu      ctermfg=15   ctermbg=5    guifg=#ECF0F1 guibg=#8E44AD cterm=NONE      gui=NONE
	hi Function      ctermfg=12   ctermbg=NONE guifg=#3498DB guibg=NONE    cterm=NONE      gui=NONE
	hi SpecialKey    ctermfg=7    ctermbg=NONE guifg=#84888B guibg=NONE    cterm=NONE      gui=NONE
	hi Title         ctermfg=15   ctermbg=NONE guifg=#ECF0F1 guibg=NONE    cterm=NONE      gui=NONE
	hi DiffAdd       ctermfg=6    ctermbg=15   guifg=#16A085 guibg=#ECF0F1 cterm=reverse   gui=reverse
	hi DiffChange    ctermfg=8    ctermbg=15   guifg=#2C3E50 guibg=#ECF0F1 cterm=reverse   gui=reverse
	hi DiffDelete    ctermfg=1    ctermbg=15   guifg=#C0392B guibg=#ECF0F1 cterm=reverse   gui=reverse
	hi DiffText      ctermfg=3    ctermbg=0    guifg=#F39C12 guibg=#1F2D3A cterm=reverse   gui=reverse
	hi IncSearch     ctermfg=0    ctermbg=1    guifg=#1F2D3A guibg=#C0392B cterm=NONE      gui=NONE
	hi Search        ctermfg=15   ctermbg=6    guifg=#ECF0F1 guibg=#16A085 cterm=NONE      gui=NONE
	hi Directory     ctermfg=14   ctermbg=NONE guifg=#2AA198 guibg=NONE    cterm=NONE      gui=NONE
	hi ColorColum    ctermfg=NONE ctermbg=0    guifg=NONE    guibg=#1F2D3A cterm=NONE      gui=NONE
endif

hi link Boolean                  Constant
hi link Character                Constant
hi link Conditional              Statement
hi link Debug                    Special
hi link Define                   PreProc
hi link Delimiter                Special
hi link Exception                Statement
hi link Float                    Number
hi link HelpCommand              Statement
hi link HelpExample              Statement
hi link Include                  PreProc
hi link Keyword                  Statement
hi link Label                    Statement
hi link Macro                    PreProc
hi link Number                   Constant
hi link Operator                 Statement
hi link PreCondit                PreProc
hi link Repeat                   Statement
hi link SpecialChar              Special
hi link SpecialComment           Special
hi link StorageClass             Type
hi link Structure                Type
hi link Tag                      Special
hi link Typedef                  Type
hi link htmlEndTag               htmlTagName
hi link htmlLink                 Function
hi link htmlSpecialTagName       htmlTagName
hi link htmlTag                  htmlTagName
hi link htmlBold                 Normal
hi link htmlItalic               Normal
hi link xmlTag                   Statement
hi link xmlTagName               Statement
hi link xmlEndTag                Statement
hi link markdownItalic           Preproc
hi link asciidocQuotedEmphasized Preproc
hi link diffBDiffer              WarningMsg
hi link diffCommon               WarningMsg
hi link diffDiffer               WarningMsg
hi link diffIdentical            WarningMsg
hi link diffIsA                  WarningMsg
hi link diffNoEOL                WarningMsg
hi link diffOnly                 WarningMsg
hi link diffRemoved              WarningMsg
hi link diffAdded                String
