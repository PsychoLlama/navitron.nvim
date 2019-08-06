" Given the absolute file path, find the corresponding index in the directory
" listing.
func! s:FindDirectoryIndex(directories, query) abort
  let l:index = 0

  while l:index < len(a:directories)
    let l:directory = a:directories[l:index]

    if l:directory.path is# a:query
      return l:index
    endif

    let l:index += 1
  endwhile

  return 0
endfunc

func! navitron#navigation#Up(count) abort
  let l:prev_dir_path = b:navitron.path
  let l:target_dir = b:navitron.path
  let l:dir_count = a:count

  while l:dir_count > 0
    let l:target_dir = fnamemodify(l:target_dir, ':h')
    let l:dir_count -= 1
  endwhile

  call navitron#Explore(l:target_dir)
  let l:index_of_prev_dir = s:FindDirectoryIndex(b:navitron.directory, l:prev_dir_path)
  call cursor(l:index_of_prev_dir + 1, 1)
endfunc

func! navitron#navigation#ExploreListingUnderCursor() abort
  let l:selected_line = line('.') - 1
  let l:directory = b:navitron.directory[l:selected_line]

  if isdirectory(l:directory.path)
    call navitron#Explore(l:directory.path)
  else
    execute 'edit ' . fnameescape(l:directory.path)
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
endfunc
