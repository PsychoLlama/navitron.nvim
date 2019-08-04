func! s:InitBuffer() abort
  setlocal bufhidden=hide
  setlocal buftype=nofile
  setlocal nomodifiable
  setlocal nobuflisted
  setlocal noswapfile
  setlocal nonumber
  setlocal wrap
endfunc

func! navitron#Initialize(path) abort
  if !isdirectory(a:path)
    throw 'Not a directory (navitron: ' . a:path . ')'
  endif

  call s:InitBuffer()
  let l:paths = navitron#search#({ 'path': a:path })
  call navitron#render#(l:paths)
endfunc
