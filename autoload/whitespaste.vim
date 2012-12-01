function! whitespaste#Paste(normal_command)
  if getregtype() == 'V'
    call whitespaste#PasteLinewise(a:normal_command)
  elseif getregtype() == 'v'
    call whitespaste#PasteCharwise(a:normal_command)
  else
    call whitespaste#PasteBlockwise(a:normal_command)
  endif
endfunction

" Note: clean up after the text, then before the text to avoid problems with
" changing line numbers lower in the buffer due to changes upper in the the
" buffer.
function! whitespaste#PasteLinewise(normal_command)
  call s:Paste(a:normal_command)

  let first_pasted_line = line("'[")
  let last_pasted_line  = line("']")
  let target_area_start = prevnonblank(first_pasted_line - 1)
  let pasted_area_start = nextnonblank(first_pasted_line)
  let pasted_area_end   = prevnonblank(last_pasted_line)
  let target_area_end   = nextnonblank(last_pasted_line + 1)

  if target_area_end == 0
    let target_area_end = line('$') + 1
  endif

  let top = {
        \   'target_line': target_area_start,
        \   'target_text': getline(target_area_start),
        \   'pasted_line': pasted_area_start,
        \   'pasted_text': getline(pasted_area_start)
        \ }

  let bottom = {
        \   'target_line': target_area_end,
        \   'target_text': getline(target_area_end),
        \   'pasted_line': pasted_area_end,
        \   'pasted_text': getline(pasted_area_end)
        \ }

  let definitions = {'top': [], 'bottom': []}
  if exists('b:whitespaste_linewise_definitions')
    call extend(definitions.top, b:whitespaste_linewise_definitions.top)
    call extend(definitions.bottom, b:whitespaste_linewise_definitions.bottom)
  endif
  call extend(definitions.top, g:whitespaste_linewise_definitions.top)
  call extend(definitions.bottom, g:whitespaste_linewise_definitions.bottom)

  try
    let saved_cursor = getpos('.')

    for definition in get(definitions, 'bottom', {})
      let [success, delta] = s:HandleDefinition(bottom, definition, pasted_area_end, target_area_end)
      if success
        let target_area_end += delta
        break
      endif
    endfor

    for definition in get(definitions, 'top', {})
      let [success, delta] = s:HandleDefinition(top, definition, target_area_start, pasted_area_start)
      if success
        let pasted_area_start += delta
        let pasted_area_end   += delta
        let target_area_end   += delta
        break
      endif
    endfor

    " Restore [ and ] marks
    let start_pos    = getpos("'[")
    let start_pos[1] = target_area_start + 1
    call setpos("'[", start_pos)

    let end_pos    = getpos("']")
    let end_pos[1] = target_area_end - 1
    call setpos("']", end_pos)
  finally
    call setpos('.', saved_cursor)
  endtry
endfunction

function! s:HandleDefinition(actual, definition, start, end)
  let [actual, definition, start, end] = [a:actual, a:definition, a:start, a:end]

  " Handle "last line" problems
  if has_key(definition, 'target_line') && definition.target_line == -1
    let definition.target_line = line('$') + 1
  endif

  if has_key(definition, 'target_line') && actual.target_line != definition.target_line
    return [0, 0]
  endif
  if has_key(definition, 'target_text') && actual.target_text !~ definition.target_text
    return [0, 0]
  endif
  if has_key(definition, 'pasted_line') && actual.pasted_line != definition.pasted_line
    return [0, 0]
  endif
  if has_key(definition, 'pasted_text') && actual.pasted_text !~ definition.pasted_text
    return [0, 0]
  endif

  if has_key(definition, 'compress_blank_lines')
    let line_change = whitespaste#CompressBlankLines(start, end, definition.compress_blank_lines)
  elseif has_key(definition, 'blank_lines')
    let line_change = whitespaste#SetBlankLines(start, end, definition.blank_lines)
  else
    throw "No 'blank_lines' or 'compress_blank_lines' key in definition"
  endif

  return [1, line_change]
endfunction

" For now, just works like a normal "paste"
function! whitespaste#PasteCharwise(normal_command)
  call s:Paste(a:normal_command)
endfunction

" For now, just works like a normal "paste"
function! whitespaste#PasteBlockwise(normal_command)
  call s:Paste(a:normal_command)
endfunction

function! whitespaste#CompressBlankLines(start, end, line_count)
  let [start, end, line_count] = [a:start, a:end, a:line_count]
  let existing_line_count      = (end - start) - 1

  if existing_line_count < 0 || existing_line_count <= line_count
    return 0
  else
    return whitespaste#SetBlankLines(start, end, line_count)
  endif
endfunction

function! whitespaste#SetBlankLines(start, end, line_count)
  let [start, end, line_count] = [a:start, a:end, a:line_count]
  let existing_line_count      = (end - start) - 1

  if existing_line_count < 0
    return 0
  endif

  if existing_line_count > 0 && line_count == 0
    " delete lines
    silent exe (start + 1).','.(end - 1).'delete _'
    undojoin
    return -existing_line_count
  elseif existing_line_count > line_count
    " remove some lines
    let delta = existing_line_count - line_count
    silent exe (start + 1).','.(start + delta).'delete _'
    undojoin
    return -delta
  elseif existing_line_count < line_count
    " add some lines
    let delta = line_count - existing_line_count
    call append(start, repeat([''], delta))
    undojoin
    return delta
  endif
endfunction

function! s:Paste(command)
  exe a:command
endfunction
