# navitron.vim

A better file browser for vim.

:construction: Work in Progress :construction:

## Usage

Most vim implementations ship with netrw. You'll need to disable it before navitron can take over. Put this in your vimrc:

```viml
let g:loaded_netrwPlugin = v:true
```

Once you've installed navitron, just point vim at a directory.

## Features

- Seamless file and directory management.
- Vim-like keybindings (`dd` deletes a file or directory, `hjkl` navigates,
  `r` renames).
- Integrates with [skim](https://github.com/lotabout/skim) and [fzf](https://github.com/junegunn/fzf) (`f`/`t`).

## Future

- Add file/directory permission management.
- Bulk deletion (visual mode).
