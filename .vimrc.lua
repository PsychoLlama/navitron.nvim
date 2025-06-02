local repo = vim.fn.expand('<sfile>:h')

require('core.pkg').override('navitron.nvim', function(plugin)
  return vim.tbl_extend('force', plugin, {
    type = 'path',
    source = repo,
  })
end)
