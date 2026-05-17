-- Visual interface: line numbers, signs, colors, statusline basics.

local o = vim.opt

o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.colorcolumn = "80,100"
o.scrolloff = 8
o.sidescrolloff = 8

o.termguicolors = true
o.background = "dark"

o.showmode = false
o.showcmd = true
o.cmdheight = 1
o.laststatus = 3
o.pumheight = 12
o.pumblend = 10
o.winblend = 0

o.splitright = true
o.splitbelow = true
o.splitkeep = "screen"

o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }
o.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldclose = "▸" }

o.wrap = false
o.linebreak = true
o.breakindent = true

o.shortmess:append("WcCsI")
