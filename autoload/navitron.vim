func! s:InitBuffer(path) abort
  setlocal bufhidden=hide
  setlocal buftype=nofile
  setlocal nomodifiable
  setlocal nobuflisted
  setlocal noswapfile
  setlocal nonumber
  setlocal wrap

  let b:navitron = { 'path': a:path }
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

  let b:navitron.directory = navitron#search#({ 'path': l:directory })
  call navitron#render#(deepcopy(b:navitron.directory))
endfunc
