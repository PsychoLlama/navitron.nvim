func! s:EditFile(file) abort
  execute 'edit ' . fnameescape(a:file)
endfunc

func! s:Search(source, Callback) abort
  call skim#run({ 'source': a:source, 'sink': a:Callback })
endfunc

func! s:GetDownwardSearchPattern(type) abort
  if executable('fd')
    return 'fd -t ' . a:type
  endif

  if executable('find')
    return 'find . -type ' . a:type
  endif

  throw "Can't find a search program (e.g. 'find')."
endfunc

func! navitron#fuzzy#FindFile() abort
  let l:Callback = function('s:EditFile')
  let l:pattern = s:GetDownwardSearchPattern('f')

  call s:Search(l:pattern, l:Callback)
endfunc

func! navitron#fuzzy#FindDir() abort
  let l:Callback = function('navitron#Explore')
  let l:pattern = s:GetDownwardSearchPattern('d')

  call s:Search(l:pattern, l:Callback)
endfunc
