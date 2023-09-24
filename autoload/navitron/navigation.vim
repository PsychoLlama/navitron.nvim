let s:utils = luaeval("require('navitron/utils')")

func! s:get_file_or_directory_under_cursor() abort
  let l:index = line('.') - 1
  return get(b:navitron.directory, l:index, v:null)
endfunc

func! navitron#navigation#up(count) abort
  lua require('navitron/cursor').save_position()

  let l:prev_dir_path = b:navitron.path
  let l:target_dir = b:navitron.path
  let l:dir_count = a:count

  while l:dir_count > 0
    let l:target_dir = fnamemodify(l:target_dir, ':h')
    let l:dir_count -= 1
  endwhile

  call navitron#explore(l:target_dir)
  call s:utils.focus_cursor_over_path(l:prev_dir_path)
endfunc

func! navitron#navigation#explore_listing_under_cursor() abort
  let l:directory = s:get_file_or_directory_under_cursor()
  if l:directory is# v:null
    return
  endif

  lua require('navitron/cursor').save_position()
  if isdirectory(l:directory.path)
    call navitron#explore(l:directory.path)
  else
    execute 'edit ' . fnameescape(l:directory.path)
  endif
endfunc

func! navitron#navigation#create_file() abort
  let l:file = input('New file: ')
  let l:absolute_path = b:navitron.path . '/' . l:file

  if l:file is# ''
    return v:false
  endif

  " Create the file, rerender, then set focus on the new file.
  call writefile([], l:absolute_path)
  call navitron#render#()
  call s:utils.focus_cursor_over_path(l:absolute_path)

  return v:true
endfunc

func! navitron#navigation#create_and_edit_file() abort
  if navitron#navigation#create_file()
    call navitron#navigation#explore_listing_under_cursor()
  endif
endfunc

func! navitron#navigation#create_directory() abort
  let l:directory = input('New directory: ')
  let l:absolute_path = b:navitron.path . '/' . l:directory

  if !strlen(l:directory)
    return v:false
  endif

  call mkdir(l:absolute_path)
  call navitron#render#()
  call s:utils.focus_cursor_over_path(l:absolute_path)

  return v:true
endfunc

func! navitron#navigation#create_and_explore_directory() abort
  if navitron#navigation#create_directory()
    call navitron#navigation#explore_listing_under_cursor()
  endif
endfunc

func! navitron#navigation#delete_file_or_directory() abort
  let l:entry = s:get_file_or_directory_under_cursor()

  if l:entry is# v:null
    return
  endif

  if confirm('Delete ' . l:entry.name . '?', "&Yes\n&No") != 1
    return
  endif

  " This seems perfectly safe...
  call delete(l:entry.path, 'rf')
  lua require('navitron/cursor').save_position()
  call navitron#render#()
endfunc

func! s:move_entry(entry, path) abort
  let l:new_path = substitute(a:path, '\v/$', '', '')
  call mkdir(fnamemodify(l:new_path, ':h'), 'p')

  let l:success = rename(a:entry.path, a:path)
  let a:entry.path = a:path

  call navitron#render#()
  call s:utils.focus_cursor_over_path(a:path)
endfunc

func! navitron#navigation#move_file_or_directory_relative() abort
  let l:entry = s:get_file_or_directory_under_cursor()

  if l:entry is# v:null
    return
  endif

  let l:target_name = input({ 'prompt': 'Rename: ' })
  let l:new_path = fnamemodify(l:entry.path, ':h') . '/' . l:target_name

  if len(l:target_name)
    call s:move_entry(l:entry, l:new_path)
  endif
endfunc

func! navitron#navigation#move_file_or_directory_absolute() abort
  let l:entry = s:get_file_or_directory_under_cursor()

  if l:entry is# v:null
    return
  endif

  let l:new_path = input({ 'prompt': 'Move: ', 'default': l:entry.path, 'completion': 'file' })

  if len(l:new_path)
    call s:move_entry(l:entry, l:new_path)
  endif
endfunc

func! navitron#navigation#init_mappings() abort
  if exists('b:navitron.has_defined_mappings')
    return
  endif

  let b:navitron.has_defined_mappings = v:true

  nnoremap <silent><buffer>- :call navitron#navigation#up(1)<cr>
  nnoremap <silent><buffer>h :call navitron#navigation#up(1)<cr>
  nnoremap <silent><buffer>l :call navitron#navigation#explore_listing_under_cursor()<cr>
  nnoremap <silent><buffer><cr> :call navitron#navigation#explore_listing_under_cursor()<cr>

  nnoremap <silent><buffer>i :call navitron#navigation#create_file()<cr>
  nnoremap <silent><buffer>% :call navitron#navigation#create_file()<cr>

  nnoremap <silent><buffer>a :call navitron#navigation#create_directory()<cr>
  nnoremap <silent><buffer>dd :call navitron#navigation#delete_file_or_directory()<cr>

  nnoremap <silent><buffer>I :call navitron#navigation#create_and_edit_file()<cr>
  nnoremap <silent><buffer>A :call navitron#navigation#create_and_explore_directory()<cr>

  nnoremap <silent><buffer>r :call navitron#navigation#move_file_or_directory_relative()<cr>
  nnoremap <silent><buffer>R :call navitron#navigation#move_file_or_directory_absolute()<cr>

  nnoremap <silent><buffer>f :call navitron#fuzzy#find_file()<cr>
  nnoremap <silent><buffer>t :call navitron#fuzzy#find_dir()<cr>
endfunc
