if vim.loader then
	vim.loader.enable()
end

_G.dd = function(...)
	require("util.debug").dump(...)
end
vim.print = _G.dd

require("config.lazy")
-- local g = vim.g
--
-- vim.loader.enable()
--
-- g.mapleader = vim.keycode('<space>')
-- _G.program_ft = {
--   'bash',
--   'c',
--   'cmake',
--   'cpp',
--   'css',
--   'csv',
--   'eruby',
--   'fish',
--   'go',
--   'haml',
--   'html',
--   'javascript',
--   'javascriptreact',
--   'json',
--   'lua',
--   'markdown',
--   'python',
--   'ruby',
--   'rust',
--   'sh',
--   'typescript',
--   'typescriptreact',
--   'zig',
--   'zsh',
-- }
-- _G.is_mac = vim.uv.os_uname().sysname == 'Darwin'
--
-- -- Load Modules
-- require('core')
-- require('internal.event')
-- require('internal.completion')
--
-- -- disable_distribution_plugins
-- g.loaded_gzip = 1
-- g.loaded_tar = 1
-- g.loaded_tarPlugin = 1
-- g.loaded_zip = 1
-- g.loaded_zipPlugin = 1
-- g.loaded_getscript = 1
-- g.loaded_getscriptPlugin = 1
-- g.loaded_vimball = 1
-- g.loaded_vimballPlugin = 1
-- g.loaded_matchit = 1
-- g.loaded_matchparen = 1
-- g.loaded_2html_plugin = 1
-- g.loaded_logiPat = 1
-- g.loaded_rrhelper = 1
-- g.loaded_netrwPlugin = 1
