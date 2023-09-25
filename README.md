# navitron.nvim

A better file browser for neovim.

:construction: Work in Progress :construction:

## Usage

This replaces netrw as the built-in file explorer. After installing the plugin, run:

```lua
require('navitron').setup {}
```

Now every directory will be loaded with navitron.

## Features

- Buffer-oriented file browsing, like netrw.
- Vim-inspired keybindings for file management (`dd` deletes a file or directory, `hjkl` navigates,
  `r` renames).
- Integrates with [skim](https://github.com/lotabout/skim) and [fzf](https://github.com/junegunn/fzf) (`f`/`t`) for fuzzy finding.

## Future

- Expose callback to override the fuzzy finders
- Add file/directory permission management.
- Bulk deletion (visual mode).
