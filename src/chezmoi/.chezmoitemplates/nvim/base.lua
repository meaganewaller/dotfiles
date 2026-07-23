-- Base Neovim Settings
local opt = vim.opt
local keymap = vim.keymap

-- Set leader key to space, and localleader to comma
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Map jk and kj to escape in insert mode
vim.keymap.set("i", "jk", "<ESC>", { noremap = true })
vim.keymap.set("i", "kj", "<ESC>", { noremap = true })

-- Set a reasonable history size
opt.history = 1000

-- Enable hidden buffers
opt.hidden = true

-- Automatically read files when they change on disk
opt.autoread = true

-- Use the OS clipboard by default
opt.clipboard = "unnamedplus"

-- WSL clipboard support
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c "[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))"',
      ["*"] = 'powershell.exe -c "[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))"',
    },
    cache_enabled = 0,
  }
end

-- Set default encoding to utf-8
opt.encoding = "utf-8"

-- Set default file format preference order
opt.fileformats = { "unix", "dos", "mac" }

-- Set timeout for key sequences
opt.timeout = true
opt.timeoutlen = 1000
opt.ttimeoutlen = 100

-- Disable backups
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Set a reasonable directory for undo files
opt.undofile = true
opt.undolevels = 1000
opt.undoreload = 10000
