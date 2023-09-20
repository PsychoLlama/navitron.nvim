func! s:clear_highlights() abort
  if isdirectory(expand('%:p'))
    setfiletype navitron
    call navitron#explore(expand('%:p'))
  else
    call navitron#render#clear()
  endif
endfunc

augroup navitron_syntax
  autocmd!
  autocmd BufEnter * :call s:clear_highlights()
augroup END
