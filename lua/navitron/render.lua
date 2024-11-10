local M = {}

--- Replace the current buffer's contents.
--- @param contents string[]
local function set_contents(contents)
  local setlocal = require('navitron.utils').setlocal

  setlocal('modifiable', true)
  setlocal('readonly', false)

  vim.fn.setline(1, contents)
  if vim.fn.line('$') > #contents then
    vim.cmd('silent ' .. #contents + 1 .. ',$ delete')
  end

  setlocal('modifiable', false)
  setlocal('readonly', true)
end

--- Format an entry for human eyes.
local function describe(_, result)
  local name = result.pretty_name

  if result.type == 'link' then
    name = name .. ' -> ' .. result.target
  end

  return result.type .. ':' .. name
end

--- Refresh the current directory and draw it on the buffer.
function M.render()
  local state = vim.b.navitron
  state.directory = require('navitron.search')(state.path)
  vim.b.navitron = state

  local contents = vim.fn.map(vim.fn.copy(state.directory), describe)
  set_contents(contents)
end

return M
