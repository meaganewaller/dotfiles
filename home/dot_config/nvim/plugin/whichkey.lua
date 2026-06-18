vim.cmd.packadd("which-key.nvim")

local wk = require("which-key")

wk.setup({
  preset = "modern",
})

wk.add({
  { "<leader>a", group = "AI/Claude" },
  { "<leader>f", group = "Find" },
  { "<leader>g", group = "Git" },
  { "<leader>o", group = "OpenCode" },
  { "<leader>l", group = "LSP" },
  { "<leader>lw", group = "Workspace" },
})
