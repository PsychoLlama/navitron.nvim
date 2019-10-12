func! s:EditFile(file) abort
  execute 'edit ' . fnameescape(a:file)
endfunc

func! s:ExploreDirectory(dir) abort
  let l:absolute_path = fnamemodify(a:dir, ':p')
  call navitron#Explore(l:absolute_path)
endfunc

func! s:Search(source, Callback)
  let l:options = { 'dir': b:navitron.path, 'source': a:source, 'sink': a:Callback }

  if exists('*skim#run')
    return skim#run(l:options)
  endif

  if exists('*fzf#run')
    return fzf#run(l:options)
  endif

  echohl Error
  echon 'Error:'
  echohl Clear
  echon ' No installed fuzzy finder (fzf/skim).'
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
  let l:Callback = function('s:ExploreDirectory')
  let l:pattern = s:GetDownwardSearchPattern('d')

  call s:Search(l:pattern, l:Callback)
endfunc
