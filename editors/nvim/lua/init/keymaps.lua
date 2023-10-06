-- Define options for key mappings
local term_opts = { silent = true }
local opts = { noremap = true, silent = true }

-- Set key mappings
local keymap = vim.api.nvim_set_keymap

-- General Key Mappings --

-- Disable Space as a leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Window Navigation Key Mappings --

-- Move between windows using Ctrl + direction keys
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize windows using Ctrl + arrow keys
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer Navigation Key Mappings --

-- Navigate between buffers using Shift + h and Shift + l
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Buffer next" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Buffer previous" })

-- Tab Navigation Key Mappings --

-- Close current tab
keymap("n", "<Leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })

-- Move tabs left and right
keymap("n", "<Leader>th", "<cmd>-tabmove<cr>", { desc = "Move tab left" })
keymap("n", "<Leader>tl", "<cmd>+tabmove<cr>", { desc = "Move tab right" })

-- Switch between tabs
keymap("n", "<Leader>tj", "<cmd>tabnext<CR>", { desc = "Next tab" })
keymap("n", "<Leader>tk", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- Move current buffer to a new tab
keymap("n", "<Leader>tt", "<cmd>tab sb %<cr>", { desc = "Move buffer to a new tab" })

-- Alt + Arrow keys for tab navigation
keymap("n", "<A-l>", ":tabnext<CR>", { desc = "Tab next" })
keymap("n", "<A-h>", ":tabprevious<CR>", { desc = "Tab previous" })

-- Text Manipulation Key Mappings --

-- Move lines up and down in normal mode using Alt + Arrow keys
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==", opts)

-- Open file under cursor in system default application
keymap("n", "gx", [[:silent execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>]], opts)

-- Use GrepAppCursorLine and GrepAppClipboard for text searching
keymap("n", "gX", "<cmd>GrepAppCursorLine<cr>", opts)
keymap("n", "gy", "<cmd>GrepAppClipboard<cr>", opts)

-- Run 'gtd' command for Git actions
keymap("n", "gf", "<cmd>lua require('gtd').exec({ command = 'edit' })<cr>", opts)

-- Text Substitution Key Mappings --

-- Operator-pending and visual mode mappings for substitution
keymap("n", "su", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
keymap("x", "su", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })

-- Exchange characters under the cursor with X key in normal and visual modes
keymap("n", "X", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
keymap("x", "X", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })

-- Treesitter Key Mappings --

-- Trigger the NodeAction command from Treesitter
keymap("n", "<A-n>", ":NodeAction<cr>", opts)

-- Yanky Key Mappings --

-- Yank key mappings for copying and pasting text
keymap("n", "p", "<Plug>(YankyPutAfter)", opts)
keymap("n", "P", "<Plug>(YankyPutBefore)", opts)
keymap("n", "gp", "<Plug>(YankyGPutAfter)", opts)
keymap("n", "gP", "<Plug>(YankyGPutBefore)", opts)

-- Key mappings for cycling through the yank-ring
keymap("n", "<C-n>", "<Plug>(YankyCycleForward)", opts)
keymap("n", "<C-p>", "<Plug>(YankyCycleBackward)", opts)

-- Key mapping to yank and preserve cut position
keymap("n", "y", "<Plug>(YankyYank)", opts)

-- Special put moves for indenting and filtering yanked text
keymap("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", opts)
keymap("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", opts)
keymap("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)", opts)
keymap("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)", opts)
keymap("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)", opts)
keymap("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", opts)
keymap("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", opts)
keymap("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", opts)
keymap("n", "=p", "<Plug>(YankyPutAfterFilter)", opts)
keymap("n", "=P", "<Plug>(YankyPutBeforeFilter)", opts)

-- Unimpaired Key Mappings --

-- Key mappings for navigating files and quickfix list
keymap("n", "[A", ":first<cr>", opts)
keymap("n", "]A", ":last<cr>", opts)
keymap("n", "[B", ":bfirst<cr>", opts)
keymap("n", "]B", ":blast<cr>", opts)
keymap("n", "[l", ":lprevious<cr>", opts)
keymap("n", "]l", ":lnext<cr>", opts)
keymap("n", "[L", ":lfirst<cr>", opts)
keymap("n", "]L", ":llast<cr>", opts)
keymap("n", "[<C-L>", ":lpfile<cr>", opts)
keymap("n", "]<C-L>", ":lnfile<cr>", opts)
keymap("n", "[q", ":cprevious<cr>", opts)
keymap("n", "]q", ":cnext<cr>", opts)
keymap("n", "[Q", ":cfirst<cr>", opts)
keymap("n", "]Q", ":clast<cr>", opts)
keymap("n", "[<C-Q>", ":cpfile<cr>", opts)
keymap("n", "]<C-Q>", ":cnfile<cr>", opts)
keymap("n", "[t", ":tprevious<cr>", opts)
keymap("n", "]t", ":tnext<cr>", opts)
keymap("n", "[T", ":tfirst<cr>", opts)
keymap("n", "]T", ":tlast<cr>", opts)
keymap("n", "[<C-T>", ":ptprevious<cr>", opts)
keymap("n", "]<C-T>", ":ptnext<cr>", opts)

-- Gitsign Key Mappings --

-- Key mappings for Git actions using gitsigns and neogit
keymap("n", "<Leader>gg", "<cmd>lua require('neogit').open({ kind = 'split' })<cr>", { desc = "Neogit" })
keymap("n", "<Leader>gj", "<cmd>lua require('gitsigns').next_hunk()<cr>", { desc = "Next hunk" })
keymap("n", "<Leader>gk", "<cmd>lua require('gitsigns').prev_hunk()<cr>", { desc = "Prev hunk" })
keymap("n", "<Leader>gl", "<cmd>lua require('gitsigns').blame_line()<cr>", { desc = "Blame line" })
keymap("n", "<Leader>gp", "<cmd>lua require('gitsigns').preview_hunk()<cr>", { desc = "Preview hunk" })
keymap("n", "<Leader>gR", "<cmd>lua require('gitsigns').reset_buffer()<cr>", { desc = "Reset buffer" })
keymap("n", "<Leader>gr", "<cmd>lua require('gitsigns').reset_hunk()<cr>", { desc = "Reset hunk" })
keymap("n", "<Leader>gs", "<cmd>lua require('gitsigns').stage_hunk()<cr>", { desc = "Stage hunk" })
keymap("n", "<Leader>gu", "<cmd>lua require('gitsigns').undo_stage_hunk()<cr>", { desc = "Undo stage hunk" })
keymap("n", "<Leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", { desc = "Diff" })
keymap("n", "<Leader>gO", "<cmd>GitBlameOpenCommitURL<cr>", { desc = "Open in browser" })
keymap("n", "<Leader>gh", "<cmd>GitBlameCopySHA<cr>", { desc = "Copy hash" })

-- LSP and Diagnostics Key Mappings --

-- Key mappings for LSP and diagnostics
keymap("n", "<Leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code Action" })
keymap("n", "<Leader>lA", "<cmd>lua vim.lsp.codelens.run()<cr>", { desc = "CodeLens Action" })
keymap("n", "<Leader>ld", "<cmd>Telescope diagnostics bufnr=0 theme=cursor<cr>", { desc = "Buffer Diagnostics" })
keymap("n", "<Leader>lD", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })
keymap("n", "<Leader>lf", "<cmd>lua vim.lsp.buf.format { async = true }<cr>", { desc = "Format" })
keymap("n", "<Leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", { desc = "Quickfix" })
keymap("n", "<Leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename" })
keymap("n", "<Leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
keymap("n", "<Leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Workspace Symbols" })

-- Center Screen Key Mappings --

-- Center the screen on Ctrl + u, Ctrl + d, Ctrl + o, and Ctrl + i
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-o>", "<C-o>zz", opts)
keymap("n", "<C-i>", "<C-i>zz", opts)

-- Keep Cursor in Place When Joining Lines
keymap("n", "J", "mzJ`z", opts)
keymap("n", "gJ", "mzgJ`z", opts)

-- Repeat Last Macro with Single Key
keymap("n", ",", ":lua REPEAT_LAST_MACRO_OR_Q()<CR>", opts)

-- Insert Mode Key Mappings --

-- Make Control + Backspace delete whole words
keymap("i", "<C-H>", "<C-W>", opts)

-- Visual Mode Key Mappings --

-- Stay in indent mode when using < and > in visual mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move selected text up and down using Alt + Arrow keys in visual mode
keymap("x", "<A-j>", ":m '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":m '<-2<CR>gv-gv", opts)

-- Sort selected text
keymap("v", "&", ":Sort u<CR>", opts)

-- Yanky Key Mappings (Visual Mode) --

-- Yank key mappings for copying and pasting text in visual mode
keymap("x", "p", "<Plug>(YankyPutAfter)", opts)
keymap("x", "P", "<Plug>(YankyPutBefore)", opts)
keymap("x", "gp", "<Plug>(YankyGPutAfter)", opts)
keymap("x", "gP", "<Plug>(YankyGPutBefore)", opts)

-- Preserve cut position on yank in visual mode
keymap("x", "y", "<Plug>(YankyYank)", opts)

-- Terminal Key Mappings --

-- Better terminal navigation using Ctrl + direction keys
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Package management keymappings

-- Key mappings for things related to plugins
keymap("n", "<Leader>po", "<cmd>lua require('lazy').home()<CR>", { desc = "Home" })
keymap("n", "<Leader>pi", "<cmd>lua require('lazy').install()<CR>", { desc = "Install" })
keymap("n", "<Leader>pu", "<cmd>lua require('lazy').update()<CR>", { desc = "Update" })
keymap("n", "<Leader>ps", "<cmd>lua require('lazy').sync()<CR>", { desc = "Sync" })
keymap("n", "<Leader>px", "<cmd>lua require('lazy').clean()<CR>", { desc = "Clean" })
keymap("n", "<Leader>pc", "<cmd>lua require('lazy').check()<CR>", { desc = "Check" })
keymap("n", "<Leader>pL", "<cmd>lua require('lazy').log()<CR>", { desc = "Log" })
keymap("n", "<Leader>pR", "<cmd>lua require('lazy').restore()<CR>", { desc = "Restore" })
keymap("n", "<Leader>pp", "<cmd>lua require('lazy').profile()<CR>", { desc = "Profile" })
keymap("n", "<Leader>pD", "<cmd>lua require('lazy').debug()<CR>", { desc = "Debug" })
keymap("n", "<Leader>pH", "<cmd>lua require('lazy').help()<CR>", { desc = "Help" })
keymap("n", "<Leader>pB", "<cmd>lua require('lazy').clear()<CR>", { desc = "Clear" })
keymap("n", "<Leader>pn", "<cmd>Telescope notify<CR>", { desc = "Notifications" })
