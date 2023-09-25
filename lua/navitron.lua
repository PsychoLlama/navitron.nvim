local setlocal = require('navitron.utils').setlocal

local function initialize_navitron_buffer(path)
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

  vim.b.navitron = {
    path = normalized_path,
    directory = require('navitron.search') { path = normalized_path },
  }

  vim.call('navitron#navigation#init_mappings')
end

return {
  -- Open the directory with Navitron. Replaces the current window.
  open = function(directory_path)
    if vim.fn.isdirectory(directory_path) == 0 then
      error('Navitron: Not a directory: ' .. directory_path)
    end

    -- `open(...)` can be called from existing buffers. Make sure we're
    -- operating in a new buffer, rather than overwriting an old.
    if vim.fn.expand('%:p') ~= directory_path then
      vim.cmd('edit ' .. directory_path)
    end

    if vim.b.navitron == nil then
      initialize_navitron_buffer(directory_path)
    end

    require('navitron.render').render()
  end,
}
