local M = {}

M.root_patterns = {
  '.git/',
  '.svn/',
  '.bzr/',
  '.hg/',
  '.project/',
  '.pro',
  '.sln',
  '.vcxproj',
  'Makefile',
  'makefile',
  'MAKEFILE',
  '.gitignore',
  '.editorconfig',
}

---Compute project directory for given path.
---@param fpath string?
---@param patterns string[]? root patterns
---@return string? nil if not found
function M.proj_dir(fpath, patterns)
  if not fpath or fpath == '' then
    return nil
  end
  patterns = patterns or M.root_patterns
  local dirpath = vim.fn.fnamemodify(fpath, ":h")
  for _, pattern in ipairs(patterns) do
    local root = vim.fn.finddir(pattern, dirpath .. ';')
    if root ~= '' then
      return root
    end
  end
end

return M
