return {
  -- TODO: Remove this once all consumers are in Lua. It's trivial.
  trim_trailing_slash = function(str)
    return str:gsub("/$", "")
  end,

  -- Find the file path in the entry and set the cursor to match.
  focus_cursor_over_path = function(path)
    for index, value in ipairs(vim.b.navitron.directory) do
      if value.path == path then
        vim.fn.cursor(index, 1)
      end
    end
  end,

  setlocal = function(option, value)
    vim.api.nvim_set_option_value(option, value, {
      scope = 'local',
    })
  end,
}
