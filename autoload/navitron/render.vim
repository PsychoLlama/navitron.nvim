highlight link navitronDirectoryTrailingSlash Constant
highlight link navitronDirectory Directory

let s:SyntaxTokens = {
      \   'Directory': 'navitronDirectory',
      \   'Slash': 'navitronDirectoryTrailingSlash',
      \ }

func! s:SetContents(contents) abort
  setlocal modifiable noreadonly

  call setline(1, a:contents)
  if line('$') > len(a:contents)
    execute 'silent ' . (len(a:contents) + 1) . ',$ delete'
  endif

  setlocal nomodifiable readonly
endfunc

func! s:GetName(index, result) abort
  return a:result.pretty_name
endfunc

func! s:Paint(paths) abort
  call clearmatches()
  let l:index = 0

  let l:matches = { 'directories': [], 'slashes': [] }

  while l:index < len(a:paths)
    let l:path = a:paths[l:index]
    let l:index += 1

    if l:path.type is# 'dir'
      let l:size = len(l:path.name)
      let l:matches.directories += [[l:index, 1, l:size]]
      let l:matches.slashes += [[l:index, len(l:path.pretty_name), 1]]
    endif
  endwhile

  call matchaddpos(s:SyntaxTokens.Directory, l:matches.directories)
  call matchaddpos(s:SyntaxTokens.Slash, l:matches.slashes)
endfunc

func! navitron#render#() abort
  let b:navitron.directory = navitron#search#({ 'path': b:navitron.path })
  let l:names = map(copy(b:navitron.directory), function('s:GetName'))
  call s:SetContents(l:names)
  call s:Paint(b:navitron.directory)
  call navitron#cursor#RestorePosition()
endfunc

func! s:GetNavitronTokens() abort
  let l:tokens = {}
  for l:token in values(s:SyntaxTokens)
    let l:tokens[l:token] = v:true
  endfor

  return l:tokens
endfunc

func! s:IsNavitronSyntaxToken(tokens, index, token) abort
  return has_key(a:tokens, a:token.group)
endfunc

func! navitron#render#Clear() abort
  let l:matches = getmatches()
  let l:tokens = s:GetNavitronTokens()
  call filter(l:matches, function('s:IsNavitronSyntaxToken', [l:tokens]))

  for l:highlight in l:matches
    call matchdelete(l:highlight.id)
  endfor
endfunc
