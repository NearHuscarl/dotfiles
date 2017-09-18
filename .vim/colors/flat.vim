" 'flat.vim' -- Vim color scheme.
" Author:       Romain Lafourcade (romainlafourcade@gmail.com)
" Description:  Essentially a streamlining and conversion to xterm colors of
"               'sorcerer' by Jeet Sukumaran (jeetsukumaran@gmailcom)
" Last Change:  2017 Aug 06

" MADE-UP NAME    HEX        RGB                   XTERM  ANSI
" ========================================================================
" almost black    #1f2d3a    rgb(28, 28, 28)       0      0
" darker grey     #1f2d3a    rgb(38, 38, 38)       0      background color
" dark grey       #2c3e50    rgb(48, 48, 48)       8      8
" grey            #2c3e50    rgb(68, 68, 68)       8      8
" medium grey     #2c3e50    rgb(88, 88, 88)       8      8
" light grey      #84888b    rgb(10, 10, 10)       7      7
" lighter grey    #ecf0f1    rgb(188, 188, 188)    15     foreground color
" white           #ecf0f1    rgb(255, 255, 255)    15     15
" purple          #8e44ad    rgb(95, 95, 135)      5      5
" light purple    #9b59b6    rgb(135, 135, 175)    13     13
" green           #27ae60    rgb(95, 135, 95)      2      2
" light green     #2ecc71    rgb(135, 175, 135)    10     10
" aqua            #16a085    rgb(95, 135, 135)     6      6
" light aqua      #2aa198    rgb(95, 175, 175)     14     14
" blue            #2980b9    rgb(95, 135, 175)     4      4
" light blue      #3498db    rgb(143, 175, 215)    12     12
" red             #c0392b    rgb(175, 95, 95)      1      1
" orange          #e74c3c    rgb(255, 135, 0)      9      9
" ocre            #f39c12    rgb(135, 135, 95)     3      3
" yellow          #f1c40f    rgb(255, 255, 175)    11     11

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "flat"

if ($TERM =~ '256' || &t_Co >= 256) || has("gui_running")
  hi Normal     ctermbg=0 ctermfg=15 guibg=#1f2d3a guifg=#ecf0f1 cterm=NONE gui=NONE
  hi LineNr     ctermbg=0 ctermfg=7  guibg=#1f2d3a guifg=#84888b cterm=NONE gui=NONE
  hi FoldColumn ctermbg=0 ctermfg=7  guibg=#1f2d3a guifg=#84888b cterm=NONE gui=NONE
  hi Folded     ctermbg=0 ctermfg=7  guibg=#1f2d3a guifg=#84888b cterm=NONE gui=NONE
  hi MatchParen ctermbg=0 ctermfg=11 guibg=#1f2d3a guifg=#f1c40f cterm=NONE gui=NONE
  hi signColumn ctermbg=0 ctermfg=7  guibg=#1f2d3a guifg=#84888b cterm=NONE gui=NONE

  set background=dark

  hi Comment    ctermbg=NONE ctermfg=7    guibg=NONE guifg=#84888b cterm=NONE      gui=NONE
  hi Conceal    ctermbg=NONE ctermfg=15   guibg=NONE guifg=#ecf0f1 cterm=NONE      gui=NONE
  hi Constant   ctermbg=NONE ctermfg=9    guibg=NONE guifg=#e74c3c cterm=NONE      gui=NONE
  hi Error      ctermbg=NONE ctermfg=1    guibg=NONE guifg=#c0392b cterm=reverse   gui=reverse
  hi Identifier ctermbg=NONE ctermfg=4    guibg=NONE guifg=#2980b9 cterm=NONE      gui=NONE
  hi Ignore     ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE    cterm=NONE      gui=NONE
  hi PreProc    ctermbg=NONE ctermfg=9    guibg=NONE guifg=#e74c3c cterm=NONE      gui=NONE
  hi Special    ctermbg=NONE ctermfg=9    guibg=NONE guifg=#e74c3c cterm=NONE      gui=NONE
  hi Statement  ctermbg=NONE ctermfg=3    guibg=NONE guifg=#f39c12 cterm=NONE      gui=NONE
  hi String     ctermbg=NONE ctermfg=6    guibg=NONE guifg=#16a085 cterm=NONE      gui=NONE
  hi Todo       ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE    cterm=reverse   gui=reverse
  hi Type       ctermbg=NONE ctermfg=13   guibg=NONE guifg=#9b59b6 cterm=NONE      gui=NONE
  hi Underlined ctermbg=NONE ctermfg=6    guibg=NONE guifg=#16a085 cterm=underline gui=underline

  hi NonText       ctermbg=NONE ctermfg=8    guibg=NONE    guifg=#2c3e50 cterm=NONE      gui=NONE

  hi Pmenu         ctermbg=8    ctermfg=15   guibg=#2c3e50 guifg=#ecf0f1 cterm=NONE      gui=NONE
  hi PmenuSbar     ctermbg=8    ctermfg=NONE guibg=#2c3e50 guifg=NONE    cterm=NONE      gui=NONE
  hi PmenuSel      ctermbg=6    ctermfg=0    guibg=#16a085 guifg=#1f2d3a cterm=NONE      gui=NONE
  hi PmenuThumb    ctermbg=6    ctermfg=6    guibg=#16a085 guifg=#16a085 cterm=NONE      gui=NONE

  hi ErrorMsg      ctermbg=1    ctermfg=0    guibg=#c0392b guifg=#1f2d3a cterm=NONE      gui=NONE
  hi ModeMsg       ctermbg=10   ctermfg=0    guibg=#2ecc71 guifg=#1f2d3a cterm=NONE      gui=NONE
  hi MoreMsg       ctermbg=NONE ctermfg=6    guibg=NONE    guifg=#16a085 cterm=NONE      gui=NONE
  hi Question      ctermbg=NONE ctermfg=10   guibg=NONE    guifg=#2ecc71 cterm=NONE      gui=NONE
  hi WarningMsg    ctermbg=NONE ctermfg=1    guibg=NONE    guifg=#c0392b cterm=NONE      gui=NONE

  hi TabLine       ctermbg=8    ctermfg=3    guibg=#2c3e50 guifg=#f39c12 cterm=NONE      gui=NONE
  hi TabLineFill   ctermbg=8    ctermfg=8    guibg=#2c3e50 guifg=#2c3e50 cterm=NONE      gui=NONE
  hi TabLineSel    ctermbg=3    ctermfg=0    guibg=#f39c12 guifg=#1f2d3a cterm=NONE      gui=NONE

  hi Cursor        ctermbg=7    ctermfg=NONE guibg=#84888b guifg=NONE    cterm=NONE      gui=NONE
  hi CursorColumn  ctermbg=8    ctermfg=NONE guibg=#2c3e50 guifg=NONE    cterm=NONE      gui=NONE
  hi CursorLineNr  ctermbg=8    ctermfg=14   guibg=#2c3e50 guifg=#2aa198 cterm=NONE      gui=NONE
  hi CursorLine    ctermbg=8    ctermfg=NONE guibg=#2c3e50 guifg=NONE    cterm=NONE      gui=NONE

  hi helpLeadBlank ctermbg=NONE ctermfg=NONE guibg=NONE    guifg=NONE    cterm=NONE      gui=NONE
  hi helpNormal    ctermbg=NONE ctermfg=NONE guibg=NONE    guifg=NONE    cterm=NONE      gui=NONE

  hi StatusLine    ctermbg=3    ctermfg=0    guibg=#f39c12 guifg=#1f2d3a cterm=NONE      gui=NONE
  hi StatusLineNC  ctermbg=8    ctermfg=3    guibg=#2c3e50 guifg=#f39c12 cterm=NONE      gui=NONE

  hi Visual        ctermbg=4    ctermfg=15   guibg=#2980b9 guifg=#ecf0f1 cterm=NONE      gui=NONE   
  hi VisualNOS     ctermbg=7    ctermfg=15   guibg=#84888b guifg=#ecf0f1 cterm=underline gui=underline

  hi VertSplit     ctermbg=8    ctermfg=8    guibg=#2c3e50 guifg=#2c3e50 cterm=NONE      gui=NONE
  hi WildMenu      ctermbg=12   ctermfg=0    guibg=#3498db guifg=#1f2d3a cterm=NONE      gui=NONE

  hi Function      ctermbg=NONE ctermfg=12   guibg=NONE    guifg=#f1c40f cterm=NONE      gui=NONE
  hi SpecialKey    ctermbg=NONE ctermfg=8    guibg=NONE    guifg=#2c3e50 cterm=NONE      gui=NONE
  hi Title         ctermbg=NONE ctermfg=15   guibg=NONE    guifg=#ecf0f1 cterm=NONE      gui=NONE

  hi DiffAdd       ctermbg=15   ctermfg=6    guibg=#ecf0f1 guifg=#16a085 cterm=reverse   gui=reverse
  hi DiffChange    ctermbg=15   ctermfg=8    guibg=#ecf0f1 guifg=#2c3e50 cterm=reverse   gui=reverse
  hi DiffDelete    ctermbg=15   ctermfg=1    guibg=#ecf0f1 guifg=#c0392b cterm=reverse   gui=reverse
  hi DiffText      ctermbg=0    ctermfg=3    guibg=#1f2d3a guifg=#f39c12 cterm=reverse   gui=reverse

  hi IncSearch     ctermbg=1    ctermfg=0    guibg=#c0392b guifg=#1f2d3a cterm=NONE      gui=NONE
  hi Search        ctermbg=11   ctermfg=0    guibg=#f1c40f guifg=#1f2d3a cterm=NONE      gui=NONE

  hi Directory     ctermbg=NONE ctermfg=14   guibg=NONE    guifg=#2aa198 cterm=NONE      gui=NONE

  if has("gui_running")
    hi SpellBad   ctermbg=NONE ctermfg=1  guibg=NONE guifg=NONE cterm=undercurl gui=undercurl guisp=#c0392b
    hi SpellCap   ctermbg=NONE ctermfg=14 guibg=NONE guifg=NONE cterm=undercurl gui=undercurl guisp=#2aa198
    hi SpellLocal ctermbg=NONE ctermfg=2  guibg=NONE guifg=NONE cterm=undercurl gui=undercurl guisp=#27ae60
    hi SpellRare  ctermbg=NONE ctermfg=9  guibg=NONE guifg=NONE cterm=undercurl gui=undercurl guisp=#e74c3c
  else
    hi SpellBad   ctermbg=NONE ctermfg=1  guibg=NONE guifg=#c0392b cterm=undercurl gui=undercurl guisp=NONE
    hi SpellCap   ctermbg=NONE ctermfg=14 guibg=NONE guifg=#2aa198 cterm=undercurl gui=undercurl guisp=NONE
    hi SpellLocal ctermbg=NONE ctermfg=2  guibg=NONE guifg=#27ae60 cterm=undercurl gui=undercurl guisp=NONE
    hi SpellRare  ctermbg=NONE ctermfg=9  guibg=NONE guifg=#e74c3c cterm=undercurl gui=undercurl guisp=NONE
  endif

  hi ColorColumn      ctermbg=0  ctermfg=NONE guibg=#1f2d3a guifg=NONE    cterm=NONE           gui=NONE
elseif &t_Co == 8 || $TERM !~# '^linux' || &t_Co == 16
  set t_Co=16

  hi Normal           ctermbg=NONE        ctermfg=white          cterm=NONE

  set background=dark

  hi Comment       ctermbg=NONE       ctermfg=lightgray   cterm=NONE
  hi Conceal       ctermbg=NONE       ctermfg=white       cterm=NONE
  hi Constant      ctermbg=NONE       ctermfg=red         cterm=NONE
  hi Function      ctermbg=NONE       ctermfg=yellow      cterm=NONE
  hi Identifier    ctermbg=NONE       ctermfg=darkblue    cterm=NONE
  hi PreProc       ctermbg=NONE       ctermfg=lightred    cterm=NONE
  hi Special       ctermbg=NONE       ctermfg=lightred    cterm=NONE
  hi Statement     ctermbg=NONE       ctermfg=darkyellow  cterm=NONE
  hi String        ctermbg=NONE       ctermfg=cyan        cterm=NONE
  hi Todo          ctermbg=NONE       ctermfg=NONE        cterm=reverse
  hi Type          ctermbg=NONE       ctermfg=magenta     cterm=NONE

  hi Error         ctermbg=NONE       ctermfg=darkred     cterm=reverse
  hi Ignore        ctermbg=NONE       ctermfg=NONE        cterm=NONE
  hi Underlined    ctermbg=NONE       ctermfg=NONE        cterm=reverse

  hi LineNr        ctermbg=black      ctermfg=gray        cterm=NONE
  hi NonText       ctermbg=NONE       ctermfg=darkgray    cterm=NONE

  hi Pmenu         ctermbg=darkgray   ctermfg=white       cterm=NONE
  hi PmenuSbar     ctermbg=gray       ctermfg=NONE        cterm=NONE
  hi PmenuSel      ctermbg=darkcyan   ctermfg=black       cterm=NONE
  hi PmenuThumb    ctermbg=darkcyan   ctermfg=NONE        cterm=NONE

  hi ErrorMsg      ctermbg=darkred    ctermfg=black       cterm=NONE
  hi ModeMsg       ctermbg=darkgreen  ctermfg=black       cterm=NONE
  hi MoreMsg       ctermbg=NONE       ctermfg=darkcyan    cterm=NONE
  hi Question      ctermbg=NONE       ctermfg=green       cterm=NONE
  hi WarningMsg    ctermbg=NONE       ctermfg=darkred     cterm=NONE

  hi TabLine       ctermbg=darkgray   ctermfg=darkyellow  cterm=NONE
  hi TabLineFill   ctermbg=darkgray   ctermfg=black       cterm=NONE
  hi TabLineSel    ctermbg=darkyellow ctermfg=black       cterm=NONE

  hi Cursor        ctermbg=NONE       ctermfg=NONE        cterm=NONE
  hi CursorColumn  ctermbg=darkgray   ctermfg=NONE        cterm=NONE
  hi CursorLineNr  ctermbg=black      ctermfg=cyan        cterm=NONE
  hi CursorLine    ctermbg=darkgray   ctermfg=NONE        cterm=NONE

  hi helpLeadBlank ctermbg=NONE       ctermfg=NONE        cterm=NONE
  hi helpNormal    ctermbg=NONE       ctermfg=NONE        cterm=NONE

  hi StatusLine    ctermbg=darkyellow ctermfg=black       cterm=NONE
  hi StatusLineNC  ctermbg=darkgray   ctermfg=darkyellow  cterm=NONE

  hi Visual        ctermbg=white      ctermfg=blue        cterm=reverse
  hi VisualNOS     ctermbg=lightgray  ctermfg=white       cterm=NONE

  hi FoldColumn    ctermbg=black      ctermfg=darkgray    cterm=NONE
  hi Folded        ctermbg=black      ctermfg=darkgray    cterm=NONE

  hi VertSplit     ctermbg=darkgray   ctermfg=darkgray    cterm=NONE
  hi WildMenu      ctermbg=blue       ctermfg=black       cterm=NONE

  hi SpecialKey    ctermbg=NONE       ctermfg=darkgray    cterm=NONE
  hi Title         ctermbg=NONE       ctermfg=white       cterm=NONE

  hi DiffAdd       ctermbg=white      ctermfg=cyan        cterm=reverse
  hi DiffChange    ctermbg=black      ctermfg=darkyellow  cterm=reverse
  hi DiffDelete    ctermbg=white      ctermfg=darkred     cterm=reverse
  hi DiffText      ctermbg=white      ctermfg=red         cterm=reverse

  hi IncSearch     ctermbg=darkred    ctermfg=black       cterm=NONE
  hi Search        ctermbg=yellow     ctermfg=black       cterm=NONE

  hi Directory     ctermbg=NONE       ctermfg=cyan        cterm=NONE
  hi MatchParen    ctermbg=black      ctermfg=yellow      cterm=NONE

  hi SpellBad      ctermbg=NONE       ctermfg=darkred     cterm=undercurl
  hi SpellCap      ctermbg=NONE       ctermfg=darkyellow  cterm=undercurl
  hi SpellLocal    ctermbg=NONE       ctermfg=darkgreen   cterm=undercurl
  hi SpellRare     ctermbg=NONE       ctermfg=darkmagenta cterm=undercurl

  hi ColorColumn   ctermbg=black      ctermfg=NONE        cterm=NONE
  hi SignColumn    ctermbg=black      ctermfg=darkgray    cterm=NONE
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
