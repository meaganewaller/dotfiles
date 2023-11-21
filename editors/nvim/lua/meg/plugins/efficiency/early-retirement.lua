local custom = require "meg.custom"

return {
  "chrisgrieser/nvim-early-retirement",
  cond = custom.prefer_tabpage,
  event = "VeryLazy",
  opts = {},
}
