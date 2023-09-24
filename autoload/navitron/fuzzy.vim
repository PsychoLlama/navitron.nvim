let s:navitron = luaeval("require('navitron')")

func! s:edit_file(file) abort
  execute 'edit ' . fnameescape(a:file)
endfunc

func! s:explore_directory(dir) abort
  let l:absolute_path = fnamemodify(a:dir, ':p')
  call s:navitron.open(l:absolute_path)
endfunc

func! s:search(source, Callback)
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

func! s:get_downward_search_pattern(type) abort
  if executable('fd')
    return 'fd -t ' . a:type
  endif

  if executable('find')
    return 'find . -type ' . a:type
  endif

  throw "Can't find a search program (e.g. 'find')."
endfunc

func! navitron#fuzzy#find_file() abort
  let l:Callback = function('s:edit_file')
  let l:pattern = s:get_downward_search_pattern('f')

  call s:search(l:pattern, l:Callback)
endfunc

func! navitron#fuzzy#find_dir() abort
  let l:Callback = function('s:explore_directory')
  let l:pattern = s:get_downward_search_pattern('d')

  call s:search(l:pattern, l:Callback)
endfunc
