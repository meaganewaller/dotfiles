local M = {
  theme = {
    name = "hardhacker",
    style = "dark",
    transparent = false,
  },
}

function M.setup()
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","

  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  local options = require("nvim.options")
  local option, buffer, window = options.scope.option, options.scope.buffer, options.scope.window

  vim.cmd([[filetype indent off]])
  vim.cmd([[set fillchars=eob:\ ,]])
  vim.cmd([[set shortmess+=c]])
  vim.cmd([[set undofile]])

  -- options
  options.set(option, "clipboard", "unnamed,unnamedplus")
  options.set(option, "title", true)

  options.set(option, "swapfile", false)
  options.set(option, "backup", false)
  options.set(option, "writebackup", false)
  options.set(option, "undodir", vim.fn.stdpath "data" .. "/undodir")

  options.set(option, "colorcolumn", "100")
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
  options.set(option, "inccommand", "split")
  options.set(option, "termguicolors", true)
  options.set(option, "hlsearch", true)
  options.set(option, "scrolloff", 10)
  options.set(option, "shell", "fish")


  options.set(window, "number", true)
  options.set(window, "relativenumber", true)
  options.set(window, "signcolumn", "yes:2")
  options.set(option, "cmdheight", 2)

  options.set(buffer, "expandtab", true)
  options.set(option, "smarttab", true)
  options.set(option, "breakindent", true)
  options.set(buffer, "shiftwidth", 2)
  options.set(buffer, "softtabstop", 2)
  options.set(option, "wrap", false)
  options.set(buffer, "tabstop", 2)
  options.set(buffer, "autoindent", true)
  options.set(buffer, "cindent", false)
  options.set(buffer, "smartindent", true)

  vim.api.nvim_create_user_command("Wqa", "wa | qa", { force = true })
  vim.cmd "cabbrev wqa Wqa"
  vim.cmd "cabbrev bda 1,$bd"

  -- Undercurl
  vim.cmd([[let &t_Cs = "\e[4:3m"]])
  vim.cmd([[let &t_Ce = "\e[4:0m"]])

  -- Turn off paste mode when leaving insert
  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = '*',
    command = "set nopaste"
  })

  -- Add asterisks in block comments
  vim.opt.formatoptions:append { 'r' }
end

return M
