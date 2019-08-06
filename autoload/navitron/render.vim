func! s:SetContents(contents) abort
  setlocal modifiable

  let l:view = winsaveview()
  call setline(1, a:contents)
  if line('$') > len(a:contents)
    execute 'silent ' . (len(a:contents) + 1) . ',$ delete'
  endif
  call winrestview(l:view)

  setlocal nomodifiable
endfunc

func! navitron#render#(paths) abort
  call map(a:paths, { idx, result -> result.name })
  call s:SetContents(a:paths)
endfunc
