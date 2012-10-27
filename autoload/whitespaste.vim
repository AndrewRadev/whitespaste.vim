function! whitespaste#Paste(normal_command)
  if getregtype() == 'V'
    call whitespaste#PasteLinewise(a:normal_command)
  elseif getregtype() == 'v'
    call whitespaste#PasteCharwise(a:normal_command)
  endif
endfunction

" Note: clean up after the text, then before the text to avoid problems with
" changing line numbers lower in the buffer due to changes upper in the the
" buffer.
function! whitespaste#PasteLinewise(normal_command)
  exe 'normal! '.a:normal_command

  try
    let saved_cursor = getpos('.')

    let first_pasted_line = line("'[")
    let last_pasted_line  = line("']")

    " Clean up whitespace after pasted text
    let pasted_area_end = prevnonblank(last_pasted_line)
    let target_area_end = nextnonblank(last_pasted_line + 1)

    if target_area_end == 0
      let last_line = prevnonblank(line('$'))
      call whitespaste#Compress(last_line, line('$') + 1, 0)
    else
      call whitespaste#Compress(pasted_area_end, target_area_end, 1)
    endif

    " Clean up whitespace before pasted text
    let target_area_start = prevnonblank(first_pasted_line - 1)
    let pasted_area_start = nextnonblank(first_pasted_line)

    if target_area_start == 0
      call whitespaste#Compress(0, pasted_area_start, 0)
    else
      call whitespaste#Compress(target_area_start, pasted_area_start, 1)
    endif
  finally
    call setpos('.', saved_cursor)
  endtry
endfunction

function! whitespaste#PasteCharwise(normal_command)
  exe 'normal! '.a:normal_command
endfunction

function! whitespaste#Compress(start, end, line_count)
  let [start, end, line_count] = [a:start, a:end, a:line_count]
  let existing_line_count      = (end - start) - 1

  if existing_line_count < 0 || existing_line_count <= line_count
    return
  else
    call whitespaste#SetBlankLines(start, end, line_count)
  endif
endfunction

function! whitespaste#SetBlankLines(start, end, line_count)
  let [start, end, line_count] = [a:start, a:end, a:line_count]
  let existing_line_count      = (end - start) - 1

  if existing_line_count < 0
    return
  endif

  if existing_line_count > 0 && line_count == 0
    " delete lines
    silent exe (start + 1).','.(end - 1).'delete _'
    undojoin
  elseif existing_line_count > line_count
    " remove some lines
    let delta = existing_line_count - line_count
    silent exe (start + 1).','.(start + delta).'delete _'
    undojoin
  elseif existing_line_count < line_count
    " add some lines
    call append(start, repeat([''], line_count - existing_line_count))
    undojoin
  endif
endfunction
