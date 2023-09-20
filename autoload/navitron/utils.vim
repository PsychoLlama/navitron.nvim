" Given the absolute file path, find the corresponding directory index.
func! s:find_directoryIndex(directories, query) abort
  let l:index = 0

  while l:index < len(a:directories)
    let l:directory = a:directories[l:index]

    if l:directory.path is# a:query
      return l:index
    endif

    let l:index += 1
  endwhile

  return 0
endfunc

func! navitron#utils#trim_trailing_slash(path) abort
  if a:path !~# '\v./$'
    return a:path
  endif

  return substitute(a:path, '\v/$', '', '')
endfunc

func! navitron#utils#set_cursor_focus(path) abort
  let l:index_of_prev_dir = s:find_directoryIndex(b:navitron.directory, a:path)
  call cursor(l:index_of_prev_dir + 1, 1)
endfunc
