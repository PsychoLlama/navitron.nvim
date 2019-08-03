func! s:InitBuffer() abort
  setlocal bufhidden=hide
  setlocal buftype=nofile
  setlocal nobuflisted
  setlocal noswapfile
  setlocal wrap
endfunc

func! navitron#Initialize(path) abort
  if !isdirectory(a:path)
    throw 'Not a directory (navitron: ' . a:path . ')'
  endif

  call s:InitBuffer()
  let l:paths = navitron#search#(a:path)
  call map(l:paths, { idx, result -> result.name })
  call setline('.', l:paths)
endfunc
