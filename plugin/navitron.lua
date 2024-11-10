-- Take over control of new buffers if they are directories.
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('navitron.explorer', {}),
  pattern = { '*' },
  callback = function()
    if vim.g.navitron == nil then
      return
    end

    local path = vim.fn.expand('%:p')

    if vim.fn.isdirectory(path) == 1 then
      vim.api.nvim_set_option_value('filetype', 'navitron', {
        scope = 'local',
      })

      require('navitron').open(path)
    end
  end,
})

-- Remember the last open file so we can auto-focus it.
vim.api.nvim_create_autocmd({ 'BufLeave' }, {
  group = vim.api.nvim_create_augroup('navitron.autofocus', {}),
  pattern = { '*' },
  callback = function()
    -- Remove trailing slashes on directories.
    local current_path =
      vim.fn.substitute(vim.fn.expand('%:p'), '\\v/$', '', '')
    vim.g.navitron = vim.tbl_extend('force', vim.g.navitron, {
      previous_buffer = current_path,
    })
  end,
})
