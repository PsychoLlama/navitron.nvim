local M = {}

--- Remember which entry the cursor is over in case we return.
function M.save_position()
  local state = vim.g.navitron
  state.cursor_positions[vim.b.navitron.path] = vim.fn.line('.')
  vim.g.navitron = state
end

--- Restore the cursor to the last known position.
function M.restore_position()
  local state = vim.g.navitron
  local path = vim.b.navitron.path
  local last_line_nr = state.cursor_positions[path]

  if last_line_nr then
    vim.fn.cursor(last_line_nr, 1)
  end
end

return M
