vim.pack.add({
  { src = "https://github.com/folke/which-key.nvim" },
})

local wk = require("which-key")

wk.setup({
  preset = "modern",
})

wk.add({
  { "<leader>f", group = "Find" },
  { "<leader>h", group = "Git hunks" },
  { "<leader>l", group = "LSP" },
  { "<leader>o", group = "Onlooker" },
  { "<leader>t", group = "Toggle" },
  { "<leader>w", group = "Window" },
})
