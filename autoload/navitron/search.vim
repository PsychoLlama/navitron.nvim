func! s:AddMetadata(index, path) abort
  let l:ctx = { 'type': getftype(a:path), 'path': a:path }

  return l:ctx
endfunc

func! s:AddPrettyName(context, index, result) abort
  let a:result.name = substitute(a:result.path, a:context, '', '')

  return a:result
endfunc

func! navitron#search#(path) abort
  let l:paths = glob(a:path . '{.,}*', v:false, v:true, v:true)
  call map(l:paths, function('s:AddMetadata', []))
  call map(l:paths, function('s:AddPrettyName', [a:path]))

  return l:paths
endfunc
