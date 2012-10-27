if exists("g:loaded_whitespaste") || &cp
  finish
endif

let g:loaded_whitespaste = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

if !exists('g:whitespaste_linewise_definitions')
  let g:whitespaste_linewise_definitions = {
        \   'top': [
        \     { 'target_line': 0, 'blank_lines': 0 },
        \     { 'compress_blank_lines': 1 },
        \   ],
        \   'bottom': [
        \     { 'target_line': -1, 'blank_lines': 0 },
        \     { 'compress_blank_lines': 1 },
        \   ]
        \ }
endif

autocmd FileType ruby let b:whitespaste_linewise_definitions = {
      \   'top': [
      \     { 'target_text': '^\s*\%(class\|def\|if\|it\)\>',              'blank_lines': 0 },
      \     { 'target_text': '^\s*\%(end\|public\|private\|protected\)\>', 'blank_lines': 1 },
      \   ],
      \   'bottom': [
      \     { 'target_text': '^\s*end\>',                             'blank_lines': 0 },
      \     { 'target_text': '^\s*\%(def\|if\|it\)\>',                'blank_lines': 1 },
      \     { 'target_text': '^\s*\%(public\|private\|protected\)\>', 'blank_lines': 1 },
      \   ]
      \ }

command WhitespasteBefore :call whitespaste#Paste('P')
command WhitespasteAfter  :call whitespaste#Paste('p')

nmap <Plug>WhitespasteBefore :WhitespasteBefore<cr>
nmap <Plug>WhitespasteAfter  :WhitespasteAfter<cr>

let &cpo = s:keepcpo
unlet s:keepcpo
