local settings = {
  center_cursor = true,
}

local api = vim.api
local cmd = vim.cmd
local lsp = vim.lsp

local utils = require "meg.utils"

local M = {}

M.make_trigger_map_action = function(map_key_cmd, key)
  local action = map_key_cmd[key]

  return function()
    if action == nil then return end

    utils.echo(action)

    local action_type = type(action)

    if action_type == "string" then
      cmd(action)
    elseif action_type == "function" then
      action()
    end
  end
end

M.pick_yank_icon = function() cmd [[ IconPickerYank ]] end

M.pick_insert_icon = function() cmd [[IconPickerInsert]] end

M.get_filetype = function(buf)
  local selected_buf = buf

  if buf == nil then selected_buf = api.nvim_get_current_buf() end

  local ft = api.nvim_buf_get_option(selected_buf, "filetype")
  return ft
end

M.select_window = function(pos)
  return function()
    if pos == "h" then
      cmd "wincmd h"
    elseif pos == "j" then
      cmd "wincmd j"
    elseif pos == "k" then
      cmd "wincmd k"
    elseif pos == "l" then
      cmd "wincmd l"
    end
  end
end

M.toggle_explorer = function()
  local ft = M.get_filetype()

  if ft == "NvimTree" then
    cmd "NvimTreeToggle"
  else
    cmd "NvimTreeFocus"
  end
end

M.finding = function(opts)
  return function()
    if opts == nil then cmd "Telescope resume" end

    local map_type_action = {
      file = "Telescope find_files",
      text = "Telescope live_grep",
      buffer = "Telescope buffers",
      commit = "Telescope git_commits",
      bcommit = "Telescope git_bcommits",
      todo = "TodoTelescope",
      glyph = "Telescope glyph",
      yank_registers = "lua require 'telescope.builtin'.registers()",
    }

    local action = map_type_action[opts.key]
    if action == nil or action == "" then return end

    if opts.args ~= nil then action = action .. " " .. opts.args end

    cmd(action)
  end
end

M.toggle_center_cursor = function()
  if not settings.center_cursor then
    cmd [[ set scrolloff=1000 ]]
    settings.center_cursor = true
  else
    cmd [[ set scrolloff=0 ]]
    settings.center_cursor = false
  end
end

M.open_command_center = function() cmd "Telescope command_center" end

M.magic_escape = function()
  cmd "noh"

  local ft = M.get_filetype()
  if ft == "toggleterm" then cmd "ToggleTermToggleAll" end

  if ft == "spectre_panel" then cmd "q" end
end

M.lsp = function(action_name, native)
  local map_lsp_saga = {
    ["finder"] = "finder",
    ["outline"] = "outline",
    ["rename"] = "rename",
    ["code_action"] = "code_action",
    ["definition"] = "goto_definition",
    ["t_definition"] = "goto_type_definition",
    ["p_definition"] = "peek_definition",
    ["diag_next"] = "diagnostic_jump_next",
    ["diag_prev"] = "diagnostic_jump_prev",
  }

  local map_lsp_def = {
    ["finder"] = lsp.buf.references,
    ["rename"] = lsp.buf.rename,
    ["declaration"] = lsp.buf.declaration,
    ["code_action"] = lsp.buf.code_action,
    ["definition"] = lsp.buf.definition,
    ["signature"] = lsp.buf.signature_help,
    ["implementation"] = lsp.buf.implementation,
    ["diag"] = M.lsp_document_diagnostics,
    ["w_diag"] = M.lsp_workspace_diagnosticss,
    ["format"] = lsp.buf.format,
  }

  return function()
    if native == nil or not native then
      local action = map_lsp_saga[action_name]
      if action ~= nil then cmd("Lspsaga " .. action) end
    else
      local action = map_lsp_def[action_name]
      if action ~= nil then action() end
    end
  end
end

M.lsp_attached_clients = function() cmd [[ LspInfo ]] end

M.lsp_restart = function() cmd [[ LspRestart ]] end

M.buffer_close_all_handler = function(keep_current)
  return function()
    local current = nil
    if keep_current then current = vim.fn.bufnr() end

    local buffers = vim.api.nvim_list_bufs()

    for _, bufnr in ipairs(buffers) do
      local buf_name = vim.api.nvim_buf_get_name(bufnr)
      utils.echo(buf_name)

      if keep_current ~= nil then
        if current ~= bufnr then
          vim.api.nvim_buf_delete(bufnr, { force = false })
        end
      else
        vim.api.nvim_buf_delete(bufnr, { force = false })
      end
    end
  end
end

M.buffer = function(opts)
  return M.make_trigger_map_action({
    open = "Telescope buffers",
    close = "bd",
    close_all = M.buffer_close_all_handler(),
    close_all_keep_current = M.buffer_close_all_handler(true),
  }, (opts or {}).key)
end

M.colorizer = function(opts)
  return M.make_trigger_map_action({
    toggle = "ColorizerToggle",
    attach = "ColorizerAttachToBuffer",
    detach = "ColorizerDetachToBuffer",
    reload = "ColorizerReloadAllBuffers",
  }, (opts or {}).key)
end

M.markdown = function(opts)
  return M.make_trigger_map_action({
    preview = "MarkdownPreview",
    preview_stop = "MarkdownPreviewStop",
    toggle = "MarkdownPreviewToggle",
    map_open = "MarkmapOpen",
    map_save = "MarkmapSave",
    map_watch = "MarkmapWatch",
    map_watch_stop = "MarkmapWatchStop",
  }, (opts or {}).key)
end

M.yank = function(opts)
  return M.make_trigger_map_action({
    all = "%yank",
  }, (opts or {}).key)
end

M.term = function(opts)
  return M.make_trigger_map_action({
    vertical = "ToggleTerm direction=vertical",
    horizontal = "ToggleTerm direction=horizontal",
    toggle = "ToggleTermToggleAll",
    rename = "ToggleTermSetName",
    float = "ToggleTerm direction=float",
  }, (opts or {}).key)
end

M.spectre = function() cmd "Spectre" end

M.mason = function() cmd [[Mason]] end
M.lazy = function() cmd [[Lazy]] end
M.guest_indent = function() cmd "GuestIndent" end

return M
