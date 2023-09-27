vim.cmd([[nnoremap <buffer> q :q<CR>]])
nnoremap("<BS>", function() require("oil").open() end, { desc = "oil: goto parent dir" })
vim.cmd([[nmap <buffer> <leader>ed :q<CR>]])
