return {
  "danymat/neogen",
  event = "VeryLazy",
  opts = {
    snippet_engine = "luasnip",
  },
  config = function(_, opts)
    require('neogen').setup(opts)
    local map = require("meg.utils").map

    map("n", "<Leader>ia", function() require("neogen").generate() end, "Annotations")
  end,
}
