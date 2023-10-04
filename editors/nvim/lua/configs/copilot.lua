if vim.g.loaded_coplilot then return end
vim.g.loaded_coplilot = true

local copilot = require("copilot")

copilot.setup({
  suggestion = {
    enabled = false,
  },
  panel = {
    enabled = false,
  },
})
