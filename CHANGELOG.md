# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- A Nix package for installing the plugin.

### Changed

- Creating files and directories now prompts through `vim.ui.input`.

### Fixed

- The cursor stays in place after deleting an entry instead of jumping to the top.

## [0.2.0] - 2024-12-28

### Changed

- Renaming now prompts through `vim.ui.input` instead of a command-line prompt.

## [0.1.0] - 2024-12-28

First tagged release (unstable).

### Added

- Buffer-oriented directory browser that replaces netrw.
- Navigation with `hjkl`-style movement: descend into directories, move up a directory, and jump to your home directory.
- Remembers the directory you came from and restores the cursor position when moving between directories.
- File management: create files, create directories, delete files and directories, move, and rename.
- Fuzzy file finding through Telescope (`f`/`t`), plus a custom picker that searches downward through directories.
- Syntax highlighting, dimming of hidden files and directories, and symlink support.
- Statusline updates to reflect the current directory.
- Configurable actions and keymaps, overridable through `setup`.

[Unreleased]: https://github.com/PsychoLlama/navitron.nvim/compare/0.2.0...HEAD
[0.2.0]: https://github.com/PsychoLlama/navitron.nvim/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/PsychoLlama/navitron.nvim/commits/0.1.0
