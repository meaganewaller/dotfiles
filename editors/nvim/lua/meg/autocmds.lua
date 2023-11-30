local utils = require "meg.utils"

utils.noremap("n", "<C-n>", ":bn<cr>", "next buffer")
utils.noremap("n", "<c-p>", ":bp<cr>", "previous buffer")
utils.noremap("n", "<c-x>", ":bd<cr>", "close buffer")

utils.noremap("n", "<Leader><tab>l", "<cmd>tablast<cr>", "Last Tab")
utils.noremap("n", "<leader><tab>f", "<cmd>tabfirst<cr>", "First Tab")
utils.noremap("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", "New Tab")
utils.noremap("n", "<leader><tab>]", "<cmd>tabnext<cr>", "Next Tab")
utils.noremap("n", "<leader><tab>d", "<cmd>tabclose<cr>", "Close Tab")
utils.noremap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", "Previous Tab")

utils.noremap("n", "<LocalLeader>fj", ":%!jq .<cr>", "jq format")
utils.noremap("n", "<esc><esc>", ":nohlsearch<cr>", "remove highlighting", { silent = true })
utils.cmd("Nows", ":%s/\\s\\+$//e", { desc = "Remove trailing whitespace" })
utils.cmd("Nobl", "g/^\\s*$/d", { desc = "remove blank lines" })
utils.cmd("Sp", "setlocal spell! spell?", { desc = "toggle spell check" })
utils.noremap("n", "<Leader>ts", ":Sp<cr>", "toggle spell check")

utils.noremap("n", "<a-left>", "0", "ios home key")
utils.noremap("i", "<a-left>", "0", "ios home key")

utils.cmd("Tail", 'set autoread | au CursorHold * checktime | call feedkeys("G")', { desc = 'pseudo tail functionality' })

-- make current buffer executable
utils.cmd("Chmodx", "!chmod a+x %", { desc = "make current buffer executable" })
utils.noremap("n", "<leader>x", ":Chmodx<cr>", "chmod +x buffer")


-- fix syntax highlighting
utils.cmd("FixSyntax", "syntax sync fromstart", { desc = "reload syntax highlighting" })

-- vertical term
utils.cmd("T", ":vs | :set nu! | :term", { desc = "vertical terminal" })

-- the worst place in the universe
utils.noremap("n", "Q", "<nop>", "")

-- move blocks
utils.noremap("v", "J", ":m '>+1<CR>gv=gv", "move block up")
utils.noremap("v", "K", ":m '<-2<CR>gv=gv", "move block down")

-- focus scrolling
utils.noremap("n", "<C-j>", "<C-d>zz", "scroll down")
utils.noremap("n", "<C-u>", "<C-u>zz", "scroll up")

-- focus highlight searches
utils.noremap("n", "n", "nzzzv", "next match")
utils.noremap("n", "N", "Nzzzv", "prev match")

-- remove trailing whitespaces and ^M chars
utils.autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	callback = function(_)
		local save_cursor = vim.fn.getpos(".")
		vim.cmd [[%s/\s\+$//e]]
		vim.fn.setpos(".", save_cursor)
	end,
})

utils.autocmd("BufWritePre", {
  pattern = "*",
  command = "call mkdir(expand('<afile>:p:h'), 'p')",
}, { desc = "create parent directories on save" })
