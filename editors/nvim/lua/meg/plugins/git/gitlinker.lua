return {
  "ruifm/gitlinker.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  opts = {
    mappings = nil,
  },
  init = function()
    local map = require("meg.utils").map

    map("n", "<Leader>gy", function()
      require("gitlinker").get_repo_url_at_line(true)
    end, "Create link")

    map("v", "<Leader>gy", function()
      require("gitlinker").get_buf_range_url "v"
    end, "Create link")
  end,
}
