local M = {}

--- Options applied to every `fd` invocation.
---
--- `--color never` keeps the output machine-parseable, and navitron shows
--- hidden entries while ignoring the `.git/` directory.
local DEFAULT_ARGS = {
  '--color',
  'never',
  '--hidden',
  '--exclude',
  '.git/',
}

--- Resolve the `fd` executable.
---
--- Debian and Ubuntu ship the binary as `fdfind` to avoid clashing with an
--- unrelated `fd` package, so fall back to that name when `fd` is absent.
--- @return string? executable The executable name, or nil if none is found.
local function resolve()
  for _, name in ipairs({ 'fd', 'fdfind' }) do
    if vim.fn.executable(name) == 1 then
      return name
    end
  end
end

--- Build an `fd` command with navitron's default options applied.
--- @param args string[] Extra arguments appended after the defaults.
--- @return string[] command The command, ready to spawn.
function M.command(args)
  local executable = resolve()

  if not executable then
    error('navitron: `fd` (or `fdfind`) is not installed or not on $PATH.')
  end

  local command = { executable }
  vim.list_extend(command, DEFAULT_ARGS)
  vim.list_extend(command, args)

  return command
end

return M
