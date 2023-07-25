local treesitter = vim.fn.stdpath('data') .. '/lazy/nvim-treesitter'
local orgmode = vim.fn.stdpath('data') .. '/lazy/orgmode'
vim.opt.runtimepath:append(treesitter)
vim.opt.runtimepath:append(orgmode)

---@diagnostic disable-next-line: different-requires
require('orgmode').cron(require('meg.plugins.orgmode').orgmode_config)
