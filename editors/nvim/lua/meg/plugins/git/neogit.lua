local custom = require "meg.custom"

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
  },
  opts = {
    disable_insert_on_commit = false,
    disable_commit_confirmation = true,
    disable_builtin_notifications = true,
    kind = custom.prefer_tabpage and "tab" or "split",
    integrations = {
      diffview = true,
    },
    sections = {
      stashes = {
        folded = false,
      },
      recent = {
        folded = false,
      },
    },
  },
  init = function()
    local map = require("meg.utils").map

    map("n", "<Leader>gg", function()
      require("neogit").open()
    end, "Open Neogit")
  end,
}
