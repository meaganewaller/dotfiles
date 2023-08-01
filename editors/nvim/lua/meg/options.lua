local g = vim.g

g.python_recommended_style = 0
g.rust_recommended_style = 0
g.solidity_recommended_style = 0

if vim.fn.expand('$DISPLAY') ~= "$DISPLAY" then
  g.clipboard = {
    name = "unnamedplus",
    copy = {
      ["+"] = "xclip -i -selection clipboard",
      ["*"] = "xclip -i -selection primary",
    },
    paste = {
      ["+"] = "xclip -o -selection clipboard",
      ["*"] = "xclip -o -selection primary",
    },
    cache_enabled = 0,
  }
end

g.mapleader = " "
g.maplocalleader = ","
g.loaded_matchparen = 1
g.python_host_skip_check = 1
g.python3_host_prog = vim.fn.expand("$HOME") .. "/.virtualenvs/py3nvim/bin/python";
g.mouse = "";

if vim.fn.filereadable(g.python3_host_prog) == 0 then
  print('Python3 host not found at ' .. g.python3_host_prog)
end

-- use lua filedetect
g.transparency = true

-- builtin plugin stuff
g.loaded_2html_plugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_gzip = 1
g.loaded_logipat = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1
g.loaded_matchit = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_rrhelper = 1
g.loaded_spellfile_plugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1


nx.set({
  mouse = "",
  showmode = false,
  termguicolors = true,
  timeoutlen = 400,
  updatetime = 250,
  sessionoptions__append = "globals",
  laststatus = 3,
  undofile = true,
  backup = false,
  swapfile = false,
  cmdheight = 1,
  hidden = true,
  pumheight = 6,
  pumwidth = 12,
  shortmess__append = "sI", -- don't give completion-menu messages
  -- Characters
  fillchars__append = [[eob: ,vert:▏,vertright:▏,vertleft:▏,horiz:┈, fold: ,foldopen:,foldsep: ,foldclose:]],
  listchars__append = [[space:⋅, tab: ░, trail:⋅, eol:↴]],
  -- Gutter
  number = true, -- show line numbers
  numberwidth = 2, -- number column width - default "4"
  relativenumber = true, -- set relative line numbers
  ruler = false,
  signcolumn = "yes:1", -- use fixed width signcolumn - prevents text shift when adding signs
  -- Search
  hlsearch = true,
  ignorecase = true, -- ignore case in search patterns
  smartcase = true, -- use smart case
  -- Windows
  equalalways = false, -- force equal window size on split
  splitbelow = true, -- force horizontal splits below
  splitright = true, -- force vertical splits right
  -- Viewport
  scrolloff = 7, -- number of lines to keep above / below cursor
  sidescrolloff = 7, -- number of columns to keep left / right to cursor
  cul = true,
  cursorline = true, -- highlight the current line
  colorcolumn = "120", -- column width indicator - default "80"
  -- Text & line processing
  conceallevel = 0, -- keep backticks `` visible in markdown files
  list = true,
  spelllang = "en", -- spell checking language
  wrap = false, -- display lines as one long line
  linebreak = true, -- do not wrap lines in the middle of words
  whichwrap__append = "<,>,[,],h,l", -- move to previous / next line when reaching first / last character of line
  -- Folds
  foldlevel = 99,
  foldlevelstart = 99,
  foldcolumn = "1",
  foldmethod = "expr",
  foldexpr = "nvim_treesitter#foldexpr()",
  -- Indentation
  expandtab = true, -- do not convert tabs to spaces
  smartindent = true, -- smart auto indenting when starting a new line
  shiftwidth = 0, -- number of spaces to use for (auto) indentation - zero = use tabstop value
  tabstop = 2, -- number of spaces a tab counts for
  softtabstop = -1,
}, vim.opt)

-- Load client specific opts after global opts
require("meg.client").load_opts()
