function! whitespaste#Paste(normal_command)
  if getregtype() == 'V'
    call s:PasteLinewise(a:normal_command)
  elseif getregtype() == 'v'
    call s:PasteCharwise(a:normal_command)
  endif
endfunction

function! s:PasteLinewise(normal_command)
  exe 'normal! '.a:normal_command

  try
    let saved_cursor = getpos('.')

    let first_pasted_line = line("'[")
    let last_pasted_line  = line("']")

    " Clean up whitespace before pasted text
    let target_area_start = prevnonblank(first_pasted_line - 1)
    let pasted_area_start = nextnonblank(first_pasted_line)

    if target_area_start == 0
      call whitespaste#Compact(0, pasted_area_start, 0)
    else
      call whitespaste#Compact(target_area_start, pasted_area_start, 1)
    endif

    " Clean up whitespace after pasted text
    let pasted_area_end = prevnonblank(last_pasted_line)
    let target_area_end = nextnonblank(last_pasted_line + 1)

    if target_area_end == 0
      let last_line = prevnonblank(line('$'))
      call whitespaste#Compact(last_line, line('$') + 1, 0)
    else
      call whitespaste#Compact(pasted_area_end, target_area_end, 1)
    endif
  finally
    call setpos('.', saved_cursor)
  endtry
endfunction

function! s:PasteCharwise(normal_command)
  exe 'normal! '.a:normal_command
endfunction

function! whitespaste#Compact(start, end, line_count)
  let [start, end, line_count] = [a:start, a:end, a:line_count]

  if end - start <= 1
    return
  endif

  if line_count == 0
    silent exe (start + 1).','.(end - 1).'delete _'
    undojoin
  elseif end - start > line_count
    let whitespace = repeat("\r", line_count)
    silent exe (start + 1).','.(end - 1).'s/\_s\+\n/'.whitespace.'/e'
    undojoin
  endif
endfunction
