func! s:DetectDirectories() abort
  let l:dir_path = expand('%:p')

  if isdirectory(l:dir_path)
    call navitron#Explore(l:dir_path)
  endif
endfunc

autocmd BufEnter * call s:DetectDirectories()
