-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
-- Last updated: 2024-02-09
-- code: https://github.com/meaganewaller/dotfiles

if vim.g.vscode then return end

local g, fn, opt, loop, env, cmd = vim.g, vim.fn, vim.opt, vim.loop, vim.env, vim.cmd
local data = fn.stdpath("data")

package.path = package.path
  .. ";"
  .. vim.fn.expand("$HOME")
  .. "/.asdf/installs/lua/5.4.4/luarocks/share/lua/5.4/?/init.lua;"
package.path = package.path
  .. ";"
  .. vim.fn.expand("$HOME")
  .. "/.asdf/installs/lua/5.4.4/luarocks/share/lua/5.4/?.lua;"

if vim.loader then vim.loader.enable() end

g.os = loop.os_uname().sysname
g.open_command = g.os == "Darwin" and "open" and "xdg-open"

g.dotfiles = env.DOTFILES or fn.expand("~/.dotfiles")
g.vim_dir = g.dotfiles .. "/editors/nvim"
g.projects_dir = env.PROJECTS_DIR or fn.expand("~/dev")
g.work_dir = env.WORKSPACE_DIR or fn.expand("~/workspace")

g.mapleader = " "
g.maplocalleader = ","

local namespace = {
  ui = {
    winbar = { enable = false },
    tabline = { enable = true },
    statuscolumn = { enable = true },
    statusline = { enable = true },
  },
  mappings = { enable = true },
}

_G.mw = mw or namespace
_G.map = vim.keymap.set
_G.P = vim.print

require("mw.globals")
require("mw.highlights")
require("mw.ui")
require("mw.settings")

local lazypath = data .. "/lazy/lazy.nvim"
if not loop.fs_stat(lazypath) then
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  vim.notify("Installed Lazy.nvim")
end
opt.runtimepath:prepend(lazypath)

if env.NVIM then return require("lazy").setup({ { "willothy/flatten.nvim", config = true } }) end

require("lazy").setup("mw.plugins", {
  ui = { border = mw.ui.current.border },
  defaults = { lazy = true },
  change_detection = { notify = false },
  checker = {
    enabled = true,
    concurrency = 30,
    notify = false,
    frequency = 3600,
  },
  performance = {
    rtp = {
      paths = { data .. "/site" },
      disabled_plugins = { "netrw", "netrwPlugin" },
    },
  },
  dev = {
    path = g.projects_dir .. "/neovim-plugins/",
    patterns = { "meaganewaller" },
    fallback = true,
  },
})

map("n", "<Leader>pm", "<cmd>Lazy<CR>", { desc = "Manage" })

------------------------------------------------------------------------------------------------------
-- Builtin Packages
------------------------------------------------------------------------------------------------------
-- cfilter plugin allows filtering down an existing quickfix list
cmd.packadd("cfilter")
------------------------------------------------------------------------------------------------------
-- Colour Scheme {{{1
------------------------------------------------------------------------------------------------------
mw.pcall("theme failed to load because", cmd.colorscheme, "rose-pine")
--
--config = config or setmetatable({}, {
--  __index = function(self, key)
--    local modname = 'config.' .. key
--    if package.loaded[modname] then
--      return require(modname)
--    else
--      return nil
--    end
--  end
--})
--_G.config = config

--function _require(name)
--  package.loaded[name] = nil
--  return require(name)
--end

--vim.env.DOTVIM = vim.fn.expand('~/.config/nvim')

---- Configure neovim python host.
---- This can be executed lazily after entering vim, to save startup time.
--vim.schedule(function() require 'config.pynvim' end)
--require 'config.fixfnkeys'
--require 'config.compat'

---- Source plain vimrc for basic settings.
---- This should precede plugin loading via lazy.nvim.
--vim.cmd [[
--  source ~/.vimrc
--]]

---- Check neovim version
--if vim.fn.has('nvim-0.9.2') == 0 then
--  vim.cmd [[
--    echohl WarningMsg | echom 'This version of neovim is unsupported. Please upgrade to Neovim 0.9.2+ or higher.' | echohl None
--  ]]
--  vim.cmd [[ filetype plugin off ]]
--  vim.o.loadplugins = false
--  vim.o.swapfile = false
--  vim.o.shadafile = "NONE"
--  return

--elseif vim.fn.has('nvim-0.9.2') == 0 then
--  ---@type string  e.g. "NVIM v0.9.2"
--  ---@diagnostic disable-next-line: deprecated ; can be removed in nvim 0.9+
--  local nvim_version = vim.split(vim.api.nvim_command_output('version'), '\n', { trimempty = true })[1]
--  local show_warning = function()
--    local like_false = function(x) return x == nil or x == "0" or x == "" end
--    if not like_false(vim.env.DOTFILES_SUPPRESS_NEOVIM_VERSION_WARNING) then return end
--    local msg = 'Please upgrade to latest neovim (0.9.5+).\n'
--    msg = msg .. 'Support for neovim <= 0.8.x will be dropped soon.'
--    msg = msg .. '\n\n' .. string.format('Try: $ %s install neovim', vim.fn.has('mac') > 0 and 'brew' or 'dotfiles')
--    msg = msg .. '\n\n' .. ('If you cannot upgrade yet but want to suppress this warning,\n'
--                            .. 'use `export DOTFILES_SUPPRESS_NEOVIM_VERSION_WARNING=1`.')
--    vim.notify(msg, vim.log.levels.ERROR, { title = 'Deprecation Warning', timeout = 5000 })
--    vim.g.DOTFILES_DEPRECATION_CACHE = { version = nvim_version, timestamp = os.time() }
--  end
--  vim.defer_fn(function()
--    local cache = vim.g.DOTFILES_DEPRECATION_CACHE or {}
--    if cache.version ~= nvim_version or os.time() - cache.timestamp > 3600 then
--      show_warning()  -- show warning only once per hour.
--    end
--  end, 100)
--end

---- "vim --noplugin" would disable all plugins
--local noplugin = not vim.o.loadplugins
--if not noplugin then
--  -- Load all the plugins (lazy.nvim, requires nvim 0.8+)
--  -- Note: lazy.nvim alters &loadplugins by design
--  require 'config.plugins'
--end

--if noplugin then
--  return
--end

---- Source some individual rc files on startup, manually in sequence.
---- Note that many other config modules are called upon plugin loading.
---- (see each plugin spec, e.g. 'plugins/ui' and 'config/ui')
---- See nvim/lua/config/commands/init.lua
--_require 'config.keymap'
--_require 'config.commands'
--_require 'config.statuscolumn'

---- Source local-only lua configs (not git tracked)
--if vim.fn.filereadable(vim.fn.expand('~/.config/nvim/lua/config/local.lua')) > 0 then
--  require 'config.local'
--end
