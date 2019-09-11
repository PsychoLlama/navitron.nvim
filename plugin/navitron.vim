func! s:ClearHighlights() abort
  if isdirectory(expand('%:p'))
    setfiletype navitron
    call navitron#Explore(expand('%:p'))
  else
    call navitron#render#Clear()
  endif
endfunc

augroup navitron_syntax
  autocmd!
  autocmd BufEnter * :call s:ClearHighlights()
augroup END
