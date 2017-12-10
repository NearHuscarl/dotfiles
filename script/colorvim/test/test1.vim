" ==================================================================
" File:        test1.vim
" Description: test1 colorscheme
" Author:      Near Huscarl <near.huscarl@gmail.com>
" Last Change: Sun Dec 10 19:36:17 +07 2017
" Licence:     BSD 3-Clauses
" ==================================================================

" Name             Hex      Rgb                 Xterm
" ==================================================================
" midnight         #1F2D3A  rgb(31, 45, 58)     0
" persian_red      #C0392B  rgb(192, 57, 43)    1
" jungle_green     #27AE60  rgb(39, 174, 96)    2
" gamboge          #F39C12  rgb(243, 156, 18)   3
" pelorous         #2980B9  rgb(41, 128, 185)   4
" deep_lilac       #8E44AD  rgb(142, 68, 173)   5
" mountain_meadow  #16A085  rgb(22, 160, 133)   6
" aluminium        #84888B  rgb(132, 136, 139)  7
" madison          #2C3E50  rgb(44, 62, 80)     8
" cinnabar         #E74C3C  rgb(231, 76, 60)    9
" shamrock         #2ECC71  rgb(46, 204, 113)   10
" moon_yellow      #F1C40F  rgb(241, 196, 15)   11
" summer_sky       #3498DB  rgb(52, 152, 219)   12
" wisteria         #9B59B6  rgb(155, 89, 182)   13
" java             #2AA198  rgb(42, 161, 152)   14
" solitude         #ECF0F1  rgb(236, 240, 241)  15

hi clear

if exists('syntax_on')
  syntax reset
endif

let colors_name = 'test1'
set background=dark

if ($TERM =~ '256' || &t_Co >= 256) || has('gui_running')
hi Normal     ctermbg=NONE ctermfg=7    guibg=NONE    guifg=#84888B cterm=NONE    gui=NONE
hi Comment    ctermbg=NONE ctermfg=7    guibg=NONE    guifg=#84888B cterm=NONE    gui=NONE
hi Identifer  ctermbg=NONE ctermfg=4    guibg=NONE    guifg=#2980B9 cterm=NONE    gui=NONE
hi Statuslne  ctermbg=4    ctermfg=15   guibg=#2980B9 guifg=#ECF0F1 cterm=NONE    gui=NONE
hi Function   ctermbg=NONE ctermfg=3    guibg=NONE    guifg=#F39C12 cterm=NONE    gui=NONE
hi Constant   ctermbg=NONE ctermfg=9    guibg=NONE    guifg=#E74C3C cterm=NONE    gui=NONE
hi DiffChange ctermbg=3    ctermfg=NONE guibg=#F39C12 guifg=NONE    cterm=NONE    gui=NONE
endif
