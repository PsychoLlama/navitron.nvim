local M = {}

--- Buffer-local state for a Navitron buffer (`vim.b.navitron`).
--- @class navitron.State
--- @field path string The directory the buffer is displaying.
--- @field directory navitron.Entry[] The entries within that directory.

--- Plugin-global state (`vim.g.navitron`).
--- @class navitron.GlobalState
--- @field cursor_positions table<string, integer> Last cursor line, keyed by path.
--- @field previous_buffer? string Path of the last-focused buffer, if any.

local function initialize_navitron_buffer(path)
  local setlocal = require('navitron.utils').setlocal

  setlocal('autoread', true)
  setlocal('bufhidden', 'hide')
  setlocal('buflisted', false)
  setlocal('buftype', 'nofile')
  setlocal('concealcursor', 'nvic')
  setlocal('conceallevel', 3)
  setlocal('modifiable', false)
  setlocal('number', false)
  setlocal('readonly', true)
  setlocal('signcolumn', 'no')
  setlocal('swapfile', false)
  setlocal('wrap', true)

  -- Remove trailing slashes to simplify downstream scripts.
  local normalized_path = path:gsub('/$', '')

  --- @type navitron.State
  vim.b.navitron = {
    path = normalized_path,
    directory = require('navitron.search')(normalized_path),
  }

  require('navitron.keymap').init()
end

--- @param config? navitron.Config
function M.setup(config)
  -- Officially recommended way to disable netrw.
  -- See `:help netrw-noload`
  vim.g.loaded_netrw = true
  vim.g.loaded_netrwPlugin = true

  -- Initialize global state.
  --- @type navitron.GlobalState
  vim.g.navitron = {
    cursor_positions = {},
    previous_buffer = nil,
  }

  require('navitron.config').set(config or {})
end

--- Open the directory with Navitron. Replaces the current window.
--- @param directory_path string
function M.open(directory_path)
  if vim.fn.isdirectory(directory_path) == 0 then
    error('Navitron: Not a directory: ' .. directory_path)
  end

  -- `open(...)` can be called from existing buffers. Make sure we're
  -- operating in a new buffer, rather than overwriting an old.
  if vim.fn.expand('%:p') ~= directory_path then
    vim.api.nvim_cmd({
      cmd = 'edit',
      args = { directory_path },
    }, {})
  end

  if vim.b.navitron == nil then
    initialize_navitron_buffer(directory_path)
  end

  require('navitron.render').render()

  if vim.g.navitron.previous_buffer ~= nil then
    require('navitron.utils').focus_cursor_over_path(
      vim.g.navitron.previous_buffer
    )
  end
end

return M
