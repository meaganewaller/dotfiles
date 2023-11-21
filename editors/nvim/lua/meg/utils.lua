local M = {}
local api = vim.api

function M.combine_plugins(sources_handler)
  local plugins = {}

  local sources = sources_handler()

  for _, source in pairs(sources) do
    for _, plugin in ipairs(source) do
      table.insert(plugins, plugin)
    end
  end

  return plugins
end

function M.has_words_before()
  local line, col = unpack(api.nvim_win_get_cursor(0))
  return col ~= 0 and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function M.p(...)
  local args = { ... }
  local mods = {}
  local first_mod
  for _, arg in ipairs(args) do
    if type(arg) == "function" then
      arg(unpack(mods))
      break
    end
    local ok, mod = pcall(require, arg)
    if ok then
      if not first_mod then first_mod = mode end
      table.insert(mods, mod)
    else
      vim.notify_once(string.format("Missing module: %s", arg), vim.log.levels.WARN)
      local dummy = {}
      setmetatable(dummy, {
        __call = function() return dummy end,
        __index = function() return dummy end,
      })
      return dummy
    end
  end
  return first_mod
end

function M.plugin_available(plugin_name)
  local available = pcall(require, plugin_name)

  return available
end

function M.convert_command_center_opts(default_opts)
  local opts = {}
  local mode = "n"

  for key, value in pairs(default_opts) do
    if key == "mode" then
      mode = value
    else
      opts[key] = value
    end
  end

  return { mode = mode, opts = opts }
end

function M.flat_binding_resolver(mappings, previous_keys, opts)
  local category = ""
  local items = {}

  if mappings.name ~= nil then
    if type(mappings.name) ~= "string" then
      error("category name must be a string")
      return items
    else
      category = mappings.name
    end
  end

  if type(mappings) ~= "table" then
    error("mappings is not a table")

    return items
  else
    for key, mapping in pairs(mappings) do
      if key ~= "name" then
        if #mapping == 2 and mapping.name == nil then
          local cmd = mapping[1]
          local desc = mapping[2]

          if type(desc) ~= "string" then
            error("item desc must be a string")

            return items
          end

          local command_center_opts = M.convert_command_center_opts(opts)

          local item = {
            desc = desc,
            cmd = cmd,
            keys = {
              {
                command_center_opts.mode,
                (previous_keys or "") .. key,
                command_center_opts.opts,
              },
            },
          }

          if category ~= "" then
            item.category = category
          else
            item.category = " Aliases"
          end

          table.insert(items, item)
        else
          local nested_items = M.flat_binding_resolver(mapping, (previous_keys or "") .. key, opts)

          for _, item in ipairs(nested_items) do
            table.insert(items, item)
          end
        end
      end
    end
  end

  return items
end

function M.deep_extend_arrays(base, arr_tbl)
  local result = vim.tbl_deep_extends("force", {}, base or {})

  for _, tbl in ipairs(arr_tbl) do
    result = vim.tbl_deep_extends("force", result, tbl)
  end

  return base
end

function M.get_icon(kind, padding)
  local icon = require("meg.icons")[kind]

  return icon and icon .. string.rep(" ", padding or 0) or ""
end

function M.empty_tbl(tbl)
  if type(tbl) ~= "table" then return true end

  local index = #tbl

  return index == 0
end

function M.echo(v) print(vim.inspect(v)) end

function M.file_exists(path)
  local f = io.open(path, "r")
  if f then
    io.close(f)
    return true
  else
    return false
  end
end

return M
