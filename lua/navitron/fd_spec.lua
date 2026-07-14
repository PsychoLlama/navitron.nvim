local fd = require('navitron.fd')

describe('fd', function()
  local original_executable

  before_each(function()
    original_executable = vim.fn.executable
  end)

  after_each(function()
    vim.fn.executable = original_executable
  end)

  --- Stub `executable()` so only the named binaries report as available.
  local function only_available(...)
    local available = {}
    for _, name in ipairs({ ... }) do
      available[name] = true
    end

    --- @diagnostic disable-next-line: duplicate-set-field
    vim.fn.executable = function(name)
      return available[name] and 1 or 0
    end
  end

  describe('command', function()
    it('prefixes the defaults and appends the given arguments', function()
      only_available('fd')

      assert.same({
        'fd',
        '--color',
        'never',
        '--hidden',
        '--exclude',
        '.git/',
        '--type',
        'file',
      }, fd.command({ '--type', 'file' }))
    end)

    it('falls back to `fdfind` when `fd` is unavailable', function()
      only_available('fdfind')

      assert.equal('fdfind', fd.command({})[1])
    end)

    it('prefers `fd` when both are available', function()
      only_available('fd', 'fdfind')

      assert.equal('fd', fd.command({})[1])
    end)

    it('errors when neither executable is available', function()
      only_available()

      assert.has_error(function()
        fd.command({})
      end)
    end)
  end)
end)
