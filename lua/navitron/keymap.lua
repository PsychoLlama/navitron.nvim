local M = {}

--- Map one or more keys to a callback.
--- TODO: Support keymap descriptions.
---
--- @param keys string|string[]
--- @param handler function
local function bufmap(keys, handler)
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

--- Set keymaps for the current buffer.
function M.init()
  local config = require('navitron.config').get()

  -- Define keymaps. Both keymaps and handlers can be overridden independently
  -- through `setup(...)`.
  for id, bindings in pairs(config.keymaps) do
    bufmap(bindings, config.actions[id])
  end
end

return M
