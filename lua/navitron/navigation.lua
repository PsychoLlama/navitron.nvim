local utils = require('navitron.utils')
local cursor = require('navitron.cursor')
local fuzzy = require('navitron.fuzzy')
local navitron = require('navitron')

local function get_file_or_directory_under_cursor()
  local index = vim.fn.line('.')
  return vim.b.navitron.directory[index]
end

local function go_up(dir_count)
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

local function explore_listing_under_cursor()
  local directory = get_file_or_directory_under_cursor()

  if directory == nil then
    return
  end

  cursor.save_position()

  if vim.fn.isdirectory(directory.path) == 1 then
    navitron.open(directory.path)
  else
    vim.cmd.edit(directory.path)
  end
end

local function create_file()
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

local function create_and_edit_file()
  if create_file() then
    explore_listing_under_cursor()
  end
end

local function create_directory()
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

local function create_and_explore_directory()
  if create_directory() then
    explore_listing_under_cursor()
  end
end

local function delete_file_or_directory()
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

local function move_file_or_directory_relative()
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

local function move_file_or_directory_absolute()
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

local function define_mappings()
  local state = vim.b.navitron

  if state.has_defined_mappings then
    return
  end

  state.has_defined_mappings = true
  vim.b.navitron = state

  keymap({ 'h', '-' }, function() go_up(1) end)
  keymap({ 'l', '<cr>' }, explore_listing_under_cursor)
  keymap({ '%', 'i' }, create_file)
  keymap('a', create_directory)
  keymap('dd', delete_file_or_directory)
  keymap('I', create_and_edit_file)
  keymap('A', create_and_explore_directory)
  keymap('r', move_file_or_directory_relative)
  keymap('R', move_file_or_directory_absolute)
  keymap('f', fuzzy.find_file)
  keymap('t', fuzzy.find_dir)
end

return {
  create_and_edit_file = create_and_edit_file,
  create_and_explore_directory = create_and_explore_directory,
  create_directory = create_directory,
  create_file = create_file,
  define_mappings = define_mappings,
  delete_file_or_directory = delete_file_or_directory,
  explore_listing_under_cursor = explore_listing_under_cursor,
  go_up = go_up,
  move_file_or_directory_absolute = move_file_or_directory_absolute,
  move_file_or_directory_relative = move_file_or_directory_relative,
}
