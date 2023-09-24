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

func! s:describe(index, result) abort
  return a:result.type . ':' . a:result.pretty_name
endfunc

func! navitron#render#() abort
  let b:navitron.directory = navitron#search#({ 'path': b:navitron.path })
  let l:contents = map(copy(b:navitron.directory), function('s:describe'))
  call s:set_contents(l:contents)
  lua require('navitron/cursor').restore_position()
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
