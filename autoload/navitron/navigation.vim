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
  let l:dir_count = a:count

  while l:dir_count > 0
    let b:navitron.path = fnamemodify(b:navitron.path, ':h')
    let l:dir_count -= 1
  endwhile

  call navitron#Explore(b:navitron.path)
  let l:line_of_prev_dir = s:FindDirectoryIndex(b:navitron.directory, l:prev_dir_path) + 1
  call cursor(l:line_of_prev_dir, 1)
endfunc

func! navitron#navigation#InitMappings() abort
  if exists('b:navitron.has_defined_mappings')
    return
  endif

  let b:navitron.has_defined_mappings = v:true

  nnoremap <silent><buffer>h :call navitron#navigation#Up(1)<cr>
  nnoremap <silent><buffer>- :call navitron#navigation#Up(1)<cr>
endfunc
