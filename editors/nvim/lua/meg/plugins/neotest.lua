require("neotest").setup({
	adapters = {
		require("neotest-rspec"),
		require("neotest-jest")({
			jestCommand = "pnpm test --",
			cwd = function(path)
				return vim.fn.getcwd()
			end,
		}),
		require("neotest-playwright").adapter({
			options = {
				persist_project_selection = true,
				enable_dynamic_test_discovery = true,
			},
		}),
		require("neotest-vitest"),
	},
})

nx.cmd({
	"NeotestRun",
	require("neotest").run.run,
	desc = "Run tests",
})

nx.map({
	{
		"<LocalLeader>ta",
		function()
			require("neotest").run.attach()
		end,
		desc = "Test Attach",
	},
	{
		"<LocalLeader>tf",
		function()
			require("neotest").run.run(vim.fn.expand("%"))
		end,
		desc = "Test File",
	},
	{
		"<LocalLeader>tF",
		function()
			require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
		end,
		desc = "Debug File",
	},
	{
		"<LocalLeader>tl",
		function()
			require("neotest").run.run_last()
		end,
		desc = "Run Last",
	},
	{
		"<LocalLeader>tL",
		function()
			require("neotest").run.run_last({ strategy = "dap" })
		end,
		desc = "Debug Last",
	},
	{ "<LocalLeader>tn", "NeotestRun<CR>", desc = "Run Nearest Test" },
	{
		"<LocalLeader>tN",
		function()
			require("neotest").run.run({ strategy = "dap" })
		end,
		desc = "Debug Nearest",
	},
	{
		"<LocalLeader>to",
		function()
			require("neotest").output.open({ enter = true })
		end,
		desc = "Output",
	},
	{
		"<LocalLeader>tS",
		function()
			require("neotest").run.stop()
		end,
		desc = "Stop",
	},
	{
		"<LocalLeader>ts",
		function()
			require("neotest").summary.toggle()
		end,
		desc = "Toggle Summary",
	},
	{
		"<LocalLeader>tj",
		"<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>",
		desc = "Jump to Next Failed",
	},
	{
		"<LocalLeader>tN",
		"<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>",
		desc = "Jump to Previous Failed",
	},
})
