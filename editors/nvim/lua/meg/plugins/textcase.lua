local tc = require("textcase")
tc.setup({
	prefix = "<LocalLeader>cc",
})

nx.map({
	{ "<LocalLeader>cc", "<cmd>TextCaseOpenTelescope<CR>", desc = "Change Case", mode = { "n", "v" } },
})

local ok, telescope = pcall(require, "telescope")
if not ok then
	vim.notify("Telescope not installed", vim.log.levels.WARN, { title = "TextCase" })
	return
end

telescope.load_extension("textcase")
