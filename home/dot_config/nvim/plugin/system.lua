-- System integration: clipboard, persistence, encoding.

local o = vim.opt

o.clipboard = "unnamedplus"

o.swapfile = false
o.backup = false
o.writebackup = false

o.undofile = true
o.undolevels = 10000

o.encoding = "utf-8"
o.fileencoding = "utf-8"

o.updatetime = 250
o.timeoutlen = 400

o.confirm = true
o.autoread = true
o.autowrite = true
