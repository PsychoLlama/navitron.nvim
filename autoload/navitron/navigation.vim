func! s:GetFileOrDirectoryUnderCursor() abort
  let l:index = line('.') - 1
  return get(b:navitron.directory, l:index, v:null)
endfunc

func! navitron#navigation#Up(count) abort
  call navitron#cursor#SavePosition()

  let l:prev_dir_path = b:navitron.path
  let l:target_dir = b:navitron.path
  let l:dir_count = a:count

  while l:dir_count > 0
    let l:target_dir = fnamemodify(l:target_dir, ':h')
    let l:dir_count -= 1
  endwhile

  call navitron#Explore(l:target_dir)
  call navitron#utils#SetCursorFocus(l:prev_dir_path)
endfunc

func! navitron#navigation#ExploreListingUnderCursor() abort
  let l:directory = s:GetFileOrDirectoryUnderCursor()
  if l:directory is# v:null
    return
  endif

  call navitron#cursor#SavePosition()
  if isdirectory(l:directory.path)
    call navitron#Explore(l:directory.path)
  else
    execute 'edit ' . fnameescape(l:directory.path)
  endif
endfunc

func! navitron#navigation#CreateFile() abort
  let l:file = input('New file: ')
  let l:absolute_path = b:navitron.path . '/' . l:file

  if l:file is# ''
    return
  endif

  " Create the file, rerender, then set focus on the new file.
  call writefile([], l:absolute_path)
  call navitron#render#()
  call navitron#utils#SetCursorFocus(l:absolute_path)
endfunc

func! navitron#navigation#CreateDirectory() abort
  let l:directory = input('New directory: ')
  let l:absolute_path = b:navitron.path . '/' . l:directory

  if !strlen(l:directory)
    return
  endif

  call mkdir(l:absolute_path)
  call navitron#render#()
  call navitron#utils#SetCursorFocus(l:absolute_path)
endfunc

func! navitron#navigation#DeleteFileOrDirectory() abort
  let l:entry = s:GetFileOrDirectoryUnderCursor()

  if l:entry is# v:null
    return
  endif

  if confirm('Delete ' . l:entry.name . '?', "&Yes\n&No") != 1
    return
  endif

  " This seems perfectly safe...
  call delete(l:entry.path, 'rf')
  call navitron#cursor#SavePosition()
  call navitron#render#()
endfunc

func! s:MoveEntry(entry, path) abort
  let l:new_path = substitute(a:path, '\v/$', '', '')
  call mkdir(fnamemodify(l:new_path, ':h'), 'p')

  let l:success = rename(a:entry.path, a:path)
  let a:entry.path = a:path

  call navitron#render#()
  call navitron#utils#SetCursorFocus(a:path)
endfunc

func! navitron#navigation#MoveFileOrDirectoryRelative() abort
  let l:entry = s:GetFileOrDirectoryUnderCursor()

  if l:entry is# v:null
    return
  endif

  let l:target_name = input({ 'prompt': 'Rename: ' })
  let l:new_path = fnamemodify(l:entry.path, ':h') . '/' . l:target_name

  if len(l:target_name)
    call s:MoveEntry(l:entry, l:new_path)
  endif
endfunc

func! navitron#navigation#MoveFileOrDirectoryAbsolute() abort
  let l:entry = s:GetFileOrDirectoryUnderCursor()

  if l:entry is# v:null
    return
  endif

  let l:new_path = input({ 'prompt': 'Move: ', 'default': l:entry.path, 'completion': 'file' })

  if len(l:new_path)
    call s:MoveEntry(l:entry, l:new_path)
  endif
endfunc

func! navitron#navigation#InitMappings() abort
  if exists('b:navitron.has_defined_mappings')
    return
  endif

  let b:navitron.has_defined_mappings = v:true

  nnoremap <silent><buffer>- :call navitron#navigation#Up(1)<cr>
  nnoremap <silent><buffer>h :call navitron#navigation#Up(1)<cr>
  nnoremap <silent><buffer>l :call navitron#navigation#ExploreListingUnderCursor()<cr>
  nnoremap <silent><buffer><cr> :call navitron#navigation#ExploreListingUnderCursor()<cr>

  nnoremap <silent><buffer>i :call navitron#navigation#CreateFile()<cr>
  nnoremap <silent><buffer>% :call navitron#navigation#CreateFile()<cr>

  nnoremap <silent><buffer>a :call navitron#navigation#CreateDirectory()<cr>
  nnoremap <silent><buffer>dd :call navitron#navigation#DeleteFileOrDirectory()<cr>

  nnoremap <silent><buffer>r :call navitron#navigation#MoveFileOrDirectoryRelative()<cr>
  nnoremap <silent><buffer>R :call navitron#navigation#MoveFileOrDirectoryAbsolute()<cr>
endfunc
