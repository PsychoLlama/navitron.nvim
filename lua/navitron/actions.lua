local cursor = require('navitron.cursor')
local fuzzy = require('navitron.fuzzy')
local navitron = require('navitron')
local utils = require('navitron.utils')

local M = {
  find_file = fuzzy.find_file,
  find_directory = fuzzy.find_dir,
}

local function get_file_or_directory_under_cursor()
  local index = vim.fn.line('.')
  return vim.b.navitron.directory[index]
end

function M.go_up(dir_count)
  cursor.save_position()

  local prev_dir_path = vim.b.navitron.path
  local target_dir = vim.b.navitron.path

  while dir_count > 0 do
    target_dir = vim.fn.fnamemodify(target_dir, ':h')
    dir_count = dir_count - 1
  end

  navitron.open(target_dir)
  utils.focus_cursor_over_path(prev_dir_path)
end

--- Open the parent directory.
function M.open_parent()
  M.go_up(1)
end

--- Open the Navitron entry under the cursor.
function M.open()
  local directory = get_file_or_directory_under_cursor()

  if directory == nil then
    return
  end

  cursor.save_position()

  if vim.fn.isdirectory(directory.path) == 1 then
    navitron.open(directory.path)
  else
    pcall(function()
      -- Raises an error if the file is open in another instance of neovim.
      vim.cmd.edit(vim.fn.fnameescape(directory.path))
    end)
  end
end

--- Open the home directory.
function M.open_home()
  local homedir = vim.uv.os_homedir()

  if not homedir then
    vim.notify("Couldn't resolve home directory.", vim.log.levels.WARN)
    return
  end

  navitron.open(homedir)
end

--- Create a new file, but don't open it yet.
function M.new_file()
  local file = vim.fn.input('New file: ')
  local absolute_path = vim.b.navitron.path .. '/' .. file

  if file == '' then
    return false
  end

  vim.fn.writefile({}, absolute_path)
  require('navitron.render').render()
  utils.focus_cursor_over_path(absolute_path)

  return true
end

--- Create a new file and open it immediately.
function M.open_new_file()
  if M.new_file() then
    M.open()
  end
end

--- Create a new directory, but don't open it yet.
function M.new_directory()
  local directory = vim.fn.input('New directory: ')
  local absolute_path = vim.b.navitron.path .. '/' .. directory

  if string.len(directory) == 0 then
    return false
  end

  vim.fn.mkdir(absolute_path)
  require('navitron.render').render()
  utils.focus_cursor_over_path(absolute_path)

  return true
end

--- Create a new directory and open it immediately.
function M.open_new_directory()
  if M.new_directory() then
    M.open()
  end
end

-- Recursively delete the file or directory under the cursor.
function M.delete()
  local entry = get_file_or_directory_under_cursor()

  if entry == nil then
    return
  end

  if vim.fn.confirm('Delete ' .. entry.name .. '?', '&Yes\n&No') ~= 1 then
    return
  end

  vim.fn.delete(entry.path, 'rf') -- YOLO

  cursor.save_position()
  require('navitron.render').render()
end

local function move_entry(entry, path)
  local new_path = path:gsub('/$', '')
  vim.fn.mkdir(vim.fn.fnamemodify(new_path, ':h'), 'p')

  vim.fn.rename(entry.path, new_path)
  entry.path = path

  require('navitron.render').render()
  utils.focus_cursor_over_path(path)
end

--- Rename the entry under the cursor.
function M.rename()
  local entry = get_file_or_directory_under_cursor()

  if entry == nil then
    return
  end

  local target_name = vim.fn.input({ prompt = 'Rename: ' })
  local new_path = vim.fn.fnamemodify(entry.path, ':h') .. '/' .. target_name

  if string.len(target_name) ~= 0 then
    move_entry(entry, new_path)
  end
end

--- Move the entry under the cursor to a new location.
function M.move()
  local entry = get_file_or_directory_under_cursor()

  if entry == nil then
    return
  end

  local new_path = vim.fn.input({
    prompt = 'Move: ',
    default = entry.path,
    completion = 'file',
  })

  if string.len(new_path) ~= 0 then
    move_entry(entry, new_path)
  end
end

--- Map one or more keys to a callback.
--- TODO: Support keymap descriptions.
---
--- @param keys string|string[]
--- @param handler function
local function keymap(keys, handler)
  if type(keys) == 'string' then
    keys = { keys }
  end

  for _, key in ipairs(keys) do
    vim.api.nvim_buf_set_keymap(0, 'n', key, '', {
      callback = handler,
      noremap = true,
      silent = true,
    })
  end
end

function M.init_keymaps()
  local config = require('navitron.config').get()
  local state = vim.b.navitron

  if state.has_defined_mappings then
    return
  end

  state.has_defined_mappings = true
  vim.b.navitron = state

  -- Define keymaps. Both keymaps and handlers can be overridden independently
  -- through `setup(...)`.
  for id, binding in pairs(config.keymaps) do
    keymap(binding, config.actions[id])
  end
end

return M
