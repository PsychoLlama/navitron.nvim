local M = {}

--- Find the file path in the entry and set the cursor to match.
function M.focus_cursor_over_path(directory)
  for index, value in ipairs(vim.b.navitron.directory) do
    if value.path == directory then
      vim.fn.cursor(index, 1)
    end
  end
end

--- Set a buffer-local option. Like `:setlocal`.
function M.setlocal(option, value)
  vim.api.nvim_set_option_value(option, value, {
    scope = 'local',
  })
end

return M
