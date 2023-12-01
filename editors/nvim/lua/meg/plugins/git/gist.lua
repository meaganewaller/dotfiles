return {
  "Rawnly/gist.nvim",
  cmd = {
    "GistCreate",
    "GistCreateFromFile",
    "GistsList",
  },
  opts = {},
  init = function()
    local map = require("meg.utils").map

    map("n", "<Leader>gt", function()
      require("gist").create()
    end, "Create Gist")

    map("n", "<Leader>gl", function()
      require("gist").list()
    end, "List Gists")
  end,
}
