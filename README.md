# navitron.nvim

A better file browser for neovim.

## Usage

This replaces netrw as the built-in file explorer. After installing the plugin, run:

```lua
require('navitron').setup {}
```

Now every directory will be loaded with navitron.

## Features

- Buffer-oriented file browsing, like netrw.
- Vim-inspired keybindings for file management (`dd` deletes a file or directory, `hjkl` navigates, `r` renames).
- Fuzzy-finder integration via [fzf](https://github.com/junegunn/fzf) (`f` / `t` mappings).
- Configurable and extensible. See [:help navitron](./doc/navitron.txt).
