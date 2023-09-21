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

  _G.folds_render = require('fold').render
  vim.cmd([[filetype indent off]])
  vim.cmd([[set fillchars=eob:\ ,]])
  vim.cmd([[set shortmess+=c]])
  vim.cmd([[set undofile]])

  require("options")

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
