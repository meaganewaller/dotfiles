-- Define a Lua module for Ruby block handling
local M = {}

function M.select_block(mode, visual)
  local saved_z_pos = vim.fn.getpos("'z")
  local saved_view = vim.fn.winsaveview()

  -- Syntax group names that are strings.
  local syng_string = { "String", "Interpolation", "InterpolationDelimiter", "StringEscape" }

  -- Syntax group names that are strings or documentation.
  local syng_stringdoc = vim.list_extend(syng_string, { "Documentation" })

  -- Syntax group names that are or delimit strings/symbols/regexes or are comments.
  local syng_strcom = vim.list_extend(syng_stringdoc, {
    "Character",
    "Comment",
    "HeredocDelimiter",
    "PercentRegexpDelimiter",
    "PercentStringDelimiter",
    "PercentSymbolDelimiter",
    "Regexp",
    "RegexpCharClass",
    "RegexpDelimiter",
    "RegexpEscape",
    "StringDelimiter",
    "Symbol",
    "SymbolDelimiter",
  })

  -- Regex that defines blocks.
  local block_regex = [[\%(\<do:\@!\>\|%\@<!{\)\s*\%(|[^|]*|\)\=\s*\%(#.*\)\=$']]
  local visual_mapping = visual and vim.fn.visualmode() or "V"
  -- Expression used to check whether we should skip a match with searchpair().
  local skip_expr =
    string.format([[index(map(%s,'hlID(''ruby''.v:val)'), synID(line('.'),col('.'),1)) >= 0]], vim.inspect(syng_strcom))

  local success, start_line = pcall(function() return vim.fn.search(block_regex, "Wbc", 0, 0, skip_expr) end)

  -- Regex that defines the start-match for the 'end' keyword.
  local end_start_regex =
    [[\C\%(^\s*\|[=,*/%+\-|;{]\|<<\|>>\|:\s\)\s*\zs\<\%(module\|class\|if\|for\|while\|until\|case\|unless\|begin\|\<\(\k*\[!?]\?\s\+\)\=\s*def\):\@!\>\|\<do:\@!\>]]
  -- Regex that defines the end-match for the 'end' keyword.
  local end_end_regex = [[\%(^\|[^.:@$]\)\@<=\<end:\@!\>]]

  if not success or start_line <= 0 then
    vim.fn.winrestview(saved_view)
    return
  end

  if mode == "i" then
    local saved_pos = vim.fn.getpos(".")
    vim.cmd("normal! j^")
    vim.fn.setpos("'z", vim.fn.getpos("."))
    vim.fn.setpos(".", saved_pos)
  else
    vim.fn.setpos("'z", vim.fn.getpos("."))
  end

  success, end_line = pcall(function() return vim.fn.searchpair(end_start_regex, "", end_end_regex, "W", skip_expr) end)

  if not success or end_line <= 0 then
    vim.fn.winrestview(saved_view)
    return
  end

  vim.cmd("normal! " .. visual_mapping .. "`z")

  if mode == "i" then vim.cmd("normal! kg_") end

  if vim.fn.line(".") < saved_z_pos[2] then
    vim.fn.setpos("'z", saved_z_pos)
    vim.fn.winrestview(saved_view)
    return
  end

  vim.fn.setpos("'z", saved_z_pos)
end

return M
