return {
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
