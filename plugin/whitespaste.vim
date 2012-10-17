if exists("g:loaded_whitespaste") || &cp
  finish
endif

let g:loaded_whitespaste = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

command WhitespastePasteBefore :call whitespaste#Paste('P')
command WhitespastePasteAfter  :call whitespaste#Paste('p')

nmap <Plug>WhitespastePasteBefore :WhitespastePasteBefore<cr>
nmap <Plug>WhitespastePasteAfter  :WhitespastePasteAfter<cr>

let &cpo = s:keepcpo
unlet s:keepcpo
