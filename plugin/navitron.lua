vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('navitron_syntax', {}),
  pattern = { '*' },
  callback = function()
    local path = vim.fn.expand('%:p')

    if vim.fn.isdirectory(path) == 1 then
      vim.api.nvim_set_option_value('filetype', 'navitron', {
        scope = 'local',
      })

      require('navitron').open(path)
    else
      vim.call('navitron#render#clear')
    end
  end,
})
