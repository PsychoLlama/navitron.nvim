local function link(group, target)
  vim.cmd.highlight('default', 'link', group, target)
end

-- Matches: `{entry_type}:my-file.txt`
local function create_region(group_name, marker)
  vim.cmd.syntax(
    'region',
    group_name,
    'start=/^' .. marker .. ':[^.]/',
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

-- File entry
vim.cmd.syntax(
  'region',
  'navitronFileEntry',
  'start=/^file:[^.]/',
  'end=/$/',
  'contains=navitronEntryType'
)

-- Directory entry
vim.cmd.syntax(
  'region',
  'navitronDirectoryEntry',
  'start=/^dir:[^.]/',
  'end=/$/',
  'contains=navitronEntryType'
)

-- Symlink entry
vim.cmd.syntax(
  'region',
  'navitronSymlinkEntry',
  'start=/^link:/',
  'end=/$/',
  'contains=navitronEntryType'
)

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
