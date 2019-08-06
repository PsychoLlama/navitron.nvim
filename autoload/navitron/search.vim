func! s:NormalizePath(index, result) abort
  let a:result.path = navitron#utils#TrimTrailingSlash(a:result.path)

  return a:result
endfunc

func! s:AddMetadata(index, path) abort
  let l:ctx = { 'type': getftype(a:path), 'path': a:path }

  return l:ctx
endfunc

func! s:AddPrettyName(index, result) abort
  let a:result.name = fnamemodify(a:result.path, ':t')

  if a:result.type is# 'dir'
    let a:result.name .= '/'
  endif

  return a:result
endfunc

func! s:Order(item1, item2) abort
  let l:ordering = ['dir', 'file', 'link', 'socket', 'bdev', 'cdev', 'fifo', 'other']

  if a:item1.type isnot# a:item2.type
    return index(l:ordering, a:item1.type) - index(l:ordering, a:item2.type)
  endif

  if a:item1.name < a:item2.name
    return -1
  endif

  return 1
endfunc

func! navitron#search#(options) abort
  let l:path = a:options.path
  let l:paths = glob(l:path . '/{.,}*', v:false, v:true, v:true)

  call map(l:paths, function('s:AddMetadata'))
  call map(l:paths, function('s:NormalizePath'))
  call map(l:paths, function('s:AddPrettyName'))
  call sort(l:paths, function('s:Order'))

  return l:paths
endfunc
