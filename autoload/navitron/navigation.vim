func! navitron#navigation#Up(count) abort
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
  let l:selected_line = line('.') - 1
  let l:directory = get(b:navitron.directory, l:selected_line, v:null)

  if l:directory is# v:null
    return
  endif

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
  call navitron#Explore(b:navitron.path)
  call navitron#utils#SetCursorFocus(l:absolute_path)
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
endfunc
