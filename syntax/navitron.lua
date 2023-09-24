local function link(group, target)
  vim.cmd.highlight('default', 'link', group, target)
end

-- Matches: `{entry_type}:my-file.txt`
local function create_region(group_name, marker)
  vim.cmd.syntax(
    'region',
    group_name,
    'start=/^' .. marker .. ':/',
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

-- Directory entry
create_region('navitronDirectoryEntry', 'dir')
create_region('navitronFileEntry', 'file')

link('navitronDirectoryEntry', 'Directory')
link('navitronFileEntry', 'Normal')
