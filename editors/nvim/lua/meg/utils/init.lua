local vcmd, lsp, fn = vim.cmd, vim.lsp, vim.fn
local fmt = string.format
local hl_ok, H = meg.require("meg.utils.highlights", { silent = true })

local M = {
  ext = {
    tmux = {},
    kitty = {},
    wezterm = {},
  },
  lsp = {},
  hl = {},
}
local function fileicon()
  local name = fn.bufname()
  local icon, hl
  local loaded, devicons = meg.require("nvim-web-devicons")
  if loaded then
    icon, hl = devicons.get_icon(name, fn.fnamemodify(name, ":e"), { default = true })
  end
  return icon, hl
end

function M.format_markdown(contents)
  if type(contents) ~= "table" or not vim.tbl_islist(contents) then contents = { contents } end

  local parts = {}

  for _, content in ipairs(contents) do
    if type(content) == "string" then
      table.insert(parts, ("```\n%s\n```"):format(content))
    elseif content.language then
      table.insert(parts, ("```%s\n%s\n```"):format(content.language, content.value))
    elseif content.kind == "markdown" then
      table.insert(parts, content.value)
    elseif content.kind == "plaintext" then
      table.insert(parts, ("```\n%s\n```"):format(content.value))
    end
  end

  return vim.split(table.concat(parts, "\n"), "\n")
end

function M.ext.title_string()
  if not hl_ok then return end
  local dir = fn.fnamemodify(fn.getcwd(), ":t")
  local icon, hl = fileicon()
  if not hl then return (icon or "") .. " " end
  -- return fmt("%s %s ", dir, icon)
  local has_tmux = vim.env.TMUX ~= nil
  return has_tmux and fmt("%s %s ", dir, icon) or dir .. " " .. icon
  -- return has_tmux and fmt("%s #[fg=%s]%s ", dir, meg.colors().Normal.fg.hex, icon) or dir .. " " .. icon
  -- return has_tmux and fmt("%s #[fg=%s]%s ", dir, H.get_hl(hl, "fg"), icon) or dir .. " " .. icon
  -- return fmt("%s #[fg=%s]%s ", dir, H.get_hl(hl, "fg"), icon)
end

--- Get the color of the current vim background and update tmux accordingly
---@param reset boolean?
function M.ext.tmux.set_statusline(reset)
  if not hl_ok then return end
  local hl = reset and "Normal" or "MsgArea"
  local bg = H.get_hl(hl, "bg")
  -- TODO: we should correctly derive the previous bg value
  fn.jobstart(fmt("tmux set-option -g status-style bg=%s", bg))
end

--- Displays a message in the tmux status-line
---@param msg string?
function M.ext.tmux.display_message(msg)
  if not msg then return end
  fn.jobstart(fmt("tmux display-message '%s'", msg))
end

function M.ext.tmux.set_popup_colorscheme()
  if not hl_ok then return end
  local bg = H.get_hl("Background", "bg")
end

function M.ext.kitty.set_background()
  if not hl_ok then return end
  if vim.env.KITTY_LISTEN_ON then
    local bg = H.get_hl("MsgArea", "bg")
    fn.jobstart(fmt("kitty @ --to %s set-colors background=%s", vim.env.KITTY_LISTEN_ON, bg))
  end
end

---Reset the kitty terminal colors
function M.ext.kitty.clear_background()
  if not hl_ok then return end
  if vim.env.KITTY_LISTEN_ON then
    local bg = require("meg.lush_theme.colors").bg0
    -- local bg = H.get_hl("Normal", "bg")
    -- this is intentionally synchronous so it has time to execute fully
    fn.system(fmt("kitty @ --to %s set-colors background=%s", vim.env.KITTY_LISTEN_ON, bg))
  end
end

-- REF:
-- https://www.reddit.com/r/neovim/comments/xn1q75/comment/iprdrpr
-- https://github.com/folke/zen-mode.nvim/pull/61
-- https://github.com/wez/wezterm/discussions/3211
-- https://github.com/wez/wezterm/issues/2979#issuecomment-1447519267
function M.ext.wezterm.toggle_screen_share_mode(enabled)
  local mode = enabled and "on" or "off"
  -- fn.jobstart(fmt("wezterm-cli SCREEN_SHARE_MODE %s", mode))

  local stdout = vim.loop.new_tty(1, false)
  if vim.env.TMUX then
    -- just wezterm: \033]1337;SetUserVar=%s=%s\007
    -- from zen-mode example: \x1b]1337;SetUserVar=%s=%s\b
    -- \033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\
    stdout:write(
    ("\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\b"):format(
    "SCREEN_SHARE_MODE",
    vim.fn.system({ "base64" }, tostring(mode))
    )
    )
    dd("doing a thing with stdout in tmux")
    -- stdout:write(('\x1b]1337;SetUserVar=%s=%s\b'):format('SCREEN_SHARE_MODE', vim.fn.system({ 'base64' }, tostring(enabled))))
    -- else
    --   stdout:write(
    --     ("\x1b]1337;SetUserVar=%s=%s\b"):format("SCREEN_SHARE_MODE", vim.fn.system({ "base64" }, tostring(mode)))
    --   )
  end
  -- vim.cmd([[redraw]])
end

function M.check_back_space()
  local col = fn.col(".") - 1
  return col == 0 or fn.getline("."):sub(col, col):match("%s") ~= nil
end

function M.root_has_file(name)
  local cwd = vim.loop.cwd()
  local lsputil = require("lspconfig.util")
  return lsputil.path.exists(lsputil.path.join(cwd, name)), lsputil.path.join(cwd, name)
end

-- # [ lsp_commands ] ----------------------------------------------------------------
local lsputil = require("lspconfig.util")

local function dir_has_file(dir, name)
  return lsputil.path.exists(lsputil.path.join(dir, name)), lsputil.path.join(dir, name)
end

local function workspace_root()
  local cwd = vim.loop.cwd()

  if dir_has_file(cwd, "compose.yml") or dir_has_file(cwd, "docker-compose.yml") then return cwd end

  local function cb(dir, _) return dir_has_file(dir, "compose.yml") or dir_has_file(dir, "docker-compose.yml") end

  local root, _ = lsputil.path.traverse_parents(cwd, cb)
  return root
end

--- Build the language server command.
-- @param opts options
-- @param opts.locations table Locations to search relative to the workspace root
-- @param opts.fallback_dir string Path to use if locations don't contain the binary
-- @return a string containing the command
local function language_server_cmd(opts)
  opts = opts or {}
  local fallback_dir = opts.fallback_dir
  local locations = opts.locations or {}
  local cmd = vim.fn.expand(fallback_dir)

  local root = workspace_root()
  if not root then root = vim.loop.cwd() end
  -- P(fmt("root: %s", root))

  for _, location in ipairs(locations) do
    local exists, dir = dir_has_file(root, location)
    if exists then
      -- logger.fmt_debug("language_server_cmd: %s", vim.fn.expand(dir))
      cmd = vim.fn.expand(dir)
    end
  end

  -- P(fmt("cmd: %s", cmd))
  return cmd
end

--- Build the elixir-ls command.
-- @param opts options
-- @param opts.fallback_dir string Path to use if locations don't contain the binary
-- @param opts.debugger boolean Whether this is a debug elixirls_cmd binary or not
function M.lsp.elixirls_cmd(opts)
  opts = opts or {}

  local cmd = "language_server.sh"
  local debugger = opts["debugger"] or false

  if debugger then cmd = "debugger.sh" end

  opts = vim.tbl_deep_extend("force", opts, {
    locations = {
      ".elixir-ls-release/" .. cmd,
      ".elixir_ls/release/" .. cmd,
    },
  })

  opts.fallback_dir = string.format("%s/lsp/elixir-ls/%s", vim.env.XDG_DATA_HOME, cmd)

  -- P(fmt("opts: %s", I(opts)))

  return language_server_cmd(opts)
end

function M.get_open_filelist(cwd)
  local Path = require("plenary.path")
  -- local flatten = vim.tbl_flatten
  local filter = vim.tbl_filter

  cwd = cwd or vim.loop.cwd()

  local bufnrs = filter(function(b)
    if 1 ~= vim.fn.buflisted(b) then return false end
    return true
  end, vim.api.nvim_list_bufs())
  if not next(bufnrs) then return end

  local filelist = {}
  for _, bufnr in ipairs(bufnrs) do
    local file = vim.api.nvim_buf_get_name(bufnr)
    table.insert(filelist, Path:new(file):make_relative(cwd))
  end
  return filelist
end

function M.hl.get(name)
  local ok, data = pcall(vim.api.nvim_get_hl_by_name, name, true)

  if not ok then
    vim.notify(fmt("Failed to find highlight by name \"%s\"", name), vim.log.levels.ERROR, { title = "nvim" })
    return {}
  end

  return data
end

function M.hl.set(group, color)
  local ok, msg = pcall(vim.api.nvim_set_hl, 0, group, color)

  if not ok then
    vim.notify(
    fmt("Failed to set highlight (%s): group %s | color: %s", msg, group, I(color)),
    vim.log.levels.ERROR,
    { title = "nvim" }
    )
  end
end

function M.hl.extend(target, source, opts) M.hl.set(target, vim.tbl_extend("force", M.hl.get(source), opts or {})) end

local function tbl_length(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end

-- https://github.com/ibhagwan/fzf-lua/blob/455744b9b2d2cce50350647253a69c7bed86b25f/lua/fzf-lua/utils.lua#L401
function M.get_visual_selection()
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "" then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
    if mode == "V" then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
    -- exit visual mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  end
  -- swap vars if needed
  if cerow < csrow then
    csrow, cerow = cerow, csrow
  end
  if cecol < cscol then
    cscol, cecol = cecol, cscol
  end
  local lines = vim.fn.getline(csrow, cerow)
  -- local n = cerow-csrow+1
  local n = tbl_length(lines)
  if n <= 0 then return "" end
  lines[n] = string.sub(lines[n], 1, cecol)
  lines[1] = string.sub(lines[1], cscol)
  return table.concat(lines, "\n")
end
-- OR --------------------------------------------------------------------------
-- REF: https://github.com/fdschmidt93/dotfiles/blob/master/nvim/.config/nvim/lua/fds/utils/init.lua
function M.get_selection()
  local rv = vim.fn.getreg("v")
  local rt = vim.fn.getregtype("v")
  vim.cmd([[noautocmd silent normal! "vy]])
  local selection = vim.fn.getreg("v")
  vim.fn.setreg("v", rv, rt)
  return vim.split(selection, "\n")
end

---@return string
function M.get_root()
  local path = vim.loop.fs_realpath(vim.api.nvim_buf_get_name(0))
  ---@type string[]
  local roots = {}
  if path ~= "" then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws) return vim.uri_to_fname(ws.uri) end, workspace)
      or client.config.root_dir and { client.config.root_dir }
      or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then roots[#roots + 1] = r end
      end
    end
  end
  ---@type string?
  local root = roots[1]
  if not root then
    path = path == "" and vim.loop.cwd() or vim.fs.dirname(path)
    ---@type string?
    root = vim.fs.find({ ".git" }, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

return M
--local M = {}
--
--function M.t(str)
--  return vim.api.nvim_replace_termcodes(str, true, true, true)
--end
--
-----@param range? string
-----@return boolean
--function M.has_version(range)
--	local Semver = require('lazy.manage.semver')
--	return Semver.range(range or M.lazy_version)
--		:matches(require('lazy.core.config').version or '0.0.0')
--end
--
--function M.exists(list, val)
--  local set = {}
--  for _, l in ipairs(list) do
--    set[l] = true
--  end
--  return set[val]
--end
--
--function M.log(msg, hl, name)
--  name = name or "Neovim"
--  hl = hl or "Todo"
--  vim.api.nvim_echo({ { name .. ": ", hl }, { msg } }, true, {})
--end
--
--
--M.did_init = false
--function M.init()
--  if not M.did_init then
--    M.did_init = true
--    require('meg.utils').lazy_notify()
--    require('meg.utils').load('options')
--
--    local Plugin = require('lazy.core.plugin')
--    local add = Plugin.Spec.add
--    ---@diagnostic disable-next-line: duplicate-set-field
--    Plugin.Spec.add = function(self, plugin, ...)
--      if type(plugin) == 'table' and M.renames[plugin[1]] then
--        plugin[1] = M.renames[plugin[1]]
--      end
--      return add(self, plugin, ...)
--    end
--  end
--end
--
-----@type MegVimConfig
--local options
--
---- Load meg and user config files.
-----@param user_opts table|nil
--function M.setup(user_opts)
--  if not M.did_init then
--    M.init()
--  end
--  options = vim.tbl_deep_extend('force', defaults, user_opts or {})
--  if not M.has_version(8) then
--    require('lazy.core.util').error(
--      string.format(
--        '**lazy.nvim** version %s is required.\n Please upgrade **lazy.nvim**',
--        M.lazy_version
--      )
--    )
--    M.error('Exiting')
--  end
--
--  local ok, user_setup = pcall(require, 'config.setup')
--  if ok and user_setup.override then
--    options = vim.tbl_deep_extend('force', options, user_setup.override())
--  end
--  for feat_name, feat_val in pairs(options.features) do
--    vim.g['meg_' .. feat_name] = feat_val
--  end
--
--  M.load('autocmds')
--  M.load('keymaps')
--
--  require('lazy.core.util').try(function()
--    if type(MegVim.colorscheme) == 'function' then
--      MegVim.colorscheme()
--    elseif #MegVim.colorscheme > 0 then
--      vim.cmd.colorscheme(MegVim.colorscheme)
--    end
--  end, {
--  	msg = 'Could not load your colorscheme',
--		on_error = function(msg)
--			require('lazy.core.util').error(msg)
--			vim.cmd.colorscheme('habamax')
--		end,
--  })
--end
--
--
--
--function M.warn(msg, name)
--  vim.notify(msg, vim.log.levels.WARN, { title = name })
--end
--
--function M.error(msg, name)
--  vim.notify(msg, vim.log.levels.ERROR, { title = name })
--end
--
--function M.info(msg, name)
--  vim.notify(msg, vim.log.levels.INFO, { title = name })
--end
--
--function M.is_empty(s)
--  return s == nil or s == ""
--end
--
--function M.get_buf_option(opt)
--  local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
--  if not status_ok then
--    return nil
--  else
--    return buf_option
--  end
--end
--
--function M.quit()
--  local bufnr = vim.api.nvim_get_current_buf()
--  local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
--  if modified then
--    vim.ui.input({
--      prompt = "You have unsaved changes. Quit anyway? (y/n) ",
--    }, function(input)
--        if input == "y" then
--          vim.cmd "q!"
--        end
--      end)
--  else
--    vim.cmd "q!"
--  end
--end
--
--function M.get_repo_name()
--  if
--    #vim.api.nvim_list_tabpages() > 1 and vim.fn.trim(vim.fn.system "git rev-parse --is-inside-work-tree") == "true"
--  then
--    return vim.fn.trim(vim.fn.system "basename `git rev-parse --show-toplevel`")
--  end
--  return ""
--end
--
--function M.plugin_opts(name)
--  local plugin = require("lazy.core.config").plugins[name]
--  if not plugin then return {} end
--  local Plugin = require('lazy.core.plugin')
--  return Plugin.values(plugin, 'opts', false)
--end
--
-----@param name "autocmds" | "options" | "keymaps"
--function M.load(name)
--  local Util = require('lazy.core.util')
--  local function _load(mod)
--    Util.try(function()
--      require(mod)
--    end, {
--      msg = 'Failed loading ' .. mod,
--      on_error = function(msg)
--        local info = require('lazy.core.cache').find(mod)
--        if info == nil or (type(info) == 'table' and #info == 0) then
--          return
--        end
--        Util.error(msg)
--      end,
--    })
--  end
--
--  if MegVim.defaults[name] or name == 'options' then
--    _load('meg.config.' .. name)
--  end
--  if vim.bo.filetype == 'lazy' then
--    vim.cmd([[do VimResized]])
--  end
--end
--
--function M.ensure_lazy()
--  local lazypath = M.path_join(vim.fn.stdpath('data'), 'lazy', 'lazy.nvim')
--  if not vim.loop.fs_stat(lazypath) then
--    print('Installing lazy.nvim…')
--    vim.fn.system({
--      'git',
--      'clone',
--      '--filter=blob:none',
--      '--branch=stable',
--      'https://github.com/folke/lazy.nvim.git',
--      lazypath,
--    })
--  end
--  vim.opt.rtp:prepend(lazypath)
--end
--
--function M.lazy_notify()
--  local notifs = {}
--  local function temp(...)
--    table.insert(notifs, vim.F.pack_len(...))
--  end
--
--  local orig = vim.notify
--  vim.notify = temp
--
--  local timer = vim.loop.new_timer()
--  local check = vim.loop.new_check()
--
--  local replay = function()
--    timer:stop()
--    check:stop()
--    if vim.notify == temp then
--      vim.notify = orig -- put back the original notify if needed
--    end
--    vim.schedule(function()
--      ---@diagnostic disable-next-line: no-unknown
--      for _, notif in ipairs(notifs) do
--        vim.notify(vim.F.unpack_len(notif))
--      end
--    end)
--  end
--
--  -- wait till vim.notify has been replaced
--  check:start(function()
--    if vim.notify ~= temp then
--      replay()
--    end
--  end)
--  -- or if it took more than 500ms, then something went wrong
--  timer:start(500, 0, replay)
--end
--
---- Join paths.
-----@private
--M.path_join = function(...)
--	return table.concat({ ... }, M.path_sep)
--end
--
---- Variable holds OS directory separator.
-----@private
--M.path_sep = (function()
--  if jit then
--    local os = string.lower(jit.os)
--    if os ~= 'windows' then
--      return '/'
--    else
--      return '\\'
--    end
--  else
--    return package.config:sub(1, 1)
--  end
--end)()
--
--return M
---- function M.nvim_version(val)
----   local version = (vim.version().major .. "." .. vim.version().minor) + 0.0
----   val = val or 0.7
----   if version >= val then
----     return true
----   else
----     return false
----   end
---- end
----
---- function M.nvim_nightly()
----   return M.nvim_version(0.7)
---- end
--
---- local M = {}
---- local fn = vim.fn
----
---- function M.is_latest()
----   return vim.version().minor <= 8
---- end
----
---- ---check whether executable is callable
---- ---@param name string name of executable
---- ---@return boolean
---- function M.executable(name)
----    return fn.executable(name) == 1
---- end
----
---- ---check whether a feature exists in Nvim
---- ---@param feat string the feature name, like `nvim-0.7` or `unix`
---- ---@return boolean
---- function M.has(feat)
----   return fn.has(feat) == 1
---- end
----
---- ---print vim.inspect output to a popup window/buffer
---- ---@param input any input can by anything that vim.inspect is able to parse
---- ---@param yank boolean|nil wheather to copy the ouput to clipboard
---- ---@param ft string filetype (default `lua`)
---- ---@param open_split boolean|nil whether to use popup window
---- ---@return nil
---- function M.inspect(input, yank, ft, open_split)
----   local popup_ok, Popup = pcall(require, 'nui.popup')
----   local split_ok, Split = pcall(require, 'nui.split')
----
----   if input == nil then
----     vim.notify('No input provided', vim.log.levels.WARN, { title = 'nvim-config' })
----     return
----   end
----   if not popup_ok or not split_ok then
----     vim.notify("Failed to load 'nui' modules", vim.log.levels.ERROR, { title = 'nvim-config' })
----     return
----   end
----
----   open_split = (open_split == nil) and false or open_split
----   yank = (yank == nil) and false or yank
----   ft = (ft == nil) and 'lua' or ft
----
----   local output = vim.inspect(input)
----   local component
----
----   if open_split then
----     component = Split({
----       enter = true,
----       relative = 'win',
----       position = 'bottom',
----       size = '20%',
----       buf_options = { modifiable = true, readonly = false, filetype = ft },
----     })
----   else
----     component = Popup({
----       enter = true,
----       focusable = true,
----       border = { style = 'rounded' },
----       position = '50%',
----       size = { width = '80%', height = '60%' },
----       buf_options = { modifiable = true, readonly = false, filetype = ft },
----     })
----   end
----
----   ---@diagnostic disable-next-line: param-type-mismatch
----   vim.defer_fn(function()
----     component:mount()
----
----     component:map('n', 'q', function()
----       component:unmount()
----     end, { noremap = true })
----
----     component:on({ 'BufLeave', 'BufDelete', 'BufWinLeave' }, function()
----       vim.schedule(function()
----         component:unmount()
----       end)
----     end, { once = true })
----
----     vim.api.nvim_buf_set_lines(component.bufnr, 0, 1, false, vim.split(output, '\n', {}))
----
----     if yank then
----       vim.cmd(component.bufnr .. 'b +%y')
----     end
----     ---@diagnostic disable-next-line: param-type-mismatch
----   end, 750)
---- end
----
---- function M.file_exists(path)
----   local f = io.open(path, "r")
----   if f ~= nil then io.close(f) return true else return false end
---- end
----
---- function M.termcode(str)
----   return vim.api.nvim_replace_termcodes(str, true, true, true)
---- end
----
---- function M.get_relative_fname()
----   local fname = vim.fn.expand('%:p')
----   return fname:gsub(vim.fn.getcwd() .. '/', '')
---- end
----
---- function M.get_relative_gitpath()
----   local fpath = vim.fn.expand('%:h')
----   local fname = vim.fn.expand('%:t')
----   local gitpath = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
----   local relative_gitpath = fpath:gsub(gitpath, '') .. '/' .. fname
----
----   return relative_gitpath
---- end
----
---- function M.sleep(n)
----   os.execute("sleep " .. tonumber(n))
---- end
----
---- function M.toggle_quicklist()
----   if fn.empty(fn.filter(fn.getwininfo(), 'v:val.quickfix')) == 1 then
----     vim.cmd('copen')
----   else
----     vim.cmd('cclose')
----   end
---- end
----
---- function M.cmd(str)
----   return '<cmd>' .. str .. '<CR>'
---- end
----
---- function M.starts_with()
----   return str:sub(1, #start) == start
---- end
----
---- function M.end_with()
----   return ending == "" or str:sub(- #ending) == ending
---- end
----
---- function M.split(s, delimiter)
----   local result = {}
----   for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
----     table.insert(result, match)
----   end
----
----   return result
---- end
----
---- function M.handle_job_data(data)
----   if not data then
----     return nil
----   end
----   if data[#data] == "" then
----     table.remove(data, #data)
----   end
----   if #data < 1 then
----     return nil
----   end
----   return data
---- end
----
---- function M.log(message, title)
----   require('notify')(message, "info", { title = title or "Info" })
---- end
----
---- function M.warnlog(message, title)
----   require('notify')(message, "warn", { title = title or "Warning" })
---- end
----
---- function M.errorlog(message, title)
----   require('notify')(message, "error", { title = title or "Error" })
---- end
----
---- function M.jobstart(cmd, on_finish)
----   local has_error = false
----   local lines = {}
----
----   local function on_event(_, data, event)
----     if event == "stdout" then
----       data = M.handle_job_data(data)
----       if not data then
----         return
----       end
----
----       for i = 1, #data do
----         table.insert(lines, data[i])
----       end
----     elseif event == "stderr" then
----       data = M.handle_job_data(data)
----       if not data then
----         return
----       end
----
----       has_error = true
----       local error_message = ""
----       for _, line in ipairs(data) do
----         error_message = error_message .. line
----       end
----       M.log("Error during running a job: " .. error_message)
----     elseif event == "exit" then
----       if not has_error then
----         on_finish(lines)
----       end
----     end
----   end
----
----   vim.fn.jobstart(cmd, {
----     on_stderr = on_event,
----     on_stdout = on_event,
----     on_exit = on_event,
----     stdout_buffered = true,
----     stderr_buffered = true,
----   })
---- end
----
---- function M.remove_whitespaces(string)
----   return string:gsub("%s+", "")
---- end
----
---- function M.add_whitespaces(number)
----   return string.rep(" ", number)
---- end
----
---- function M.map(modes, lhs, rhs, opts)
----   opts = opts or {}
----   opts.noremap = opts.noremap == nil and true or opts.noremap
----   if type(modes) == 'string' then
----     modes = { modes }
----   end
----   for _, mode in ipairs(modes) do
----     if type(rhs) == 'string' then
----       vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
----     else
----       opts.callback = rhs
----       vim.api.nvim_set_keymap(mode, lhs, '', opts)
----     end
----   end
---- end
----
---- function M.read_json_file(filename)
----   local Path = require 'plenary.path'
----
----   local path = Path:new(filename)
----   if not path:exists() then
----     return nil
----   end
----
----   local json_contents = path:read()
----   local json = vim.fn.json_decode(json_contents)
----
----   return json
---- end
----
---- function M.read_gemfile()
----   local Path = require 'plenary.path'
----
----   local root_path = vim.fn.getcwd()
----   local gemfile = Path:new("Gemfile")
----  -- local gemfile = vim.fn.split(Path:new("Gemfile"):read(), "\n")
----   local parsed_gems = { "All" }
----
----   if not gemfile:exists() then
----     return nil
----   end
----
----   local gemfile_contents = vim.fn.split(gemfile:read(), "\n")
----
----   for _, gem in pairs(gemfile_contents) do
----     if string.match(gem, "^gem") then
----       local parsed_gem = string.match(gem, 'gem%s+"([^"]+)')
----       table.insert(parsed_gems, parsed_gem)
----     end
----   end
----
----   return parsed_gems
---- end
----
---- function M.read_package_json()
----   return M.read_json_file 'package.json'
---- end
----
---- ---Check if the given NPM package is installed in the current project.
---- ---@param package string
---- ---@return boolean
---- function M.is_npm_package_installed(package)
----   local package_json = M.read_package_json()
----   if not package_json then
----     return false
----   end
----
----   if package_json.dependencies and package_json.dependencies[package] then
----     return true
----   end
----
----   if package_json.devDependencies and package_json.devDependencies[package] then
----     return true
----   end
----
----   return false
---- end
----
---- function M.get_gem_list()
----   return M.read_gemfile()
---- end
----
---- function M.is_gem_installed(gem)
----   local gem_list = M.get_gem_list()
----   if not gem_list then
----     return false
----   end
----
----   P(gem_list)
----
----   if gem_list[gem] then
----     return true
----   end
----
----   return false
---- end
----
---- return M
