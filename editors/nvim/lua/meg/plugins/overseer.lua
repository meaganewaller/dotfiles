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
		"<LocalLeader>oC",
		"<cmd>OverseerClose<cr>",
		desc = "Close",
	},
	{
		"<LocalLeader>oa",
		"<cmd>OverseerTaskAction<cr>",
		desc = "Task Action",
	},
	{
		"<LocalLeader>ob",
		"<cmd>OverseerBuild<cr>",
		desc = "Build",
	},
	{ "<LocalLeader>ol", "<cmd>OverseerLoadBundle<cr>", desc = "OverseerLoadBundle" },
	{ "<LocalLeader>oo", "<cmd>OverseerOpen!<cr>", desc = "OverseerOpen" },
	{ "<LocalLeader>oq", "<cmd>OverseerQuickAction<cr>", desc = "OverseerQuickAction" },
	{ "<LocalLeader>or", "<cmd>OverseerRun<cr>", desc = "OverseerRun" },
	{ "<LocalLeader>os", "<cmd>OverseerSaveBundle<cr>", desc = "OverseerSaveBundle" },
	{ "<LocalLeader>ot", "<cmd>OverseerToggle!<cr>", desc = "OverseerToggle" },
	{ "<LocalLeader>oc", "<cmd>OverseerRunCmd<cr>", desc = "OverseerRunCmd" },
})
