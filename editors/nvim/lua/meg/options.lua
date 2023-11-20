nx.set({
  	-- General
	clipboard = "unnamedplus", -- use system clipboard
	mouse = "a", -- allow mouse in all modes
	showmode = false, -- print vim mode on enter
  guicursor = 'n-v-c:block,i-ci-ve:ver100/,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',

	timeoutlen = 350, -- time to wait for a mapped sequence to complete
	title = true, -- show filename and path in application window title
	titlelen = 25, -- percentage of columns to use before shortening the title
	sessionoptions__append = "globals",
	laststatus = 3, -- global statusline
	-- Auxiliary files
	undofile = true, -- enable persistent undo
	backup = false, -- create a backup file
	swapfile = false, -- create a swap file
	-- Command line
	cmdheight = 1,
	-- Completion menu
	pumheight = 14, -- completion popup menu height
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
	hlsearch = true, -- highlight matches in previous search pattern
  incsearch = true,
	ignorecase = true, -- ignore case in search patterns
	smartcase = true, -- use smart case
	-- Windows
	equalalways = false, -- force equal window size on split
	splitbelow = true, -- force horizontal splits below
	splitright = true, -- force vertical splits right
	-- Viewport
	scrolloff = 8, -- number of lines to keep above / below cursor
	sidescrolloff = 8, -- number of columns to keep left / right to cursor
	cursorline = true, -- highlight the current line
	colorcolumn = "120", -- column width indicator - default "80"
	-- Text & line processing
	conceallevel = 0, -- keep backticks `` visible in markdown files
	list = false,
  formatoptions = vim.o.formatoptions:gsub('cro', ''),
  updatetime = 300,
	spelllang = "en", -- spell checking language
	wrap = false, -- display lines as one long line
	linebreak = true, -- do not wrap lines in the middle of words
  textwidth = 120,
	whichwrap__append = "<,>,[,],h,l", -- move to previous / next line when reaching first / last character of line
	-- Folds
	foldlevel = 99,
	foldlevelstart = 99,
	foldcolumn = "1",
  foldenable = true,
	-- Indentation
	expandtab = true, -- do not convert tabs to spaces
	smartindent = true, -- smart auto indenting when starting a new line
	shiftwidth = 0, -- number of spaces to use for (auto) indentation - zero = use tabstop value
	tabstop = 2, -- number of spaces a tab counts for
  showtabline=2,
  breakindent = true,
}, vim.opt)

require("meg.client").load_opts()
