local opt = vim.opt

vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.makrdown_recommended_style = 0

opt.autoindent = true
opt.autowrite = true
opt.background = 'dark'
opt.backspace = 'indent,eol,start'
opt.backup = false
opt.breakindent = true
opt.completeopt = 'menu,menuone,noselect'
opt.conceallevel = 0
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.foldmethod = 'manual'
opt.formatoptions = 'jcroqlnt'
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
opt.ignorecase = true
opt.inccommand = 'nosplit'
opt.iskeyword:append('-')
opt.laststatus = 0
opt.list = true
opt.mouse = 'a'
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.relativenumber = true
opt.scrolloff = 8
opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize' }
opt.shiftround = true
opt.shiftwidth = 2
opt.shortmess:append({ W = true, I = true, C = true, c = true })
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = 'yes'
opt.smartcase = true
opt.smartindent = true
opt.softtabstop = 2
opt.spelllang = { 'en' }
opt.splitbelow = true
opt.splitkeep = 'screen'
opt.splitright = true
opt.statuscolumn = "%s%=%{&nu?(&rnu && v:relnum?v:relnum:v:lnum):''} %C"
opt.swapfile = false
opt.tabstop = 2
opt.termguicolors = true
opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 50
opt.viewoptions = 'folds'
opt.wildmode = 'longest:full,full'
opt.winminwidth = 5
opt.wrap = false
