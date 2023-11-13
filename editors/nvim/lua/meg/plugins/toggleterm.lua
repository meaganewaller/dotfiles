-- https://github.com/akinsho/toggleterm.nvim

-- { == Configuration ==> =====================================================

require("toggleterm").setup({
  size = 20,
  open_mapping = [[<C-\>]],
  hide_numbers = false,
  shade_filetypes = false,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = false,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
  auto_scroll = false,
  shell = vim.o.shell,
  winbar = { enabled = true },
})
-- <== }

-- { == Custom Terminals ==> ==================================================

local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
  },
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  end,
  on_close = function(_) vim.cmd("startinsert!") end,
})

function LAZYGIT_TOGGLE() lazygit:toggle() end

-- <== }

-- { == Keymaps ==> ===========================================================

-- <== }
