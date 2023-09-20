" Remember the cursor position in case the directory is opened again.
func! navitron#cursor#save_position() abort
  let g:navitron.cursor_positions[b:navitron.path] = line('.')
endfunc

func! navitron#cursor#restore_position() abort
  let l:cursor_position = get(g:navitron.cursor_positions, b:navitron.path, v:null)
  if l:cursor_position isnot# v:null
    call cursor(l:cursor_position, 1)
  endif
endfunc
