vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = { '*' },
  callback = function()
    local path = vim.fn.expand('%:p')

    if vim.fn.isdirectory(path) == 1 then
      require('navitron').open(path)
    end
  end,
})
