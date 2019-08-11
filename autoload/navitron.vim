if !exists('g:navitron')
  let g:navitron = {}
  let g:navitron.cursor_positions = {}
endif

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

func! navitron#Explore(path) abort
  let l:directory = navitron#utils#TrimTrailingSlash(a:path)

  if !isdirectory(l:directory)
    throw 'Not a directory (navitron: ' . l:directory . ')'
  endif

  if !exists('b:navitron')
    call s:InitBuffer(l:directory)
  endif

  let b:navitron.path = l:directory
  let b:navitron.directory = navitron#search#({ 'path': l:directory })
  call navitron#render#()
endfunc
