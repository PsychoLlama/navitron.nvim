func! s:detect_directories() abort
  let l:dir_path = expand('%:p')

  if isdirectory(l:dir_path)
    call navitron#explore(l:dir_path)
  endif
endfunc

autocmd BufEnter * call s:detect_directories()
