local custom = require "meg.custom"

require "meg.manager"
require "meg.lsp"
require "meg.autocmds"
require "meg.keymaps"
require "meg.ui"

vim.cmd.colorscheme(custom.theme)
