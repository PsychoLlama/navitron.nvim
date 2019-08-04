func! s:SetContents(contents) abort
  setlocal modifiable
  call setline('.', a:contents)
  setlocal nomodifiable
endfunc

func! navitron#render#(paths) abort
  call map(a:paths, { idx, result -> result.name })
  call s:SetContents(a:paths)
endfunc
