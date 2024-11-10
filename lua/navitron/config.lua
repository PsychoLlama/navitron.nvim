local actions = require('navitron.actions')

local M = {}

--- Optional config passed to `setup(...)`. Used to override keymaps and
--- default behaviors.
--- @class navitron.Config
--- @field actions table<function, function>
--- @field keymaps table<function, string|string[]>
local defaults = {
  actions = {
    [actions.open_parent_dir] = actions.open_parent_dir,
    [actions.explore_listing_under_cursor] = actions.explore_listing_under_cursor,
    [actions.create_file] = actions.create_file,
    [actions.create_directory] = actions.create_directory,
    [actions.delete_file_or_directory] = actions.delete_file_or_directory,
    [actions.create_and_edit_file] = actions.create_and_edit_file,
    [actions.create_and_explore_directory] = actions.create_and_explore_directory,
    [actions.move_file_or_directory_relative] = actions.move_file_or_directory_relative,
    [actions.move_file_or_directory_absolute] = actions.move_file_or_directory_absolute,
    [actions.find_file] = actions.find_file,
    [actions.find_directory] = actions.find_directory,
  },

  keymaps = {
    [actions.open_parent_dir] = { 'h', '-' },
    [actions.explore_listing_under_cursor] = { 'l', '<cr>' },
    [actions.create_file] = { '%', 'i' },
    [actions.create_directory] = 'a',
    [actions.delete_file_or_directory] = 'dd',
    [actions.create_and_edit_file] = 'I',
    [actions.create_and_explore_directory] = 'A',
    [actions.move_file_or_directory_relative] = 'r',
    [actions.move_file_or_directory_absolute] = 'R',
    [actions.find_file] = 'f',
    [actions.find_directory] = 't',
  },
}

--- The current config. May change if the user calls `setup` again.
--- @type navitron.Config
local current_config = defaults

--- Set the global config.
--- @param config navitron.Config
function M.set(config)
  current_config = vim.tbl_deep_extend('force', defaults, config)
end

--- Get the current global config.
--- @return navitron.Config
function M.get()
  return current_config
end

return M
