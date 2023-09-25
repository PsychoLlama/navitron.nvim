local IGNORED_LISTINGS = {
  ['..'] = true,
  ['.'] = true,
}

local function read_directory(directory)
  local visible = vim.fn.glob(directory .. '/*', false, true, true)
  local hidden = vim.fn.glob(directory .. '/.*', false, true, true)

  return vim.fn.extend(visible, hidden)
end

local function to_entry(_, path)
  local result = { type = vim.fn.getftype(path), path = path }

  result.path = result.path:gsub('/$', '')
  result.name = vim.fn.fnamemodify(result.path, ':t')
  result.pretty_name = result.name

  if result.type == 'dir' then
    result.pretty_name = result.pretty_name .. '/'
  end

  if result.type == 'link' then
    result.target = vim.fn.resolve(path)
  end

  return result
end

local function order(item1, item2)
  local ordering = {
    'dir',
    'file',
    'link',
    'socket',
    'bdev',
    'cdev',
    'fifo',
    'other',
  }

  -- Sort by entry type
  if item1.type ~= item2.type then
    return vim.fn.index(ordering, item1.type) - vim.fn.index(ordering, item2.type)
  end

  -- Sort by name
  if item1.pretty_name < item2.pretty_name then
    return -1
  end

  return 1
end

local function should_show_entry(_, entry)
  return IGNORED_LISTINGS[entry.name] == nil
end

return function(options)
  local entries = vim.fn.map(
    read_directory(options.path),
    to_entry
  )

  return vim.fn.uniq(
    vim.fn.sort(
      vim.fn.filter(
        entries,
        should_show_entry
      ),
      order
    )
  )
end
