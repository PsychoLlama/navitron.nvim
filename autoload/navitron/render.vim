func! s:SetContents(contents) abort
  setlocal modifiable

  call setline(1, a:contents)
  if line('$') > len(a:contents)
    execute 'silent ' . (len(a:contents) + 1) . ',$ delete'
  endif

  setlocal nomodifiable
endfunc

func! s:GetName(index, result) abort
  return a:result.name
endfunc

func! navitron#render#(paths) abort
  call map(a:paths, function('s:GetName'))
  call s:SetContents(a:paths)
endfunc
