local g = vim.g
local opt = vim.opt

-- Enable cursorline and show line numbers in cursorline
opt.cursorline = true
opt.cursorlineopt = "number"

-- Set color column at column 120
opt.colorcolumn = "120"

-- Start folding at level 99
opt.foldlevelstart = 99

-- Show last status line (for split windows)
opt.laststatus = 3

-- Disable showing mode in status line
opt.showmode = false

-- Enable mouse support in all modes
opt.mouse = "a"

-- Show line numbers
opt.number = true

-- Set popup menu height to 16 lines
opt.pumheight = 16

-- Show relative line numbers
opt.relativenumber = true

-- Show ruler (line and column numbers)
opt.ruler = true

-- Set minimum lines to keep above and below the cursor
opt.scrolloff = 4
opt.sidescrolloff = 8

-- Show sign column
opt.signcolumn = "yes:1"

-- Open new splits to the right and below
opt.splitright = true
opt.splitbelow = true

-- Disable swap files
opt.swapfile = false

-- Enable true color support
opt.termguicolors = true

-- Enable persistent undo
opt.undofile = true

-- Disable line wrapping
opt.wrap = false

-- Enable line breaking
opt.linebreak = true

-- Enable break indent (break line at wrapped positions)
opt.breakindent = true

-- Enable smooth scrolling
opt.smoothscroll = true

-- Set completion options
opt.completeopt = "menu,menuone,noselect"

-- Conceal level 2 for better rendering of concealed text
opt.conceallevel = 2

-- Automatically write all changes before running certain commands
opt.autowriteall = true

-- Set popup menu blend level to 0 (fully opaque)
opt.pumblend = 0

-- Set window blend level to 0 (fully opaque)
opt.winblend = 0

-- Configure general code-related options
opt.gcr:append(
  "n-v:block-Cursor/lCursor,i-c-ci-ve:blinkoff500-blinkon500-block-TermCursor,r-cr:hor20,o:hor50-Cursor/lCursor"
)

-- Use patience algorithm for diffing
opt.diffopt:append("algorithm:patience")

-- Enable backup files
opt.backup = true

-- Remove current directory from backup directory list
opt.backupdir:remove(".")

-- Shorten the messages displayed in the command-line
opt.shortmess:append("I")

-- Enable list characters display
opt.list = true

-- Set list characters for tabs, trailing spaces, etc.
opt.listchars = {
  tab = "→ ",
  extends = "…",
  precedes = "…",
  nbsp = "␣",
  trail = "·",
}

-- Set fill characters for folds, fold markers, etc.
opt.fillchars = {
  fold = "·",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Set tab settings
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- Enable smartindent and autoindent
opt.smartindent = true
opt.autoindent = true

-- Enable searching with highlighting
opt.hlsearch = true

-- Enable case-insensitive searching unless explicit uppercase characters are used
opt.ignorecase = true
opt.smartcase = true

-- Disable spelling
opt.spell = false

-- Disable spell checking for CamelCase words
opt.spellcapcheck = ""

-- Set spelling languages
opt.spelllang = "en,cjk"

-- Set spelling options for CamelCase words
opt.spelloptions = "camel"

-- Set spelling suggestions to "best" and limit to 9 suggestions
opt.spellsuggest = "best,9"

-- Disable plugins shipped with Neovim
g.loaded_gzip = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_matchit = 1
g.loaded_2html_plugin = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- If using Neovide, configure some GUI options
if g.neovide then
  opt.guifont = "FiraCode Nerd Font Mono:h12"
  g.neovide_cursor_vfx_mode = "railgun"
  g.neovide_no_idle = true
  g.neovide_cursor_animation_length = 0.03
  g.neovide_cursor_trail_length = 0.05
  g.neovide_cursor_antialiasing = true
  g.neovide_cursor_vfx_opacity = 200.0
  g.neovide_cursor_vfx_particle_lifetime = 1.2
  g.neovide_cursor_vfx_particle_speed = 20.0
  g.neovide_cursor_vfx_particle_density = 5.0
end
