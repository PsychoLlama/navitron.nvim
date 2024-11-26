local M = {}

--- @class navitron.pickers.find_directory.Options
--- @field cwd string Directory to perform the seach.

--- Open a Telescope picker searching for directories under the current path.
--- @param opts navitron.pickers.find_directory.Options
function M.find_directory(opts)
  local finders = require('telescope.finders')
  local pickers = require('telescope.pickers')
  local conf = require('telescope.config').values
  local action_state = require('telescope.actions.state')
  local actions = require('telescope.actions')

  pickers
    .new(opts, {
      prompt_title = 'Directory',
      finder = finders.new_oneshot_job({ 'fd', '--type', 'directory' }, {
        cwd = opts.cwd,
        entry_maker = function(entry)
          return {
            path = vim.fs.joinpath(opts.cwd, entry),
            display = entry,
            ordinal = entry,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          require('navitron').open(selection.path)
        end)

        return true
      end,
    })
    :find()
end

return M
