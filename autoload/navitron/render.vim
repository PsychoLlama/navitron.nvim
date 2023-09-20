highlight link navitronDirectoryTrailingSlash Constant
highlight link navitronDirectory Directory

let s:syntax_tokens = {
      \   'Directory': 'navitronDirectory',
      \   'Slash': 'navitronDirectoryTrailingSlash',
      \ }

func! s:set_contents(contents) abort
  setlocal modifiable noreadonly

  call setline(1, a:contents)
  if line('$') > len(a:contents)
    execute 'silent ' . (len(a:contents) + 1) . ',$ delete'
  endif

  setlocal nomodifiable readonly
endfunc

func! s:get_name(index, result) abort
  return a:result.pretty_name
endfunc

func! s:paint(paths) abort
  call clearmatches()
  let l:index = 0

  while l:index < len(a:paths)
    let l:path = a:paths[l:index]
    let l:index += 1

    if l:path.type is# 'dir'
      let l:size = len(l:path.name)
      call matchaddpos(s:syntax_tokens.Directory, [[l:index, 1, l:size]])
      call matchaddpos(s:syntax_tokens.Slash, [[l:index, len(l:path.pretty_name), 1]])
    endif
  endwhile
endfunc

func! navitron#render#() abort
  let b:navitron.directory = navitron#search#({ 'path': b:navitron.path })
  let l:names = map(copy(b:navitron.directory), function('s:get_name'))
  call s:set_contents(l:names)
  call s:paint(b:navitron.directory)
  call navitron#cursor#restore_position()
endfunc

func! s:get_navitron_tokens() abort
  let l:tokens = {}
  for l:token in values(s:syntax_tokens)
    let l:tokens[l:token] = v:true
  endfor

  return l:tokens
endfunc

func! s:is_navitron_syntax_token(tokens, index, token) abort
  return has_key(a:tokens, a:token.group)
endfunc

func! navitron#render#clear() abort
  let l:matches = getmatches()
  let l:tokens = s:get_navitron_tokens()
  call filter(l:matches, function('s:is_navitron_syntax_token', [l:tokens]))

  for l:highlight in l:matches
    call matchdelete(l:highlight.id)
  endfor
endfunc
