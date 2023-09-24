return {
  -- Open the directory with Navitron. Replaces the current window.
  open = function(directory_path)
    vim.call('navitron#explore', directory_path)
  end,
}
