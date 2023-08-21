local M = {
  theme = {
    name = "hardhacker",
    transparent = false,
  },
}

function M.setup()
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","

  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  local options = require("meg.nvim.options")
  local option, buffer, window = options.scope.option, options.scope.buffer, options.scope.window

  vim.cmd([[filetype indent off]])
  vim.cmd([[set fillchars=eob:\ ,]])
  vim.cmd([[set shortmess+=c]])
  vim.cmd([[set undofile]])

  -- options
  options.set(option, "clipboard", "unnamed,unnamedplus")

  options.set(option, "swapfile", false)
  options.set(option, "backup", false)
  options.set(option, "writebackup", false)
  options.set(option, "undodir", vim.fn.stdpath "data" .. "/undodir")

  options.set(option, "colorcolumn", 100)
  options.set(option, "updatetime", 50)
  options.set(option, "hidden", true)
  options.set(option, "ignorecase", true)
  options.set(option, "mouse", "a")
  options.set(option, "showmode", false)
  options.set(option, "smartcase", true)
  options.set(option, "splitbelow", true)
  options.set(option, "splitright", true)
  options.set(option, "cursorline", true)
  options.set(option, "pumheight", 10)
  options.set(option, "termguicolors", true)

  options.set(window, "number", true)
  options.set(window, "relativenumber", true)
  options.set(window, "signcolumn", "yes:2")
  options.set(option, "cmdheight", 2)

  options.set(buffer, "expandtab", true)
  options.set(buffer, "shiftwidth", 2)
  options.set(buffer, "softtabstop", 2)
  options.set(buffer, "tabstop", 2)
  options.set(buffer, "autoindent", false)
  options.set(buffer, "cindent", false)
  options.set(buffer, "smartindent", false)

  vim.api.nvim_create_user_command("Wqa", "wa | qa", { force = true })
  vim.cmd "cabbrev wqa Wqa"
  vim.cmd "cabbrev bda 1,$bd"
end

return M
