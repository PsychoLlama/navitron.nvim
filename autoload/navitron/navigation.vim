func! navitron#navigation#Up(count) abort
  let l:dir_count = a:count

  while l:dir_count > 0
    let b:navitron.path = fnamemodify(b:navitron.path, ':h')
    let l:dir_count -= 1
  endwhile

  call navitron#Explore(b:navitron.path)
endfunc

func! navitron#navigation#InitMappings() abort
  if exists('b:navitron.has_defined_mappings')
    return
  endif

  let b:navitron.has_defined_mappings = v:true

  nnoremap <silent><buffer>h :call navitron#navigation#Up(1)<cr>
  nnoremap <silent><buffer>- :call navitron#navigation#Up(1)<cr>
endfunc
