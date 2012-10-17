if exists("g:loaded_whitespaste") || &cp
  finish
endif

let g:loaded_whitespaste = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

command WhitespasteBefore :call whitespaste#Paste('P')
command WhitespasteAfter  :call whitespaste#Paste('p')

nmap <Plug>WhitespasteBefore :WhitespasteBefore<cr>
nmap <Plug>WhitespasteAfter  :WhitespasteAfter<cr>

let &cpo = s:keepcpo
unlet s:keepcpo
