local function link(group, target)
  vim.cmd.highlight('default', 'link', group, target)
end

local function hi(group, ...)
  vim.cmd.highlight(group, ...)
end

-- Matches: `{entry_type}:my-file.txt`
local function create_region(group_name, marker, exclude_hidden_files)
  local hidden_pattern = ''

  if exclude_hidden_files then
    hidden_pattern = '[^.]'
  end

  vim.cmd.syntax(
    'region',
    group_name,
    'start=/^' .. marker .. ':' .. hidden_pattern .. '/',
    'end=/$/',
    'contains=navitronEntryType'
  )
end

-- Every entry is prefixed with a hidden `{type}:` marker.
-- It must be concealed.
vim.cmd.syntax(
  'match',
  'navitronEntryType',
  '/\\v^\\w+:/',
  'conceal',
  'contained'
)

create_region('navitronFileEntry', 'file', true)
create_region('navitronDirectoryEntry', 'dir', true)
create_region('navitronSymlinkEntry', 'link')
create_region('navitronSocketEntry', 'socket')
create_region('navitronFifoEntry', 'fifo')

create_region('navitronCharacterDeviceEntry', 'cdev')
create_region('navitronBlockDeviceEntry', 'bdev')
create_region('navitronUnknownEntry', 'other')

-- Hidden file/directory entry
vim.cmd.syntax(
  'region',
  'navitronHiddenEntry',
  'start=/\\v^(dir|file):\\./',
  'end=/$/',
  'contains=navitronEntryType'
)

link('navitronDirectoryEntry', 'Directory')
link('navitronFileEntry', 'Normal')
link('navitronSymlinkEntry', 'Structure')
link('navitronHiddenEntry', 'Comment')

-- Unusual, but not too unusual.
link('navitronSocketEntry', 'Constant')
link('navitronFifoEntry', 'Constant')

-- Likely to happen if you explore /dev
link('navitronCharacterDeviceEntry', 'Substitute')
link('navitronBlockDeviceEntry', 'Substitute')
link('navitronUnknownEntry', 'Normal')
