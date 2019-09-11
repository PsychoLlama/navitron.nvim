func! s:ClearHighlights() abort
  if &filetype ==# 'navitron'
    return
  endif

  call navitron#render#Clear()
endfunc

augroup navitron_syntax
  autocmd!
  autocmd BufEnter * :call s:ClearHighlights()
augroup END
