-- https://github.com/akinsho/toggleterm.nvim

-- { == Configuration ==> =====================================================

require("toggleterm").setup({
  open_mapping = "<C-t>",
  hide_numbers = true,
  direction = "float",
  start_in_insert = true,
  shell = vim.o.shell,
  close_on_exit = true,
  float_opts = { border = "rounded" },
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

nx.map({
  { "<C-t>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
})

-- <== }
