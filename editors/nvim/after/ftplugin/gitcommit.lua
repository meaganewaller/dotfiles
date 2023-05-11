local opt = vim.opt_local

opt.list = false
opt.number = false
opt.relativenumber = false
opt.cursorline = false
opt.list = false
opt.spell = true
opt.spelllang = "en_us"
opt.colorcolumn = "50,72"

vim.fn.matchaddpos("DiagnosticVirtualTextError", { { 1, 50, 10000 } })

vim.cmd([[exec 'norm gg']])
if vim.fn.prevnonblank(".") ~= vim.fn.line(".") then vim.cmd([[startinsert]]) end

require("cmp").setup.buffer {
  sources = require("cmp").config.sources({ { name = "conventionalcommits" } }, { { name = "buffer" } }),
}
