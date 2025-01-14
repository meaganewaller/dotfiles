local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end

vim.opt.background = "dark"
vim.opt.backup = false
vim.opt.bufhidden = "wipe"
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
vim.opt.colorcolumn = "120"
vim.opt.completeopt = "menu,menuone,preview,noselect,noinsert"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.fillchars = { eob = " " }
vim.opt.foldenable = true
vim.opt.formatoptions:remove("t")
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.laststatus = 3
vim.opt.lazyredraw = true
vim.opt.list = true
vim.opt.listchars = { tab = "**", trail = "·" }
vim.opt.modelines = 1
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.runtimepath:append("/opt/homebrew/opt/fzf")
vim.opt.runtimepath:prepend(lazypath)
vim.opt.shiftwidth = 2
vim.opt.showmatch = true
vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.softtabstop = 2
vim.opt.swapfile = false
vim.opt.switchbuf:remove("split")
vim.opt.tabstop = 2
--vim.opt.termencoding = "utf8"
vim.opt.termguicolors = true
vim.opt.textwidth = 120
vim.opt.undodir = vim.fn.stdpath("data") .. "undo"
vim.opt.undofile = true
vim.opt.updatetime = 1000
vim.opt.wrap = false

vim.g.mapleader = " "

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

vim.g.editorconfig_enable = false

local disabled_builtin_plugins = { "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers", "tutor" }
for _, plugin in pairs(disabled_builtin_plugins) do
  vim.g["loaded_" .. plugin] = 1
end

require("lazy").setup({
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = false,
        italic = {
          strings = false,
          emphasis = false,
          comments = false,
          operators = false,
          folds = false
        },
        strikethrough = true
      })
      vim.cmd.colorscheme("gruvbox")
    end
  },
})
