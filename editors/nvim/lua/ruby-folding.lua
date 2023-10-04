local M = {}

function M.create()
  vim.b.foldtexts = {}
  vim.wo.foldtext = "luaeval(\"require('ruby-folding').foldtext()\")"

  local saved_view = vim.fn.winsaveview()

  -- Remove all folds for now
  vim.wo.foldmethod = "manual"
  vim.cmd([[normal! zE]])
  vim.cmd([[normal! gg]])

  -- Fold functions and modules
  if vim.bo.filetype:match("rspec") then
    M.foldAreas("it .* do", 0, vim.fn.line("$"))
    M.foldAreas("context .* do", 0, vim.fn.line("$"))
    M.foldAreas("describe .* do", 0, vim.fn.line("$"))
  else
    M.foldAreas("\\<def\\>", 0, vim.fn.line("$"))
    M.foldAreas("\\<module\\>", 0, vim.fn.line("$"))
    M.foldAreas("test .* do", 0, vim.fn.line("$"))
  end

  -- Fold public, private, protected scopes
  local scope_regex = "\\v^\\s*(public|private|protected)\\s*$"
  while true do
    local scope_line = vim.fn.search(scope_regex, "W")
    if scope_line <= 0 then break end

    local scope_name = vim.fn.substitute(vim.fn.getline("."), scope_regex, "\\1", "")

    local end_line = M.consumeWhitespace(scope_line)

    vim.b.foldtexts[scope_line] = "           | " .. scope_name .. " |           "
    vim.cmd(scope_line .. "," .. end_line .. "fold")
  end

  vim.cmd([[normal! zM]])
  vim.fn.winrestview(saved_view)
end

function M.foldtext()
  local line = vim.v.foldstart

  if vim.b.foldtexts[line] then
    return vim.b.foldtexts[line]
  else
    return vim.fn.foldtext()
  end
end

function M.foldAreas(pattern, from, to)
  local from = from
  local to = to

  local save_cursor = vim.fn.getpos(".")

  vim.fn.cursor(from, 0)

  while true do
    local start_line = vim.fn.search(pattern, "Wc", to)
    if start_line <= 0 then break end

    -- Ignore pattern in comments
    if vim.fn.getline(start_line):match("^%s*#.*" .. pattern) then
      vim.cmd("normal! j")
      goto continue
    end

    local ws = vim.fn.substitute(vim.fn.getline("."), "^\\(\\s*\\)", "\\1", "")

    local end_line = vim.fn.search("^" .. ws .. "end", "W", to)
    if end_line <= 0 then break end

    end_line = M.consumeWhitespace(end_line)

    vim.cmd(start_line .. "," .. end_line .. "fold")
    vim.cmd("normal! zo")

    if start_line >= from and end_line <= to then M.foldAreas(pattern, start_line + 1, end_line - 1) end

    ::continue::
  end

  vim.fn.setpos(".", save_cursor)
end

function M.consumeWhitespace(line)
  local line = line
  local last_line = vim.fn.line("$")

  while vim.fn.getline(line + 1):match("^%s*$") and line < last_line do
    line = line + 1
    vim.cmd("normal! j")
  end

  return line
end

return M
