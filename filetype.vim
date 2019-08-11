" Disable built-in netrw file navigation
let g:loaded_netrwFileHandlers = v:true
let g:loaded_netrwSettings = v:true
let g:loaded_netrwSettings = v:true
let g:loaded_netrwPlugin = v:true
let g:loaded_netrw = v:true

if exists('s:did_load_filetype')
  finish
endif

let s:did_load_filetype = v:true

if isdirectory(expand('%:p')) && &filetype !=# 'navitron'
  setlocal filetype=navitron
endif
