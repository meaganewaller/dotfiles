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
    map("n", "<Leader>if", ":Neogen func<CR>", "Annotate Function")
    map("n", "<Leader>ic", ":Neogen class<CR>", "Annotate Class")
  end,
}
