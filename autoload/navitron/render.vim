highlight link navitronDirectoryTrailingSlash Constant
highlight link navitronDirectory Directory

func! s:SetContents(contents) abort
  setlocal modifiable

  call setline(1, a:contents)
  if line('$') > len(a:contents)
    execute 'silent ' . (len(a:contents) + 1) . ',$ delete'
  endif

  setlocal nomodifiable
endfunc

func! s:GetName(index, result) abort
  return a:result.pretty_name
endfunc

func! s:Paint(paths) abort
  call clearmatches()
  let l:index = 0

  while l:index < len(a:paths)
    let l:path = a:paths[l:index]
    let l:index += 1

    if l:path.type is# 'dir'
      let l:size = len(l:path.name)
      call matchaddpos('navitronDirectory', [[l:index, 1, l:size]])
      call matchaddpos('navitronDirectoryTrailingSlash', [[l:index, len(l:path.pretty_name), 1]])
    endif
  endwhile
endfunc

func! navitron#render#() abort
  let b:navitron.directory = navitron#search#({ 'path': b:navitron.path })
  let l:names = map(copy(b:navitron.directory), function('s:GetName'))
  call s:SetContents(l:names)
  call s:Paint(b:navitron.directory)
  call navitron#cursor#RestorePosition()
endfunc
