nx.set({
  clipboard = "unnamedplus",
  mouse = "a",
  showmode = false,
  termguicolors = true,
  timeoutlen = 350,
  title = false,
  sessionoptions__append = "globals",
  laststatus = 3,
  undofile = true,
  backup = false,
  swapfile = false,
  cmdheight = 0,
  pumheight = 14,
  shortmess__append = "c", -- don't give completion-menu messages
  -- Characters
  fillchars__append = [[eob: ,vert:▏,vertright:▏,vertleft:▏,horiz:┈, fold: ,foldopen:,foldsep: ,foldclose:]],
  listchars__append = [[space:⋅, tab: ░, trail:⋅, eol:↴]],
  -- Gutter
  number = true, -- show line numbers
  numberwidth = 3, -- number column width - default "4"
  relativenumber = true, -- set relative line numbers
  signcolumn = "yes:2", -- use fixed width signcolumn - prevents text shift when adding signs
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
  cursorline = true, -- highlight the current line
  colorcolumn = "120", -- column width indicator - default "80"
  -- Text & line processing
  conceallevel = 0, -- keep backticks `` visible in markdown files
  list = false,
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
  expandtab = false, -- do not convert tabs to spaces
  smartindent = true, -- smart auto indenting when starting a new line
  shiftwidth = 0, -- number of spaces to use for (auto) indentation - zero = use tabstop value
  tabstop = 3, -- number of spaces a tab counts for
}, vim.opt)

-- Load client specific opts after global opts
require("meg.client").load_opts()
