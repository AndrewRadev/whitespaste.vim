" TODO (2012-10-16) What if it isn't linewise?
" TODO (2012-10-16) Check for availability of @+, @*
" TODO (2012-10-16) Problem with pasting on line 2
function! whitespaste#Paste()
  let target_area_start = prevnonblank(line('.') - 1)
  let target_area_end   = nextnonblank(line('.') + 1)
  let pasted_text_len   = len(split(@", "\n"))

  normal! p

  try
    let saved_cursor = getpos('.')

    " Clean up whitespace before pasted text
    let pasted_area_start = nextnonblank(target_area_start + 1)
    if target_area_start == 0 && pasted_area_start > 1
      " it was the start of the file and there's whitespace, clean
      call whitespaste#Compact(0, pasted_area_start, 0)
    elseif pasted_area_start - target_area_start > 1
      call whitespaste#Compact(target_area_start, pasted_area_start, 1)
    endif

    " Clean up whitespace after pasted text
    if target_area_end == 0 || (target_area_end + pasted_text_len) == line('$')
      " it's the last line, clean remaining whitespace
      let last_line = prevnonblank(line('$'))
      call whitespaste#Compact(last_line, line('$'), 0)
    else
      let new_target_area_end = target_area_end + pasted_text_len
      let pasted_area_end     = nextnonblank(new_target_area_end + 1)

      if new_target_area_end - pasted_area_end > 1
        call whitespaste#Compact(pasted_area_end, new_target_area_end, 1)
      endif
    endif
  finally
    call setpos('.', saved_cursor)
  endtry
endfunction

function! whitespaste#Compact(start, end, line_count)
  let [start, end, line_count] = [a:start, a:end, a:line_count]

  if end - start <= 1
    return
  endif

  if line_count == 0
    exe (start + 1).','.(end - 1).'delete _'
  elseif end - start > line_count
    let whitespace = repeat("\r", line_count)
    exe (start + 1).','.(end - 1).'s/\_s\+/'.whitespace
  endif
endfunction
