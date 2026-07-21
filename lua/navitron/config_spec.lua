local actions = require('navitron.actions')
local config = require('navitron.config')

describe('config', function()
  -- `config` holds module-global state that survives between tests, so reset
  -- it back to the defaults before each example.
  before_each(function()
    -- `set` deep-merges a partial config over the defaults, so an empty table
    -- resets it back to the defaults.
    ---@diagnostic disable-next-line: missing-fields
    config.set({})
  end)

  it('exposes the default keymaps and actions', function()
    local current = config.get()

    assert.same({ 'h', '-' }, current.keymaps[actions.open_parent])
    assert.same({ 'l', '<cr>', '<s-cr>' }, current.keymaps[actions.open])
    assert.equal(actions.open, current.actions[actions.open])
  end)

  it('overrides a single keymap without dropping the others', function()
    config.set({
      keymaps = {
        [actions.open_parent] = 'x',
      },
    })

    local current = config.get()

    assert.equal('x', current.keymaps[actions.open_parent])
    -- Untouched defaults are preserved.
    assert.same({ 'l', '<cr>', '<s-cr>' }, current.keymaps[actions.open])
  end)

  it('overrides an action handler independently of its keymap', function()
    local handler = function() end

    config.set({
      actions = {
        [actions.delete] = handler,
      },
    })

    local current = config.get()

    assert.equal(handler, current.actions[actions.delete])
    -- The keymap for the action is still the default.
    assert.equal('dd', current.keymaps[actions.delete])
  end)
end)
