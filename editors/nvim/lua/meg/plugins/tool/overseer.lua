return {
  "stevearc/overseer.nvim",
  config = function()
    local overseer = require "overseer"
    local custom = require "meg.custom"

    overseer.setup {
      strategy = {
        "toggleterm",
        quit_on_exit = "success",
      },
      form = {
        border = custom.border,
      },
      confirm = {
        border = custom.border,
      },
      task_win = {
        border = custom.border,
      },
      component_aliases = {
        default = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_notify",
          "on_complete_dispose",
          "unique",
        },
      },
    }

    local map = require "meg.utils".map

    map("n", "<leader>rr", "<cmd>OverseerRun<CR>", "Run", { noremap = true })
    map("n", "<leader>rl", "<cmd>OverseerToggle<CR>", "List", { noremap = true })
    map("n", "<leader>rn", "<cmd>OverseerBuild<CR>", "New", { noremap = true })
    map("n", "<leader>ra", "<cmd>OverseerTaskAction<CR>", "Action", { noremap = true })
    map("n", "<leader>ri", "<cmd>OverseerInfo<CR>", "Info", { noremap = true })
    map("n", "<leader>rc", "<cmd>OverseerClearCache<CR>", "Clear cache", { noremap = true })
  end,
}
