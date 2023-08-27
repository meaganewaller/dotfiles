local g = vim.g
local vb = vim.bo
local vw = vim.wo
local vo = vim.opt

Homedir = os.getenv("HOME")
Sessiondir = vim.fn.stdpath("data") .. "/sessions"

g.mapleader = " "
g.maplocalleader = ","

g.neoterm_autoinsert = 0
g.neoterm_autoscroll = 1
g.loaded_perl_provider = 0
if vim.fn.filereadable(os.getenv("HOME") .. ".asdf/shims/python2") then
  g.python_host_prog = os.getenv("HOME") .. ".asdf/shims/python2"
end
if vim.fn.filereadable(os.getenv("HOME") .. ".asdf/shims/python") then
  g.python3_host_prog = os.getenv("HOME") .. ".asdf/shims/python"
end

vo.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50" -- block in normal and beam cursor in insert mode

-- Buffer options
vb.autoindent = true
vb.expandtab = true   -- Use spaces instead of tabs
vb.shiftwidth = 2     -- Size of an indent
vb.smartindent = true -- Insert indents automatically
vb.softtabstop = 2    -- Number of spaces tabs count for
vb.tabstop = 2        -- Number of spaces in a tab
-- vb.wrapmargin = 1
-- Vim options
vo.background = "dark"
vo.cmdheight = 1                                               -- Height of the command bar
vo.clipboard = { "unnamedplus" }                               -- Use the system clipboard
vo.completeopt = { "menu", "menuone", "noselect", "noinsert" } -- Completion opions for code completion
vo.cursorline = true
vo.cursorlineopt =
"screenline,number"                                            -- Highlight the screen line of the cursor with CursorLine and the line number with CursorLineNr
vo.emoji = false                                               -- Turn off emojis
vo.fillchars = {
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vo.listchars = {
  tab = "┆ ",
  trail = "~",
}
vo.foldcolumn = "1" -- Show the fold column
vo.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vo.foldlevelstart = 99
vo.foldenable = true
vo.foldmethod = "expr"
vo.foldexpr = "nvim_treesitter#foldexpr()"
vo.conceallevel = 0                                                        -- Show `` in markdown files

vo.ignorecase = true                                                       -- Ignore case
vo.laststatus = 3                                                          -- Use global statusline
vo.modelines = 1                                                           -- Only use folding settings for this file
vo.mouse = "a"                                                             -- Use the mouse in all modes
vo.mousefocus = true
vo.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize" -- Session options to store in the session
vo.scrolloff = 5                                                           -- Set the cursor 5 lines down instead of directly at the top of the file
--[[
  NOTE: don't store marks as they are currently broken in Neovim!
  @credit: wincent
]]
vo.shada = "!,'0,f0,<50,s10,h"
vo.shell = "/usr/local/bin/fish"
vo.shiftround = true -- Round indent
vo.shortmess = {
  A = true,          -- ignore annoying swap file messages
  c = true,          -- Do not show completion messages in command line
  F = true,          -- Do not show file info when editing a file, in the command line
  I = true,          -- Do not show the intro message
  W = true,          -- Do not show "written" in command line when writing
}
-- vo.showcmd = true -- Do not show me what I'm typing
vo.showmatch = true     -- Show matching brackets by flickering
vo.showmode = false     -- Do not show the mode
vo.hlsearch = true
vo.sidescrolloff = 8    -- The minimal number of columns to keep to the left and to the right of the cursor if 'nowrap' is set
vo.showtabline = 1      -- Always show tabs
vo.smartcase = true     -- Don't ignore case with capitals
vo.splitbelow = true    -- Put new windows below current
vo.splitright = true    -- Put new windows right of current
vo.termguicolors = true -- True color support
vo.textwidth = 120      -- Total allowed width on the screen
vo.timeout = true       -- This option and 'timeoutlen' determine the behavior when part of a mapped key sequence has been received. This is on by default but being explicit!
vo.timeoutlen = 400     -- Time in milliseconds to wait for a mapped sequence to complete.
vo.ttimeoutlen = 10     -- Time in milliseconds to wait for a key code sequence to complete
vo.updatetime = 300     -- If in this many milliseconds nothing is typed, the swap file will be written to disk. Also used for CursorHold autocommand and set to 100 as per https://github.com/antoinemadec/FixCursorHold.nvim
vo.wildmode = "full"
vo.lazyredraw = false
vo.wildignore = { "*/.git/*", "*/node_modules/*" } -- Ignore these files/folders
vo.wildignorecase = true

-- Create folders for our backups, undos, swaps and sessions if they don't exist
vim.cmd("silent call mkdir(stdpath('data').'/backups', 'p', '0700')")
vim.cmd("silent call mkdir(stdpath('data').'/undos', 'p', '0700')")
vim.cmd("silent call mkdir(stdpath('data').'/swaps', 'p', '0700')")
vim.cmd("silent call mkdir(stdpath('data').'/sessions', 'p', '0700')")

vo.backupdir = vim.fn.stdpath("data") .. "/backups" -- Use backup files
vo.directory = vim.fn.stdpath("data") .. "/swaps"   -- Use Swap files
vo.undofile = true                                  -- Maintain undo history between sessions
vo.undolevels = 1000                                -- Ensure we can undo a lot!
vo.undodir = vim.fn.stdpath("data") .. "/undos"     -- Set the undo directory

vo.history = 1000                                   -- Store lots of history

vo.backup = false
vo.swapfile = false

-- Window options
vw.colorcolumn = "80,120" -- Make a ruler at 80px and 120px
vw.list = true            -- Show some invisible characters like tabs etc
vw.numberwidth = 2        -- Make the line number column thinner
---Note: Setting number and relative number gives you hybrid mode
---https://jeffkreeftmeijer.com/vim-number/
vw.number = true         -- Set the absolute number
vw.relativenumber = true -- Set the relative number
vw.signcolumn = "yes"    -- Show information next to the line numbers
vw.wrap = false          -- Do not display text over multiple lines
