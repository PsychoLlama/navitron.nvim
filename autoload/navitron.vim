func! s:InitBuffer(path) abort
  setlocal bufhidden=hide
  setlocal buftype=nofile
  setlocal signcolumn=no
  setlocal nomodifiable
  setlocal nobuflisted
  setlocal noswapfile
  setlocal nonumber
  setlocal wrap

  let b:navitron = {}
  let b:navitron.previous_cursor_positions_by_path = {}
  let b:navitron.path = a:path

  call navitron#navigation#InitMappings()
endfunc

" Remember the cursor position in case the directory is opened again.
func! s:SaveCursorPosition() abort
  let l:cursor_positions = b:navitron.previous_cursor_positions_by_path
  let l:cursor_positions[b:navitron.path] = line('.')
endfunc

func! s:RestoreCursorPosition() abort
  let l:cursor_positions = b:navitron.previous_cursor_positions_by_path
  let l:cursor_position = get(l:cursor_positions, b:navitron.path, 1)
  call cursor(l:cursor_position, 1)
endfunc

func! navitron#Explore(path) abort
  let l:directory = navitron#utils#TrimTrailingSlash(a:path)

  if !isdirectory(l:directory)
    throw 'Not a directory (navitron: ' . l:directory . ')'
  endif

  if exists('b:navitron')
    call s:SaveCursorPosition()
  else
    call s:InitBuffer(l:directory)
  endif

  let b:navitron.path = l:directory
  let b:navitron.directory = navitron#search#({ 'path': l:directory })
  call navitron#render#(b:navitron.directory)
  call s:RestoreCursorPosition()
endfunc
