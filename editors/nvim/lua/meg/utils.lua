local fn = vim.fn
local M = {}

function M.firstToUpper(str)
  return (str:gsub("^%l", string.upper))
end

function M.is_table(t)
  return type(t) == "table"
end

function M.find_first(t, predicate)
  for _, entry in pairs(t) do
    if predicate(entry) then
      return entry
    end
  end
  return nil
end

function M.table_contains(t, predicate)
  return M.find_first(t, predicate) ~= nil
end

function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

function M.starts_with(str, start)
  return str:sub(1, #start) == start
end

function M.has_key(t, key)
  for t_key,_ in pairs(t) do
    if t_key == key then
      return true
    end
  end
  return false
end

function M.has_value(t, val)
  for _,value in pairs(t) do
    if value == val then
      return true
    end
  end
  return false
end

function M.tprint(table)
  print(vim.inspect(table))
end

function M.reload()
  local reload_ok, reload = pcall(require, "plenary.reload")
  if reload_ok then
    local counter = 0

    for name, _ in pairs(package.loaded) do
      if M.starts_with(name, "meg.") then
        reload.reload_module(name)
        counter = counter + 1
      end
    end

    vim.g.mapper_records = nil
    vim.notify("Reloaded " .. counter .. " modules!")
  end
end

function M.is_macunix()
  return vim.fn.has("macunix")
end

function M.link_highlight(from, to, override)
  local hl_exists, _ = pcall(vim.api.nvim_get_hl_by_name, from, true)
  if override or not hl_exists then
    vim.cmd("highlight! link " .. from .. " " .. to)
  end
end

function M.highlight(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

function M.highlight_bg(group, color)
  M.highlight(group, { guibg = color, ctermbg = color, bg = color })
end

function M.highlight_fg(group, color)
  M.highlight(group, { guifg = color, ctermfg = color, fg = color })
end

function M.highlight_both(group, bg, fg)
  M.highlight(group, { guibg = bg, ctermbg = bg, bg = bg, guifg = fg, ctermfg = fg, fg = fg })
end

function M.from_highlight(hl)
  local result = {}
  local list = vim.api.nvim_get_hl_by_name(hl, true)
  for k, v in pairs(list) do
    local name = k == "background" and "bg" or "fg"
    result[name] = string.format("#%06x", v)
  end
  return result
end

function M.get_color_from_terminal(num, default)
  local ok, color = pcall(vim.fn.synIDattr, num, "fg")
  if ok then
    return color
  else
    return default
  end
end

function M.cmd(name, command, desc)
  vim.api.nvim_create_user_command(name, command, desc)
  -- M.check_duplicates("c", name, desc)
end

function M.autocmd(evt, opts)
  vim.api.nvim_create_autocmd(evt, opts)
end

function M.executable(exe)
  if fn.executable(exe) == 0 then
    vim.notify(M.firstToUpper(exe) .. " not found!", vim.log.levels.WARN, { title = "Nvim-config" })
    return false
  end

  return true
end

local keymap = vim.keymap
local which_key_lazy_registers = nil
local function lazy_register_which_key(input, description)
  if which_key_lazy_registers == nil then
    which_key_lazy_registers = {}
  end

  table.insert(which_key_lazy_registers, { input = input, description = description })
end

local function try_add_to_which_key_by_input(input, description)
  local present_which_key, which_key = pcall(require, "which-key")

  local has_leader = string.find(input, "<leader>")
  if has_leader then
    if present_which_key then
      if which_key_lazy_registers ~= nil then
        which_key.register(which_key_lazy_registers)
        which_key_lazy_registers = nil
      end
      which_key.register({
        [input] = description,
      })
    else
      lazy_register_which_key(input, description)
    end
  end
end

function M.map(type, input, output, description, additional_opts)
  local options = { remap = true, desc = description }
  if additional_opts then
    options = vim.tbl_deep_extend("force", options, additional_opts)
  end
  keymap.set(type, input, output, options)
  local has_leader = string.find(input, "<leader>")
  M.check_duplicates(type, input, description)

  if has_leader then
    try_add_to_which_key_by_input(input, description)
  end
end

function M.noremap(type, input, output, description, additional_options)
  local options = { remap = false }
  if additional_options then
    options = vim.tbl_deep_extend("force", options, additional_options)
  end
  M.map(type, input, output, description, options)
end

function M.map_virtual(input, description)
  M.check_duplicates(type, input, description)
  try_add_to_which_key_by_input(input, description)
end

function M.which_key(input, description)
  try_add_to_which_key_by_input(input, description)
end

local duplicates_n = {}
local duplicates_v = {}
local duplicates_x = {}
local duplicates_s = {}
local duplicates_i = {}

local function check_and_set_duplicates(input, desc, check, table)
  if check then
    local found = table[input]

    if found ~= nil then
      if found ~= desc then
        print(input .. " already mapped (" .. found .. " so we cannot re-map (" .. desc .. ")")
      end
    end

    table[input] = desc
  end
end

function M.check_duplicates(type, input, description)
  local check_n = false
  local check_v = false
  local check_x = false
  local check_s = false
  local check_i = false

  if M.is_table(type) then
    if type["n"] then
      check_n = true
    end
    if type["v"] then
      check_v = true
    end
    if type["x"] then
      check_x = true
    end
    if type["s"] then
      check_s = true
    end
    if type["i"] then
      check_i = true
    end
  else
    if type == "n" then
      check_n = true
    end
    if type == "v" then
      check_v = true
    end
    if type == "x" then
      check_x = true
    end
    if type == "s" then
      check_s = true
    end
    if type == "i" then
      check_i = true
    end
  end

  check_and_set_duplicates(input, description, check_n, duplicates_n)
  check_and_set_duplicates(input, description, check_v, duplicates_v)
  check_and_set_duplicates(input, description, check_x, duplicates_x)
  check_and_set_duplicates(input, description, check_s, duplicates_s)
  check_and_set_duplicates(input, description, check_i, duplicates_i)
end

return M
