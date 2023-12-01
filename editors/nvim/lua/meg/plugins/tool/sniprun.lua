local custom = require "meg.custom"

return {
  "michaelb/sniprun",
  build = "bash install.sh",
  opts = {
    borders = custom.border,
  },
  init = function()
    local map = require "meg.utils".map

    map({"n", "v"}, "<Leader>r", "<cmd>SnipRun<CR>", "Run")
  end,
}
