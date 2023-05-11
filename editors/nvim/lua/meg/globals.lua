local api = vim.api
local fn = vim.fn
local vcmd = vim.cmd

_G.I = vim.inspect
_G.fmt = string.format
_G.L = vim.log.levels
_G.logger = require("meg.logger")

-- Global Variables
-- ===
local function get_hostname()
  local hostname = ""
  local handle = io.popen("hostname")

  if handle then
    hostname = handle:read("*l")
    handle:close()
  end

  return hostname
end

vim.g.os = vim.loop.os_uname().sysname
vim.g.is_macos = vim.g.os == "Darwin"
vim.g.is_linux = vim.g.os == "Linux"
vim.g.is_windows = vim.g.os == "Windows"
vim.g.is_work = get_hostname() == "seth-dev"

vim.g.open_command = vim.g.is_macos and "open" or "xdg-open"

vim.g.dotfiles = vim.env.DOTS or fn.expand("~/.dotfiles")
vim.g.home = os.getenv("HOME")
vim.g.vim_path = fmt("%s/.config/nvim", vim.g.home)
vim.g.nvim_path = fmt("%s/.config/nvim", vim.g.home)
vim.g.cache_path = fmt("%s/.cache/nvim", vim.g.home)
vim.g.local_state_path = fmt("%s/.local/state/nvim", vim.g.home)
vim.g.local_share_path = fmt("%s/.local/share/nvim", vim.g.home)
vim.g.icloud_path = vim.env.ICLOUD_DIR
vim.g.icloud_documents_path = vim.env.ICLOUD_DOCUMENTS_DIR
vim.g.obsidian_vault_path = vim.env.OBSIDIAN_VAULT_DIR
vim.g.notes_path = fmt("%s/_notes", vim.g.icloud_documents_path)
vim.g.neorg_path = fmt("%s/_neorg", vim.g.icloud_documents_path)
vim.g.hammerspoon_path = fmt("%s/config/hammerspoon", vim.g.dotfiles)
vim.g.hs_emmy_path = fmt("%s/Spoons/EmmyLua.spoon", vim.g.hammerspoon_path)

meg.dirs.dots = vim.g.dotfiles
meg.dirs.privates = fn.expand("$PRIVATES")
meg.dirs.code = fn.expand("$HOME/code")
meg.dirs.icloud = vim.g.icloud_path
meg.dirs.docs = fn.expand("$DOCUMENTS_DIR")
meg.dirs.org = fn.expand(meg.dirs.docs .. "/_org")
meg.dirs.zettel = fn.expand("$ZK_NOTEBOOK_DIR")
meg.dirs.zk = meg.dirs.zettel
meg.dirs.data = fmt("%s/site/", fn.stdpath("data"))
meg.dirs.cache = vim.g.home .. "/" .. ".cache" .. "/" .. "nvim" .. "/"
meg.dirs.modules = vim.g.nvim_path .. "/" .. "meg/modules"

meg.format_on_save = true
meg.diagnostics_virtual_text = true
meg.format_disabled_dirs = {
  vim.g.home .. "/format_disabled_dir_under_home",
}

meg.colorscheme = "catppuccin"
meg.external_browser = "brave open"

meg.formatter_block_list = {
  lua = false,
}

meg.server_formatting_block_list = {
  lua_ls = true,
  tsserver = true,
  clangd = true,
  pylsp = true,
}

meg.lsp_deps = {
  "bashls",
  "clangd",
  "html",
  "jsonls",
  "lua_ls",
  "pylsp",
}

meg.null_ls_deps = {
  "black",
  "clang_format",
  "prettier",
  "rustfmt",
  "shfmt",
  "stylua",
  "vint",
}

-- utils
-- ===

-- TODO:
-- https://www.reddit.com/r/neovim/comments/xv3v68/tip_nvimnotify_can_be_used_to_display_print/
-- https://github.com/kassio/dotfiles/tree/main/config/xdg/nvim/lua/my/utils

-- inspect the contents of an object very quickly
-- in your code or from the command-line:
-- @see: https://www.reddit.com/r/neovim/comments/p84iu2/useful_functions_to_explore_lua_objects/
-- USAGE:
-- in lua: P({1, 2, 3})
-- in commandline: :lua P(vim.loop)
---@vararg any
function _G.P(...)
  -- if not vim.g.debug_enabled then return end
  local objects, v = {}, nil
  for i = 1, select("#", ...) do
    v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  if pcall(require, "plenary") then
    local p_logger = logger.new({ level = "debug" })
    p_logger.info(table.concat(objects, "\n"))
  else
    print(...)
  end

  return ...
end

function _G.PT(tbl, indent)
  -- if not vim.g.debug_enabled then return end

  if not indent then
    indent = 2
  end
  for k, v in pairs(tbl) do
    local formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      _G.PT(v, indent + 1)
    elseif type(v) == "boolean" then
      print(formatting .. tostring(v))
    else
      print(formatting .. v)
    end
  end
end

function _G.dump(...)
  -- if not vim.g.debug_enabled then return end
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

_G.Path = {
  join = function(...)
    return table.concat({ ... }, "/")
  end,
  relative = function(path)
    return vim.fn.fnamemodify(path, ":~:.")
  end,
}

_G.Clipboard = {
  copy = function(str)
    vim.fn.jobstart(string.format("echo -n %q | pbcopy", str), { detach = true })
  end,
}

function meg.warn(msg, name)
  vim.notify(msg, vim.log.levels.WARN, { title = name or "nvim" })
end

function meg.error(msg, name)
  vim.notify(msg, vim.log.levels.ERROR, { title = name or "nvim" })
end

function meg.info(msg, name)
  vim.notify(msg, vim.log.levels.INFO, { title = name or "nvim" })
end

---Require a module using `pcall` and report any errors
---@param module string
---@param opts table?
---@return boolean, any
function meg.require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    if opts.message then
      result = opts.message .. "\n" .. result
    end
    vim.notify(result, L.ERROR, { title = fmt("Error requiring: %s", module) })
  end
  return ok, result
end

--- Call the given function and use `vim.notify` to notify of any errors
--- this function is a wrapper around `xpcall` which allows having a single
--- error handler for all errors
---@param msg string
---@param func function
---@param ... any
---@return boolean, any
---@overload fun(func: function, ...): boolean, any
function meg.pcall(msg, func, ...)
  local args = { ... }
  if type(msg) == "function" then
    local arg = func --[[@as any]]
    args, func, msg = { arg, unpack(args) }, msg, nil
  end
  return xpcall(func, function(err)
    msg = debug.traceback(msg and fmt("%s:\n%s", msg, err) or err)
    vim.schedule(function()
      vim.notify(msg, L.ERROR, { title = "ERROR" })
    end)
  end, unpack(args))
end

--- Call the given function and use `vim.notify` to notify of any errors
--- this function is a wrapper around `xpcall` which allows having a single
--- error handler for all errors
---@param msg string
---@param func function
---@vararg any
---@return boolean, any
---@overload fun(fun: function, ...): boolean, any
function meg.wrap_err(msg, func, ...)
  local args = { ... }
  if type(msg) == "function" then
    args, func, msg = { func, unpack(args) }, msg, nil
  end
  return xpcall(func, function(err)
    msg = msg and fmt("%s:\n%s", msg, err) or err
    vim.schedule(function()
      vim.notify(msg, L.ERROR, { title = "ERROR" })
    end)
  end, unpack(args))
end

--- @class CommandArgs
--- @field args string
--- @field fargs table
--- @field bang boolean,

---Create an nvim command
---@param name any
---@param rhs string|fun(args: CommandArgs)
---@param opts? table
function meg.command(name, rhs, opts)
  opts = opts or {}
  api.nvim_create_user_command(name, rhs, opts)
end

--[[
╭────────────────────────────────────────────────────────────────────────────╮
│  Str  │  Help page   │  Affected modes                           │  VimL   │
│────────────────────────────────────────────────────────────────────────────│
│  ''   │  mapmode-nvo │  Normal, Visual, Select, Operator-pending │  :map   │
│  'n'  │  mapmode-n   │  Normal                                   │  :nmap  │
│  'v'  │  mapmode-v   │  Visual and Select                        │  :vmap  │
│  's'  │  mapmode-s   │  Select                                   │  :smap  │
│  'x'  │  mapmode-x   │  Visual                                   │  :xmap  │
│  'o'  │  mapmode-o   │  Operator-pending                         │  :omap  │
│  '!'  │  mapmode-ic  │  Insert and Command-line                  │  :map!  │
│  'i'  │  mapmode-i   │  Insert                                   │  :imap  │
│  'l'  │  mapmode-l   │  Insert, Command-line, Lang-Arg           │  :lmap  │
│  'c'  │  mapmode-c   │  Command-line                             │  :cmap  │
│  't'  │  mapmode-t   │  Terminal                                 │  :tmap  │
╰────────────────────────────────────────────────────────────────────────────╯
--]]

---create a mapping function factory
---@param mode string
---@param o table
---@return fun(lhs: string, rhs: string|function, opts: table|nil) 'create a mapping'
local function mapper(mode, o)
  -- copy the opts table as extends will mutate the opts table passed in otherwise
  local parent_opts = vim.deepcopy(o)
  ---Create a mapping
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts table
  return function(lhs, rhs, opts)
    -- If the label is all that was passed in, set the opts automagically
    opts = type(opts) == "string" and { label = opts } or opts and vim.deepcopy(opts) or {}

    -- if not opts.has or client.server_capabilities[opts.has .. "Provider"] then
    if opts.label or opts.desc then
      local ok, wk = meg.require("which-key", { silent = true })
      if ok and wk then
        wk.register({ [lhs] = opts.label or opts.desc }, { mode = mode })
      end
      if opts.label and not opts.desc then
        opts.desc = opts.label
      end
      opts.label = nil
    end

    if rhs == nil then
      P(mode, lhs, rhs, opts, parent_opts)
    end

    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("keep", opts, parent_opts))
  end
end

local map_opts = { remap = true, silent = true }
local noremap_opts = { remap = false, silent = true }

-- TODO: https://github.com/b0o/nvim-conf/blob/main/lua/user/mappings.lua#L19-L37

for _, mode in ipairs({ "n", "x", "i", "v", "o", "t", "s", "c" }) do
  -- {
  -- n = "normal",
  -- v = "visual",
  -- s = "select",
  -- x = "visual & select",
  -- i = "insert",
  -- o = "operator",
  -- t = "terminal",
  -- c = "command",
  -- }

  -- recursive global mappings
  meg[mode .. "map"] = mapper(mode, map_opts)
  _G[mode .. "map"] = meg[mode .. "map"]
  -- non-recursive global mappings
  meg[mode .. "noremap"] = mapper(mode, noremap_opts)
  _G[mode .. "noremap"] = meg[mode .. "noremap"]
end
_G.map = vim.keymap.set

--- Validate the keys passed to meg.augroup are valid
---@param name string
---@param cmd Autocommand
local function validate_autocmd(name, cmd)
  local keys = { "event", "buffer", "pattern", "desc", "command", "group", "once", "nested" }
  local incorrect = meg.fold(function(accum, _, key)
    if not vim.tbl_contains(keys, key) then
      table.insert(accum, key)
    end
    return accum
  end, cmd, {})
  if #incorrect == 0 then
    return
  end
  vim.schedule(function()
    vim.notify("Incorrect keys: " .. table.concat(incorrect, ", "), vim.log.levels.ERROR, {
      title = fmt("Autocmd: %s", name),
    })
  end)
end

--- Convert a list or map of items into a value by iterating all it's fields and transforming
--- them with a callback
---@generic T : table
---@param callback fun(T, T, key: string | number): T
---@param list T[]
---@param accum T
---@return T
function meg.fold(callback, list, accum)
  for k, v in pairs(list) do
    accum = callback(accum, v, k)
    assert(accum ~= nil, "The accumulator must be returned on each iteration")
  end
  return accum
end

-- https://www.reddit.com/r/neovim/comments/nrz9hp/can_i_close_all_floating_windows_without_closing/h0lg5m1/
function meg.close_float_wins()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) then
      local config = vim.api.nvim_win_get_config(win)
      if config.relative ~= "" then
        vim.api.nvim_win_close(win, false)
      end
    end
  end
end

---@class Autocommand
---@field desc string
---@field event  string[] list of autocommand events
---@field pattern string[] list of autocommand patterns
---@field command string | function
---@field nested  boolean
---@field once    boolean
---@field buffer  number
---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string
---@param ... Autocommand A list of autocommands to create (variadic parameter)
---@return number
function meg.augroup(name, commands)
  assert(name ~= "User", "The name of an augroup CANNOT be User")

  local id = vim.api.nvim_create_augroup(name, { clear = true })

  for _, autocmd in ipairs(commands) do
    validate_autocmd(name, autocmd)
    local is_callback = type(autocmd.command) == "function"
    api.nvim_create_autocmd(autocmd.event, {
      group = id,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end

  return id
end

function meg.exec(c, bool)
  bool = bool or true
  api.nvim_exec(c, bool)
end

function meg.noop() end

---A terser proxy for `nvim_replace_termcodes`
---@param str string
---@return any
function meg.replace_termcodes(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

function meg.executable(e)
  return fn.executable(e) > 0
end

local function open(path)
  fn.jobstart({ vim.g.open_command, path }, { detach = true })
  vim.notify(fmt("Opening %s", path))
end

-- open URI under cursor
function meg.open_uri()
  local file = fn.expand("<cfile>")
  if fn.isdirectory(file) > 0 then
    return vim.cmd("edit " .. file)
  end
  if file:match("http[s]?://") then
    return open(file)
  end
  -- Any URI with a protocol segment
  local protocol_uri_regex = "%a*:%/%/[%a%d%#%[%]%-%%+:;!$@/?&=_.,~*()]*"
  if file:match(protocol_uri_regex) then
    return vim.cmd("norm! gf")
  end

  -- consider anything that looks like string/string a github link
  local plugin_url_regex = "[%a%d%-%.%_]*%/[%a%d%-%.%_]*"
  local link = string.match(file, plugin_url_regex)
  if link then
    return open(fmt("https://www.github.com/%s", link))
  end
  -- local Job = require("plenary.job")
  -- local uri = vim.fn.expand("<cWORD>")
  -- Job
  --   :new({
  --     "open",
  --     uri,
  --   })
  --   :sync()
end

function meg.save_and_exec()
  if vim.bo.filetype == "vim" then
    vcmd("silent! write")
    vcmd("source %")
    vim.notify("wrote and sourced vim file..", vim.log.levels.INFO, { title = "nvim" })
  elseif vim.bo.filetype == "lua" then
    vcmd("silent! write")
    vcmd("luafile %")
    vim.notify("wrote and sourced lua file..", vim.log.levels.INFO, { title = "nvim" })
  end
end

---Find an item in a list
---@generic T
---@param matcher fun(arg: T):boolean
---@param haystack T[]
---@return T
function meg.find(matcher, haystack)
  local found
  for _, needle in ipairs(haystack) do
    if matcher(needle) then
      found = needle
      break
    end
  end
  return found
end

---Check whether or not the location or quickfix list is open
---@return boolean
function meg.is_vim_list_open()
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    local location_list = fn.getloclist(0, { filewinid = 0 })
    local is_loc_list = location_list.filewinid > 0
    if vim.bo[buf].filetype == "qf" or is_loc_list then
      return true
    end
  end
  return false
end

---Determine if a value of any type is empty
---@param item any
---@return boolean
function meg.empty(item)
  if not item then
    return true
  end
  local item_type = type(item)
  if item_type == "string" then
    return item == ""
  elseif item_type == "number" then
    return item <= 0
  elseif item_type == "table" then
    return vim.tbl_isempty(item)
  end
end

function meg.get_border(hl)
  local border = {}
  for _, char in ipairs(meg.icons.border.blank) do
    table.insert(border, { char, hl or "FloatBorder" })
  end

  return border
end

function meg.showCursorHighlights()
  vim.cmd("TSHighlightCapturesUnderCursor")
  -- local ft = vim.bo.filetype
  -- local is_ts_enabled = require("nvim-treesitter.configs").is_enabled("highlight", ft)
  --   and require("nvim-treesitter.configs").is_enabled("playground", ft)
  -- if is_ts_enabled then
  --   -- require("nvim-treesitter-playground.hl-info").show_hl_captures()
  --   vim.cmd("TSHighlightCapturesUnderCursor")
  -- else
  --   local synstack = vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))
  --   local lmap = vim.fn.map(synstack, "synIDattr(v:val, \"name\")")
  --   vim.notify(vim.fn.join(vim.fn.reverse(lmap), " "))
  -- end
end

function meg.has(feature)
  return fn.has(feature) > 0
end
meg.nightly = meg.has("nvim-0.9")

--- Debounces a function on the trailing edge. Automatically
--- `schedule_wrap()`s.
---
-- @param fn (function) Function to debounce
-- @param timeout (number) Timeout in ms
-- @param first (boolean, optional) Whether to use the arguments of the first
---call to `fn` within the timeframe. Default: Use arguments of the last call.
-- @returns (function, timer) Debounced function and timer. Remember to call
---`timer:close()` at the end or you will leak memory!
function meg.debounce_trailing(func, ms, first)
  local timer = vim.loop.new_timer()
  local wrapped_fn

  if not first then
    function wrapped_fn(...)
      local argv = { ... }
      local argc = select("#", ...)

      timer:start(ms, 0, function()
        pcall(vim.schedule_wrap(func), unpack(argv, 1, argc))
      end)
    end
  else
    local argv, argc
    function wrapped_fn(...)
      argv = argv or { ... }
      argc = argc or select("#", ...)

      timer:start(ms, 0, function()
        pcall(vim.schedule_wrap(func), unpack(argv, 1, argc))
      end)
    end
  end
  return wrapped_fn, timer
end

function meg.truncate(str, width, at_tail)
  local ellipsis = "…"
  local n_ellipsis = #ellipsis

  -- HT: https://github.com/lunarmodules/Penlight/blob/master/lua/pl/stringx.lua#L771-L796
  --- Return a shortened version of a string.
  -- Fits string within w characters. Removed characters are marked with ellipsis.
  -- @string s the string
  -- @int w the maxinum size allowed
  -- @bool tail true if we want to show the end of the string (head otherwise)
  -- @usage ('1234567890'):shorten(8) == '12345...'
  -- @usage ('1234567890'):shorten(8, true) == '...67890'
  -- @usage ('1234567890'):shorten(20) == '1234567890'
  local function shorten(s, w, tail)
    if #s > w then
      if w < n_ellipsis then
        return ellipsis:sub(1, w)
      end
      if tail then
        local i = #s - w + 1 + n_ellipsis
        return ellipsis .. s:sub(i)
      else
        return s:sub(1, w - n_ellipsis) .. ellipsis
      end
    end
    return s
  end

  return shorten(str, width, at_tail)
end

function meg.tlen(t)
  local len = 0
  for _ in pairs(t) do
    len = len + 1
  end
  return len
end

--- automatically clear commandline messages after a few seconds delay
--- source: http://unix.stackexchange.com/a/613645
---@return function
function meg.clear_commandline()
  --- Track the timer object and stop any previous timers before setting
  --- a new one so that each change waits for 10secs and that 10secs is
  --- deferred each time
  local timer
  return function()
    if timer then
      timer:stop()
    end
    timer = vim.defer_fn(function()
      if fn.mode() == "n" then
        vim.cmd([[echon '']])
      end
    end, 2500)
  end
end

function meg.is_chonky(bufnr, filepath)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  filepath = filepath or vim.api.nvim_buf_get_name(bufnr)
  local is_too_long = vim.api.nvim_buf_line_count(bufnr) >= 5000
  local is_too_large = false

  local max_filesize = 50 * 1024 -- 50 KB
  local ok, stats = pcall(vim.loop.fs_stat, filepath)
  if ok and stats and stats.size > max_filesize then
    is_too_large = true
  end

  -- if is_too_long or is_too_large then P(fmt("is too long (%s) or, is too chonky (%s)", is_too_long, is_too_large)) end

  return (is_too_long or is_too_large)
end

function meg.should_disable_ts(opts)
  opts = opts or {}
  local bufnr = opts["bufnr"] or vim.api.nvim_get_current_buf()
  local filepath = opts["filepath"] or vim.api.nvim_buf_get_name(bufnr)
  local lang = opts["lang"] or vim.bo[bufnr].filetype

  local is_ignored_lang = vim.tbl_contains(meg.ts_ignored_langs, lang)
  local should_disable = meg.is_chonky(bufnr, filepath) and is_ignored_lang
  if should_disable then
    P(fmt("disabling ts highlight for %s", lang))
  end

  return should_disable
end

function meg.clear_ui()
  -- vcmd([[nnoremap <silent><ESC> :syntax sync fromstart<CR>:nohlsearch<CR>:redrawstatus!<CR><ESC> ]])
  vim.cmd("nohlsearch")
  vim.cmd("diffupdate")
  vim.cmd("syntax sync fromstart")
  meg.close_float_wins()
  vim.cmd("echo ''")
  if vim.g.enabled_plugin["cursorline"] then
    meg.blink_cursorline()
  end

  do
    local ok, mj = pcall(require, "mini.jump")
    if ok then
      mj.stop_jumping()
    end
  end

  local ok, n = meg.require("notify")
  if ok then
    n.dismiss()
  end
  meg.clear_commandline()
end

-- [ commands ] ----------------------------------------------------------------
do
  local command = meg.command
  vcmd([[
    command! -nargs=1 Rg lua require("telescope.builtin").grep_string({ search = vim.api.nvim_eval('"<args>"') })
  ]])

  command("Todo", [[noautocmd silent! grep! 'TODO\|FIXME\|BUG\|HACK' | copen]])
  command("ReloadModule", function(tbl)
    require("plenary.reload").reload_module(tbl.args)
  end, {
    nargs = 1,
  })
  command(
    "DuplicateFile",
    [[noautocmd clear | silent! execute "!cp '%:p' '%:p:h/%:t:r-copy.%:e'"<bar>redraw<bar>echo "Copied " . expand('%:t') . ' to ' . expand('%:t:r') . '-copy.' . expand('%:e')]]
  )
  command("SaveAsFile", [[noautocmd clear | :execute "saveas %:p:h/" .input('save as -> ') | :e ]])
  command("RenameFile", [[noautocmd clear | :execute "Rename " .input('rename to -> ') | :e ]])
  -- command("Rename", [[RenameFile]])
  -- command("Rename", [[lua require("genghis").renameFile()]])
  -- command("Delete", [[lua require("genghis").trashFile()]])
  command("Flash", function()
    meg.blink_cursorline()
  end)
  command("P", function(opts)
    vim.g.debug_enabled = true
    vim.cmd(fmt("lua P(%s)", opts.args))
    vim.g.debug_enabled = false
  end, { nargs = "*" })
  command("D", function(opts)
    vim.g.debug_enabled = true
    vim.cmd(fmt("lua d(%s)", opts.args))
    vim.g.debug_enabled = false
  end, { nargs = "*" })
  -- command("Noti", [[Notifications]])
  command("Noti", [[Messages | Notifications]])

  command("DBUI", function()
    vim.cmd("DotEnv")
    vim.cmd("DBUI")
  end, { nargs = "*" })

  command("CopyBranch", function()
    vim.cmd([[silent !git branch --show-current | tr -d '[:space:]' | (pbcopy || lemonade copy)]])
    vim.notify(string.format("copied to clipboard: %s", vim.fn.getreg("+")))
  end)

  command("TreeInspect", function()
    vim.treesitter.inspect_tree({
      command = fmt("botright %dvnew", math.min(math.floor(vim.o.columns * 0.25), 80)),
    })
  end)
end

return meg
