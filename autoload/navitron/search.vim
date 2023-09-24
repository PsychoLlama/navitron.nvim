let s:IGNORED_LISTINGS = {
      \   '..': v:true,
      \   '.': v:true,
      \ }

let s:utils = luaeval("require('navitron/utils')")

func! s:read_directory(directory) abort
  let l:hidden = glob(a:directory . '/*', v:false, v:true, v:true)
  let l:visible = glob(a:directory . '/.*', v:false, v:true, v:true)

  return l:hidden + l:visible
endfunc

func! s:normalize_path(index, result) abort
  let a:result.path = s:utils.trim_trailing_slash(a:result.path)

  return a:result
endfunc

func! s:add_metadata(index, path) abort
  let l:ctx = { 'type': getftype(a:path), 'path': a:path }

  return l:ctx
endfunc

func! s:add_pretty_name(index, result) abort
  let a:result.name = fnamemodify(a:result.path, ':t')
  let a:result.pretty_name = a:result.name

  if a:result.type is# 'dir'
    let a:result.pretty_name .= '/'
  endif

  return a:result
endfunc

func! s:order(item1, item2) abort
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
func! s:should_show_entry(index, entry) abort
  let l:is_ignored = get(s:IGNORED_LISTINGS, a:entry.name, v:false)
  return !l:is_ignored
endfunc

func! navitron#search#(options) abort
  let l:path = a:options.path
  let l:paths = s:read_directory(l:path)

  call map(l:paths, function('s:add_metadata'))
  call map(l:paths, function('s:normalize_path'))
  call map(l:paths, function('s:add_pretty_name'))
  call sort(l:paths, function('s:order'))
  call filter(l:paths, function('s:should_show_entry'))
  call uniq(l:paths)

  return l:paths
endfunc
