local cursor = require('navitron.cursor')

describe('cursor', function()
  before_each(function()
    -- A scratch buffer with a handful of lines so the cursor has room to move.
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'one', 'two', 'three' })
    vim.api.nvim_set_current_buf(bufnr)

    vim.g.navitron = { cursor_positions = {} }
    vim.b.navitron = { path = '/tmp/example' }
  end)

  it('remembers the cursor line, keyed by the buffer path', function()
    vim.fn.cursor(3, 1)

    cursor.save_position()

    assert.equal(3, vim.g.navitron.cursor_positions['/tmp/example'])
  end)

  it('restores a previously saved cursor line', function()
    local state = vim.g.navitron
    state.cursor_positions['/tmp/example'] = 2
    vim.g.navitron = state

    vim.fn.cursor(1, 1)
    cursor.restore_position()

    assert.equal(2, vim.fn.line('.'))
  end)

  it('leaves the cursor alone when no position was saved', function()
    vim.fn.cursor(2, 1)

    cursor.restore_position()

    assert.equal(2, vim.fn.line('.'))
  end)
end)
