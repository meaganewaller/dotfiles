return 	{
  "piersolenski/wtf.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy",
  opts = {},
  init = function()
    local map = require("meg.utils").map

    map("n", "gw", function() require('wtf').ai() end, "Debug diagnostic with AI")
    map("n", "gW", function() require('wtf').search() end, "Search diagnostic with Google")
  end,
}
