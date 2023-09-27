if vim.g.loaded_coplilot then
  return
end
vim.g.loaded_coplilot = true

local copilot = require('copilot')
local suggestion = require('copilot.suggestion')
local utils = require('utils')

copilot.setup({
  suggestion = {
    auto_trigger = true,
    keymap = {
      accept = false,
    },
  },
  panel = {
    auto_refresh = true,
  },
})
