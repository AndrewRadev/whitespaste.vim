if exists("g:loaded_whitespaste") || &cp
  finish
endif

let g:loaded_whitespaste = '0.3.0' " version number
let s:keepcpo = &cpo
set cpo&vim

if !exists('g:whitespaste_pasta_enabled')
  let g:whitespaste_pasta_enabled = 1
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

autocmd FileType python let b:whitespaste_linewise_definitions = {
      \  'top': [
      \     { 'target_line': 0,                    'blank_lines': 0 },
      \     { 'pasted_text': '^\%(def\|class\)\>', 'blank_lines': 2 },
      \  ],
      \  'bottom': [
      \     { 'target_line': -1,                   'blank_lines': 0 },
      \     { 'target_text': '^\%(def\|class\)\>', 'blank_lines': 2 },
      \  ],
      \ }

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

autocmd FileType elixir let b:whitespaste_linewise_definitions = {
      \   'top': [
      \     { 'target_text': '^\s*\%(def\%(module\|p\)\=\|if\|cond\|case\)\>', 'blank_lines': 0 },
      \     { 'target_text': '^\s*end\>',                                      'blank_lines': 1 },
      \   ],
      \   'bottom': [
      \     { 'target_text': '^\s*end\>',                      'blank_lines': 0 },
      \     { 'target_text': '^\s*\%(def\|if\|cond\|case\)\>', 'blank_lines': 1 },
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

command! -count WhitespasteBefore call whitespaste#Paste(whitespaste#PasteBeforeCommand())
command! -count WhitespasteAfter  call whitespaste#Paste(whitespaste#PasteAfterCommand())
command! -range WhitespasteVisual call whitespaste#Paste(whitespaste#PasteVisualCommand())

nmap <Plug>WhitespasteBefore :WhitespasteBefore<cr>
nmap <Plug>WhitespasteAfter  :WhitespasteAfter<cr>
xmap <Plug>WhitespasteVisual :WhitespasteVisual<cr>

if g:whitespaste_pasta_enabled
  " Disable vim-pasta, if it happens to be loaded after whitespaste
  let g:pasta_paste_after_mapping = '<Plug>Disabled'
  let g:pasta_paste_before_mapping = '<Plug>Disabled'
endif

augroup Whitespaste
  autocmd!

  if g:whitespaste_before_mapping != ''
    autocmd FileType * call s:SetupBeforeMapping()
  endif

  if g:whitespaste_after_mapping != ''
    autocmd FileType * call s:SetupAfterMapping()
  endif
augroup END

function! s:SetupBeforeMapping()
  if !&modifiable | return | endif
  if exists('b:whitespaste_disable') | return | endif

  exe 'nmap <buffer> ' . g:whitespaste_before_mapping . ' <Plug>WhitespasteBefore'
  exe 'xmap <buffer> ' . g:whitespaste_before_mapping . ' <Plug>WhitespasteVisual'
endfunction

function! s:SetupAfterMapping()
  if !&modifiable | return | endif
  if exists('b:whitespaste_disable') | return | endif

  exe 'nmap <buffer>' . g:whitespaste_after_mapping . ' <Plug>WhitespasteAfter'
  exe 'xmap <buffer>' . g:whitespaste_after_mapping . ' <Plug>WhitespasteVisual'
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo
