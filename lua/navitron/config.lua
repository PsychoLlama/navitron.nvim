local actions = require('navitron.actions')

local M = {}

--- Optional config passed to `setup(...)`. Used to override keymaps and
--- default behaviors.
--- @class navitron.Config
--- @field actions table<function, function>
--- @field keymaps table<function, string|string[]>
local defaults = {
  actions = {
    [actions.open_parent] = actions.open_parent,
    [actions.open_home] = actions.open_home,
    [actions.open] = actions.open,
    [actions.new_file] = actions.new_file,
    [actions.new_directory] = actions.new_directory,
    [actions.delete] = actions.delete,
    [actions.open_new_file] = actions.open_new_file,
    [actions.open_new_directory] = actions.open_new_directory,
    [actions.rename] = actions.rename,
    [actions.move] = actions.move,
    [actions.find_file] = actions.find_file,
    [actions.find_directory] = actions.find_directory,
  },

  keymaps = {
    [actions.open_parent] = { 'h', '-' },
    [actions.open_home] = '~',
    [actions.open] = { 'l', '<cr>' },
    [actions.new_file] = { '%', 'i' },
    [actions.new_directory] = 'a',
    [actions.delete] = 'dd',
    [actions.open_new_file] = 'I',
    [actions.open_new_directory] = 'A',
    [actions.rename] = 'r',
    [actions.move] = 'R',
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
