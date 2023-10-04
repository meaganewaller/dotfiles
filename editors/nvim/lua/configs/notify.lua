local notify = require("notify")

notify.setup({
  render = "wrapped-compact",
  stages = "fade",
  timeout = 3000,
  fps = 30,
})

vim.notify = notify
