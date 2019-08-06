func! navitron#utils#TrimTrailingSlash(path) abort
  if a:path !~# '\v./$'
    return a:path
  endif

  return substitute(a:path, '\v/$', '', '')
endfunc
