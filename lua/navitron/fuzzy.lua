local navitron = require('navitron')

local function get_downward_search_pattern(type)
  if vim.fn.executable('fd') == 1 then
    return 'fd -t ' .. type
  end

  if vim.fn.executable('find') == 1 then
    return 'find . -type ' .. type
  end

  error("Can't find a search program (e.g. 'find').")
end

local function search(cmd, callback)
  local options = {
    dir = vim.b.navitron.path,
    source = cmd,
    sink = callback,
  }

  if vim.fn.exists('*fzf#run') == 1 then
    return vim.call('fzf#run', options)
  end

  vim.cmd.echohl('Error')
  vim.cmd.echon('"Error:"')
  vim.cmd.echohl('Clear')
  vim.cmd.echon('" Cannot fuzzy find, fzf is not installed."')
end

return {
  find_file = function()
    local cmd = get_downward_search_pattern('f')

    search(cmd, function(file)
      vim.cmd.edit(vim.fn.fnameescape(file))
    end)
  end,

  find_dir = function()
    local cmd = get_downward_search_pattern('d')

    search(cmd, function(directory)
      navitron.open(vim.fn.fnameescape(directory))
    end)
  end,
}
