local overseer = require("overseer")
overseer.setup({
	component_aliases = {
		default_neotest = {
			"on_output_summarize",
			"on_exit_set_status",
			"on_complete_dispose",
		},
	},
})

nx.cmd({
	{ "OverseerRun", "<cmd>OverseerRun<cr>", bang = true, desc = "Run a task from a template" },
	{ "OverseerBuild", "<cmd>OverseerBuild<cr>", bang = true, desc = "Open the task builder" },
	{ "OverseerToggle", "<cmd>OverseerToggle<cr>", bang = true, desc = "Toggle the Overseer window" },
})

nx.map({
	{
		"<Leader>o",
		function()
			local overseer = require("overseer")
			local tasks = overseer.list_tasks({ recent_first = true })
			if vim.tbl_isempty(tasks) then
				vim.notify("No tasks found", vim.log.levels.WARN)
			else
				overseer.run_action(tasks[1], "restart")
			end
		end,
		desc = "Run the last Overseer task",
	},
})
