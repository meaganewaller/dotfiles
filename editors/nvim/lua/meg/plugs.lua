local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

vim.g.mapleader=" "
vim.g.maplocalleader=","

require("lazy").setup({
  { import = 'meg.plugins.colorscheme' },
  { import = 'meg.plugins.ui' },
  { import = 'meg.plugins.edit' },
  { import = 'meg.plugins.efficiency' },
  { import = 'meg.plugins.filetype' },
  { import = 'meg.plugins.git' },
  { import = 'meg.plugins.lsp' },
  { import = 'meg.plugins.treesitter' },
  { import = 'meg.plugins.tool' },
}, {
  root = root,
  dev = {
    path = "~/code/neovim-plugins",
    patterns = {
      "meaganewaller",
    },
    fallback = true,
  },
  ui = {
    border = "single",
  },
  diff = {
    cmd = "diffview.nvim",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

vim.keymap.set("n", "<leader>mp", "<Cmd>Lazy<CR>", { desc = "Plugins" })
