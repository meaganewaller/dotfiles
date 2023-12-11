local u = require('config.utils')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local lazyIsInstalled = vim.loop.fs_stat(lazypath) ~= nil
if not lazyIsInstalled then
	vim.fn.system {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	}
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy.view.config').keys.hover = 'o'
require('lazy.view.config').keys.details = '<Tab>'

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lazy',
  callback = function()
    vim.keymap.set(
      'n',
      'gi',
      [[/#<CR>o``]],
      { buffer = true, remap = true, desc = "󰒲 Open next issue" }
    )
  end,
})

require('lazy').setup('plugins', {
  defaults = {
    lazy = true,
  },
  dev = {
    path = os.getenv('HOME') .. '/code/nvim-plugins',
    patterns = { 'meaganewaller' },
    fallback = true,
  },
  install = { colorscheme = { 'tokyonight', 'dawnfox', 'habamax' } },
  ui = {
    wrap = true,
    border = u.borderStyle,
    pills = false,
    size = { width = 1, height = 0.93 },
  },
  checker = {
    enabled = true,
    notify = false,
    frequency = 60 * 60 * 24,
  },
  diff = { cmd = 'browser' },
  change_detection = { notify = false },
  readme = { enabled = true },
  performance = {
    rtp = {
      -- disable unused builtin plugins from neovim
      disabled_plugins = {
        "man",
        "matchparen",
        "matchit",
        "netrw",
        "netrwPlugin",
        "gzip",
        "zip",
        "tar",
        "tarPlugin",
        "tutor",
        "health",
        "tohtml",
        "zipPlugin",
      },
    },
  },
})

local keymap = u.uniqueKeymap

local keymap = u.uniqueKeymap
keymap("n", "<leader>pp", require("lazy").sync, { desc = "󰒲 Lazy Update" })
keymap("n", "<leader>ph", require("lazy").home, { desc = "󰒲 Lazy Overview" })
keymap("n", "<leader>pi", require("lazy").install, { desc = "󰒲 Lazy Install" })

-- 5s after startup, notify if there many plugin updates
vim.defer_fn(function()
  if not require("lazy.status").has_updates() then return end
  local threshold = 15
  local numberOfUpdates = tonumber(require("lazy.status").updates():match("%d+"))
  if numberOfUpdates < threshold then return end
  local msg = ("󱧕 %s plugin updates"):format(numberOfUpdates)
  u.notify(msg, "Lazy")
end, 5000)
