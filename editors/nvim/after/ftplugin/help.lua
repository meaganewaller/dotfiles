-- Help utilities
--

local mapper = require("meg.utils.mapper")
local nmap = mapper.nmap

if vim.api.nvim_buf_get_option(0, 'buftype') ~= 'help' then return end

-- Count the number of file windows in current tabpage.
---@return integer
local function count_windows()
	local win_count = 0
	local tab_windows = vim.api.nvim_tabpage_list_wins(0)
	for _, winnr in ipairs(tab_windows) do
		local bufnr = vim.api.nvim_win_get_buf(winnr)
		if vim.api.nvim_buf_get_option(bufnr, 'buftype') == '' then
			win_count = win_count + 1
		end
	end
	return win_count
end

vim.wo.spell = false
vim.wo.list = false

if count_windows() > 2 then
	vim.cmd.wincmd('K')
else
	vim.cmd.wincmd('L')
end

-- Key-mappings

local opts = { remap = true, buffer = 0 }
nmap({
  { "<CR>", "<C-]>", opts },
  { "<BS>", "<C-T>", opts },
  { "<Leader>o", "gO", opts }
})

opts = { silent = true, buffer = 0 }
nmap({
  { 'o', "/'[a-z]\\{2,\\}'<CR>:nohlsearch<CR>", opts},
  { 'O', "?'[a-z]\\{2,\\}'<CR>:nohlsearch<CR>", opts },
  { 'f', '/|\\S\\+|<CR>:nohlsearch<CR>', opts },
  { 'F', 'h?|\\S\\+|<CR>:nohlsearch<CR>', opts },
  { 't', '/\\*\\S\\+\\*<CR>:nohlsearch<CR>', opts },
  { 'T', 'h?\\*\\S\\+\\*<CR>:nohlsearch<CR>', opts },
})

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
	.. (vim.b.undo_ftplugin ~= nil and ' | ' or '')
	.. 'sil! nunmap <buffer> <CR>'
	.. ' | sil! nunmap <buffer> <BS>'
	.. ' | sil! nunmap <buffer> <Leader>o'
	.. ' | sil! nunmap <buffer> o'
	.. ' | sil! nunmap <buffer> O'
	.. ' | sil! nunmap <buffer> f'
	.. ' | sil! nunmap <buffer> F'
	.. ' | sil! nunmap <buffer> t'
	.. ' | sil! nunmap <buffer> T'
