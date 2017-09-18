function! near#themes#flat#isAvailable()
endfunc

let s:base0   = { 'gui': "#1f2d3a", 'cterm':  0 }
let s:base1   = { 'gui': "#1f2d3a", 'cterm':  0 }
let s:base2   = { 'gui': "#2c3e50", 'cterm':  8 }
let s:base3   = { 'gui': "#2c3e50", 'cterm':  8 }
let s:base4   = { 'gui': "#2c3e50", 'cterm':  8 }
let s:base5   = { 'gui': "#84888b", 'cterm':  7 }
let s:base6   = { 'gui': "#ecf0f1", 'cterm': 15 }
let s:base7   = { 'gui': "#ecf0f1", 'cterm': 15 }

let s:red     = { 'gui': "#e74c3c", 'cterm':  2 }
let s:orange  = { 'gui': "#f39c12", 'cterm':  3 }
let s:yellow  = { 'gui': "#f1c40f", 'cterm': 11 }
let s:magenta = { 'gui': "#8e44ad", 'cterm':  5 }
let s:violet  = { 'gui': "#9b59b6", 'cterm': 13 }
let s:blue    = { 'gui': "#2980b9", 'cterm':  4 }
let s:cyan    = { 'gui': "#16a085", 'cterm':  6 }
let s:green   = { 'gui': "#27ae60", 'cterm':  2 }

let g:near#themes#flat#normal  = { 'fg': s:base6,  'bg': s:blue   }
let g:near#themes#flat#insert  = { 'fg': s:base7,  'bg': s:green   }
let g:near#themes#flat#visual  = { 'fg': s:base7,  'bg': s:magenta }
let g:near#themes#flat#vLine   = { 'fg': s:base7,  'bg': s:violet  }
let g:near#themes#flat#vBlock  = { 'fg': s:base0,  'bg': s:orange  }
let g:near#themes#flat#replace = { 'fg': s:base7,  'bg': s:red     }
let g:near#themes#flat#prompt  = { 'fg': s:yellow, 'bg': s:base2   }

let g:near#themes#flat#inactive = { 'fg': s:base5,  'bg': s:base1  }| " StatusLineNC
let g:near#themes#flat#filename = { 'fg': s:base5,  'bg': s:base2  }| " User1
let g:near#themes#flat#modified = { 'fg': s:base7,  'bg': s:cyan   }| " User1
let g:near#themes#flat#main     = { 'fg': s:base5,  'bg': s:base2  }| " User2
let g:near#themes#flat#branch   = { 'fg': s:base7,  'bg': s:base0  }| " User3
let g:near#themes#flat#plugin   = { 'fg': s:base2,  'bg': s:yellow }| " User4
let g:near#themes#flat#none     = { 'fg': s:base5,  'bg': s:base0  }| " User9 - Transparent
