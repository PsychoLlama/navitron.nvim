local setlocal = require('navitron.utils').setlocal

local function set_contents(contents)
  setlocal('modifiable', true)
  setlocal('readonly', false)

  vim.fn.setline(1, contents)

  setlocal('modifiable', false)
  setlocal('readonly', true)
end

local function describe(_, result)
  local name = result.pretty_name

  if result.type == 'link' then
    name = name .. ' -> ' .. result.target
  end

  return result.type .. ':' .. name
end

return {
  render = function()
    local state = vim.b.navitron
    state.directory = require('navitron.search') { path = state.path }
    vim.b.navitron = state

    local contents = vim.fn.map(vim.fn.copy(state.directory), describe)
    set_contents(contents)
  end,
}
