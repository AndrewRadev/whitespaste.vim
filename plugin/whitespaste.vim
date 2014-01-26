if exists("g:loaded_whitespaste") || &cp
  finish
endif

let g:loaded_whitespaste = '0.2.0' " version number
let s:keepcpo = &cpo
set cpo&vim

if !exists('g:whitespaste_paste_before_command')
  let g:whitespaste_paste_before_command = 'normal! P'
endif

if !exists('g:whitespaste_paste_after_command')
  let g:whitespaste_paste_after_command = 'normal! p'
endif

if !exists('g:whitespaste_paste_visual_command')
  let g:whitespaste_paste_visual_command = 'normal! gvp'
endif

if !exists('g:whitespaste_before_mapping')
  let g:whitespaste_before_mapping = 'P'
endif

if !exists('g:whitespaste_after_mapping')
  let g:whitespaste_after_mapping = 'p'
endif

if !exists('g:whitespaste_linewise_definitions')
  let g:whitespaste_linewise_definitions = {
        \   'top': [
        \     { 'target_line': 0,           'blank_lines': 0 },
        \     { 'target_text': '^\s*}\s*$', 'pasted_text': '{\s*$', 'blank_lines': 1 },
        \     { 'target_text': '{\s*$',     'blank_lines': 0 },
        \     { 'compress_blank_lines': 1 },
        \   ],
        \   'bottom': [
        \     { 'target_line': -1,          'blank_lines': 0 },
        \     { 'target_text': '{\s*$',     'pasted_text': '^\s*}\s*$', 'blank_lines': 1 },
        \     { 'target_text': '^\s*}\s*$', 'blank_lines': 0 },
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
      \     { 'target_text': '^\s*end\>',                                    'blank_lines': 0 },
      \     { 'target_text': '^\s*\%(def\|if\|unless\|while\|until\|it\)\>', 'blank_lines': 1 },
      \     { 'target_text': '^\s*\%(public\|private\|protected\)\>',        'blank_lines': 1 },
      \   ]
      \ }

autocmd FileType vim let b:whitespaste_linewise_definitions = {
      \   'top': [
      \     { 'target_text': '^\s*end\%(function\|while\|for\|if\)\>', 'blank_lines': 1 },
      \   ],
      \   'bottom': [
      \     { 'target_line': -1,                                       'blank_lines': 0 },
      \     { 'target_text': '^\s*end\%(function\|while\|for\|if\)\>', 'blank_lines': 0 },
      \     { 'pasted_text': '^\s*end\%(function\|while\|for\|if\)\>', 'blank_lines': 1 },
      \   ]
      \ }

autocmd FileType html,php,eruby,eco let b:whitespaste_linewise_definitions = {
      \   'top': [
      \     { 'target_text': '^\s*<\k\+[^<]*>\s*$', 'blank_lines': 0 },
      \     { 'target_text': '^\s*</\k\+>\s*$',     'blank_lines': 1 },
      \   ],
      \   'bottom': [
      \     { 'target_text': '^\s*</\k\+>\s*$',     'blank_lines': 0 },
      \     { 'target_text': '^\s*<\k\+[^<]*>\s*$', 'blank_lines': 1 },
      \   ]
      \ }

command! -count WhitespasteBefore call whitespaste#Paste(g:whitespaste_paste_before_command)
command! -count WhitespasteAfter  call whitespaste#Paste(g:whitespaste_paste_after_command)
command! -range WhitespasteVisual call whitespaste#Paste(g:whitespaste_paste_visual_command)

nmap <Plug>WhitespasteBefore :WhitespasteBefore<cr>
nmap <Plug>WhitespasteAfter  :WhitespasteAfter<cr>
xmap <Plug>WhitespasteVisual :WhitespasteVisual<cr>


if g:whitespaste_before_mapping != ''
  exe 'nmap ' . g:whitespaste_before_mapping . ' <Plug>WhitespasteBefore'
  exe 'xmap ' . g:whitespaste_before_mapping . ' <Plug>WhitespasteVisual'
endif

if g:whitespaste_after_mapping != ''
  exe 'nmap ' . g:whitespaste_after_mapping . ' <Plug>WhitespasteAfter'
  exe 'xmap ' . g:whitespaste_after_mapping . ' <Plug>WhitespasteVisual'
endif

let &cpo = s:keepcpo
unlet s:keepcpo
