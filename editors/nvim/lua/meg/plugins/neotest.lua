local M = {}

local function config_test()
	vim.api.nvim_exec(
		[[
      " Test Config
      let test#strategy = 'neovim'
      let test#neovim#term_position = 'belowright'
      let g:test#preserve_screen = 1

      " Python
      let test#python#runner = 'pyunit'

      " JavaScript
      let test#javascript#reactscripts#options = "--watchAll=false"
      let g:test#javascript#runner = 'jest'
      let g:test#javascript#cypress#executable = 'yarn cypress'
    ]],
		false
	)
end

function M.javascript_runner()
	local runners = { "cypress", "jest" }
	vim.ui.select(runners, { prompt = "Choose Javascript Runner" }, function(selected)
		if selected then
			vim.g["test#javascript#runner"] = selected
			vim.notify("Test runner changed to " .. selected, vim.log.levels.INFO, { title = "Test Runner" })
		end
	end)
end

require("neotest").setup({
	adapters = {
		require("neotest-python")({
			dap = { justMyCode = false },
			runner = "unittest",
		}),
		require("neotest-rspec"),
		require("neotest-jest"),
		require("neotest-go"),
		require("neotest-playwright").adapter({
			options = {
				persist_project_selection = true,
				enable_dynamic_test_discovery = true,
			},
		}),
		require("neotest-vitest"),
		require("neotest-plenary"),
		require("neotest-vim-test")({
			ignore_file_types = { "python", "vim", "lua", "ruby" },
		}),
	},
	consumers = {
		overseer = require("neotest.consumers.overseer"),
	},
	overseer = {
		enabled = true,
		force_default = true,
	},
})

config_test()

nx.cmd({
	"NeotestRun",
	require("neotest").run.run,
	desc = "Run tests",
})

nx.map({
	{
		"<LocalLeader>ta",
		"<cmd>lua require('neotest').run.attach()<CR>",
		desc = "Attach",
	},
	{
		"<LocalLeader>tf",
		"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
		desc = "Run File",
	},
	{
		"<LocalLeader>tF",
		"<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
		desc = "Debug File",
	},
	{
		"<LocalLeader>tl",
		"<cmd>lua require('neotest').run.run_last()<cr>",
		desc = "Run Last",
	},
	{
		"<LocalLeader>tL",
		"<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<cr>",
		desc = "Debug Last",
	},
	{
		"<LocalLeader>tn",
		"<cmd>lua require('neotest').run.run()<cr>",
		desc = "Run Nearest Test",
	},
	{
		"<LocalLeader>tN",
		"<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
		desc = "Debug Nearest",
	},
	{
		"<LocalLeader>to",
		"<cmd>lua require('neotest').output.open({ enter = true })<cr>",
		desc = "Output",
	},
	{
		"<LocalLeader>tS",
		"<cmd>lua require('neotest').run.stop()<cr>",
		desc = "Stop",
	},
	{
		"<LocalLeader>ts",
		"<cmd>lua require('neotest').summary.toggle()<cr>",
		desc = "Toggle Summary",
	},
	{
		"<LocalLeader>tP",
		"<Plug>PlenaryTestFile",
		desc = "PlenaryTestFile",
	},
	{
		"<LocalLeader>tv",
		"<cmd>TestVisit<CR>",
		desc = "Visit",
	},
	{
		"<LocalLeader>tx",
		"<cmd>TestSuite<CR>",
		desc = "Suite",
	},
	{
		"<LocalLeader>tj",
		"<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>",
		desc = "Jump to Next Failed",
	},
	{
		"<LocalLeader>tk",
		"<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>",
		desc = "Jump to Previous Failed",
	},
})

return M
