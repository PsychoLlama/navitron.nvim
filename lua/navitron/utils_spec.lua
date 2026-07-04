local utils = require('navitron.utils')

describe('utils', function()
  before_each(function()
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(bufnr)
  end)

  describe('setlocal', function()
    it('sets a buffer-local option', function()
      utils.setlocal('modifiable', false)

      assert.is_false(
        vim.api.nvim_get_option_value('modifiable', { scope = 'local' })
      )
    end)
  end)

  describe('focus_cursor_over_path', function()
    before_each(function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'a', 'b', 'c' })
      vim.b.navitron = {
        directory = {
          { path = '/tmp/a' },
          { path = '/tmp/b' },
          { path = '/tmp/c' },
        },
      }
    end)

    it('moves the cursor to the line matching the path', function()
      utils.focus_cursor_over_path('/tmp/b')

      assert.equal(2, vim.fn.line('.'))
    end)

    it('leaves the cursor alone when no entry matches', function()
      vim.fn.cursor(1, 1)

      utils.focus_cursor_over_path('/tmp/does-not-exist')

      assert.equal(1, vim.fn.line('.'))
    end)
  end)
end)
