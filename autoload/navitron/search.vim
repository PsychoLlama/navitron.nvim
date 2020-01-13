let s:IGNORED_LISTINGS = {
      \   '..': v:true,
      \   '.': v:true,
      \ }

func! s:ReadDirectory(directory) abort
  let l:hidden = glob(a:directory . '/*', v:false, v:true, v:true)
  let l:visible = glob(a:directory . '/.*', v:false, v:true, v:true)

  return l:hidden + l:visible
endfunc

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
  let a:result.pretty_name = a:result.name

  if a:result.type is# 'dir'
    let a:result.pretty_name .= '/'
  endif

  return a:result
endfunc

func! s:Order(item1, item2) abort
  let l:ordering = ['dir', 'file', 'link', 'socket', 'bdev', 'cdev', 'fifo', 'other']

  if a:item1.type isnot# a:item2.type
    return index(l:ordering, a:item1.type) - index(l:ordering, a:item2.type)
  endif

  if a:item1.pretty_name < a:item2.pretty_name
    return -1
  endif

  return 1
endfunc

" TODO: Make this configurable by the end user.
func! s:ShouldShowEntry(index, entry) abort
  let l:is_ignored = get(s:IGNORED_LISTINGS, a:entry.name, v:false)
  return !l:is_ignored
endfunc

func! navitron#search#(options) abort
  let l:path = a:options.path
  let l:paths = s:ReadDirectory(l:path)

  call map(l:paths, function('s:AddMetadata'))
  call map(l:paths, function('s:NormalizePath'))
  call map(l:paths, function('s:AddPrettyName'))
  call sort(l:paths, function('s:Order'))
  call filter(l:paths, function('s:ShouldShowEntry'))
  call uniq(l:paths)

  return l:paths
endfunc
