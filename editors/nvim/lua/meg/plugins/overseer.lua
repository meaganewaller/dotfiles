local function setup(overseer)
  overseer.setup({
    component_aliases = {
      default_neotest = {
        "on_output_summarize",
        "on_exit_set_status",
        "on_complete_dispose",
      },
    },
    templates = { "java_build" },
  })
end

local loaded, overseer = pcall(require, "overseer")
if not loaded then
  mw.loading_error_msg("overseer")
  return
end

setup(overseer)
nx.map({
  { "<Leader>or", "<cmd>OverseerRun<cr>", desc = "Run Overseer task from a template" },
  { "<Leader>ob", "<cmd>OverseerBuild<cr>", desc = "Open the Overseer task builder" },
  { "<Leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer window" },
  {
    "<Leader>oo",
    function()
      local overs = require("overseer")
      local tasks = overs.list_tasks({ recent_first = true })
      if vim.tbl_isempty(tasks) then
        vim.notify("No tasks found", vim.log.levels.WARN)
      else
        overs.run_action(tasks[1], "restart")
      end
    end,
    desc = "Run the last Overseer task",
  },
}, { wk_label = { sub_desc = "Overseer" }})
