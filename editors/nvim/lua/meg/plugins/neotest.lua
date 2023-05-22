require("neotest").setup({
	adapters = {
		require("neotest-rspec"),
	},
})

nx.cmd({
	"NeotestRun",
	require("neotest").run.run,
	desc = "Run tests",
})

nx.map({
	{ "<LocalLeader>tt", "NeotestRun", desc = "Run nearest test" },
	{ "<LocalLeader>t.", "<cmd>lua require('neotest').run.run_last()<CR>", desc = "Run last test" },
	{ "<LocalLeader>ta", '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>', desc = "Run All" },
	{
		"<LocalLeader>to",
		'<cmd>lua require("neotest").output.open({ last_run = true, enter = true })<cr>',
		desc = "Show Output",
	},
	{
		"<LocalLeader>tO",
		"<cmd>lua require('neotest').output.open({ short = true })<CR>",
		desc = "Show Current Test Output",
	},
	{ "<LocalLeader>ts", "<cmd>lua require('neotest').summary.toggle()<CR>", desc = "Toggle Summary" },
	{
		"<LocalLeader>tn",
		"<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>",
		desc = "Jump to Next Failed",
	},
	{
		"<LocalLeader>tN",
		"<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>",
		desc = "Jump to Previous Failed",
	},
})
