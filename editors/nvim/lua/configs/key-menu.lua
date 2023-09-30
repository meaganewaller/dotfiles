local km = require("key-menu")
vim.o.timeoutlen = 500

local setkey = km.set

vim.o.timeoutlen = 300

setkey("n", "<Leader>")
setkey("n", "<LocalLeader>")
setkey("n", "[")
setkey("n", "]")
setkey("n", "g")
setkey("n", "<Leader>j", { desc = "Jump Tabs" })
setkey("n", "<Leader>p", { desc = "Plugins" })
setkey("n", "<Leader>g", { desc = "Git" })
setkey("n", "<Leader>l", { desc = "LSP" })
setkey("n", "<Leader>f", { desc = "Search" })
setkey("n", "<Leader>t", { desc = "Tabs" })
setkey("n", "<Leader>n", { desc = "Neotest" })
setkey("v", "<Leader>g", { desc = "Git" })
setkey("n", "<Leader>r", { desc = "Refactoring" })
setkey("n", "<Leader>o", { desc = "Overseer" })
