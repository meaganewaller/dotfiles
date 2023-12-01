return {
  {
    "windwp/nvim-spectre",
    init = function()
      local map = require "meg.utils".map

      map("n", "<Leader>sr", "<cmd>lua require('spectre').open()<CR>", "Replace in files (Spectre)", { noremap = true })
    end,
  },
}
