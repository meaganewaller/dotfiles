local fn, api = vim.fn, vim.api

local function replace_tabs(value)
  return fn.substitute(value, '\\t', fn['repeat'](' ', api.nvim_buf_get_option(0, 'tabstop')), 'g')
end

local function strip_whitespace(value)
  return fn.substitute(value, '^\\s*', '', 'g')
end

local function prepare_fold_section(value)
  return strip_whitespace(replace_tabs(value))
end

local fold_exclusions = {}

local function is_ignored()
  return fn.index(fold_exclusions, api.nvim_buf_get_option(0, 'filetype')) >= 0 or vim.wo.diff
end

local function is_import(item)
  local sub = item:match('^import')
  if sub ~= nil then
    return #sub > 0
  end
  return false
end

local function transform_import(item, foldsymbol)
  return fn.substitute(item, '^import .\\+', 'import' .. foldsymbol, '')
end

local function contains_delimiter(value)
  return #fn.matchstr(value, '}\\|)\\|]\\|`\\|>')
end

local function handle_fold_start(start_text, end_text, foldsymbol)
  if is_import(start_text) and contains_delimiter(end_text) then
    return transform_import(start_text, foldsymbol)
  end
  return prepare_fold_section(start_text) .. foldsymbol
end

local function handle_fold_end(item)
  if not contains_delimiter(item) or is_import(item) then
    return ''
  end
  return prepare_fold_section(item)
end

local render = function()
  if is_ignored() then
    return fn.foldtext()
  end
  local end_text = fn.getline(vim.v.foldend)
  local start_text = fn.getline(vim.v.foldstart)
  local st = handle_fold_start(start_text, end_text, '…')
  local ed = handle_fold_end(end_text)
  local line = string.format('%s%s', st, ed)
  local lines_count = vim.v.foldend - vim.v.foldstart + 1
  local count_text = string.format('(%d lines)', lines_count)
  local indentation = fn.indent(vim.v.foldstart)
  local fold_start = fn['repeat'](' ', indentation) .. line .. ' '
  local fold_end = ' ' .. count_text .. ' '
  local columns = fn.split(vim.wo.foldcolumn, ':')
  local column_size = columns[#columns]
  local fold_char = vim.o.fillchars:match('fold:(.-),') or ' '
  local text_length = #fn.substitute(fold_start .. fold_end, '.', 'x', 'g') + column_size
  return string.format('%s%s%s', fold_start, fn['repeat'](fold_char, fn.winwidth(0) - text_length - 10), fold_end)
end

return { render = render }
