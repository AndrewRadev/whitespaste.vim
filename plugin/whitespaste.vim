if exists("g:loaded_whitespaste") || &cp
  finish
endif

let g:loaded_whitespaste = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

nmap <Plug>WhitespastePaste :call whitespaste#Paste()<cr>

let &cpo = s:keepcpo
unlet s:keepcpo
