local search = require('navitron.search')

--- Find an entry by its basename.
local function find(entries, name)
  for _, entry in ipairs(entries) do
    if entry.name == name then
      return entry
    end
  end
end

--- Index of the first entry with the given name.
local function index_of(entries, name)
  for index, entry in ipairs(entries) do
    if entry.name == name then
      return index
    end
  end
end

describe('search', function()
  local dir

  before_each(function()
    dir = vim.fn.tempname()
    vim.fn.mkdir(dir, 'p')

    vim.fn.mkdir(dir .. '/beta')
    vim.fn.writefile({}, dir .. '/alpha.txt')
    vim.fn.writefile({}, dir .. '/.hidden')
  end)

  after_each(function()
    vim.fn.delete(dir, 'rf')
  end)

  it('returns every visible and hidden entry', function()
    local entries = search(dir)
    local names = vim.tbl_map(function(entry)
      return entry.name
    end, entries)

    assert.same({ '.hidden', 'alpha.txt', 'beta' }, vim.fn.sort(names))
  end)

  it('omits the "." and ".." listings', function()
    local entries = search(dir)

    assert.is_nil(find(entries, '.'))
    assert.is_nil(find(entries, '..'))
  end)

  it('records the filesystem type of each entry', function()
    local entries = search(dir)

    assert.equal('dir', find(entries, 'beta').type)
    assert.equal('file', find(entries, 'alpha.txt').type)
  end)

  it('decorates directory names with a trailing slash', function()
    local entries = search(dir)

    assert.equal('beta/', find(entries, 'beta').pretty_name)
    assert.equal('alpha.txt', find(entries, 'alpha.txt').pretty_name)
  end)

  it('reports absolute paths without a trailing slash', function()
    local entries = search(dir)
    local beta = find(entries, 'beta')

    assert.equal(dir .. '/beta', beta.path)
  end)

  it('sorts directories ahead of files', function()
    local entries = search(dir)

    assert.is_true(index_of(entries, 'beta') < index_of(entries, 'alpha.txt'))
  end)

  it('resolves the target of a symlink', function()
    local target = dir .. '/alpha.txt'
    local link = dir .. '/link'
    assert.is_true(vim.uv.fs_symlink(target, link))

    local entry = find(search(dir), 'link')

    assert.equal('link', entry.type)
    assert.equal(target, entry.target)
  end)
end)
