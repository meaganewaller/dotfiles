-----------------------------------------------------------
-- General Neovim settings and configuration
-----------------------------------------------------------

-- Default options are not included
-- See: https://neovim.io/doc/user/vim_diff.html
-- [2] Defaults - *nvim-defaults*

local g = vim.g     -- Global variables
local opt = vim.opt -- Set options (global/buffer/windows-scoped)

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = 'a'                                    -- Enable mouse support
opt.completeopt = 'menu,menuone,noinsert,noselect' -- Autocomplete options
opt.timeoutlen = 500                               -- shorter timeout for which-key
opt.modeline = false                               -- I don't use modeline and it's a potential security risk
opt.autoread = true                                -- update unmodified buffers if file changes on disk
-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true         -- Show line number
opt.showmatch = true      -- Highlight matching parenthesis
opt.matchtime = 0         -- ... but don't make slow jumps please
opt.foldmethod = 'marker' -- Enable folding (default 'foldmarker')
opt.splitright = true     -- Vertical split to the right
opt.splitbelow = true     -- Horizontal split to the bottom
opt.ignorecase = true     -- Ignore case letters when searching
opt.smartcase = true      -- Ignore lowercase for the whole pattern
opt.linebreak = true      -- Wrap on word boundary
opt.termguicolors = true  -- Enable 24-bit RGB colors
opt.cursorline = true     -- Highlight line with cursor
opt.laststatus = 2        -- One statusline per window

-----------------------------------------------------------
-- Tabs, indent, whitespace
-----------------------------------------------------------
opt.expandtab = true   -- Use spaces instead of tabs
opt.shiftwidth = 2     -- Shift 2 spaces when tab
opt.tabstop = 2        -- 1 tab == 2 spaces
opt.softtabstop = 2
opt.smartindent = true -- Autoindent new lines
opt.list = true
opt.listchars = {
  -- Show whitespace
  tab = ' -',
  extends = '⟩',
  precedes = '⟨',
  trail = '·'
}

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true    -- Enable background buffers
opt.history = 100    -- Remember N lines in history
-- opt.lazyredraw = true -- Faster scrolling
opt.synmaxcol = 280  -- Max column for syntax highlight
opt.updatetime = 700 -- ms to wait for trigger an event

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- Disable nvim intro
opt.shortmess:append "sI"

-- Disable builtins plugins
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end
