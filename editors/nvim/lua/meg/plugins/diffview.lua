local diffview = require("diffview")

-- { == Configuration ==> =====================================================

local config = {
  view = {
    merge_tool = {
      layout = "diff3_mixed",
    },
  },
}
-- <== }

-- { == Keymaps ==> ==========================================================

local actions = require("diffview.actions")

config.key_bindings = {
	disable_defaults = false,
	file_panel = {
		{ "n", "s", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry." } },
		{ "n", "<c-f>", actions.scroll_view(0.382), { desc = "Scroll the view down" } },
		{ "n", "<c-b>", actions.scroll_view(-0.382), { desc = "Scroll the view up" } },
	},
}

nx.map({
	{ "<leader>gd", "<Cmd>DiffviewToggle<CR>", desc = "Toggle Diffview", wk_label = "Diffview" },
	{ "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", desc = "Diffview File History", wk_label = "File History" },
})
-- <== }

-- { == Load Setup ==> =======================================================

diffview.setup(config)
-- <== }

-- { == Highlights ==> =======================================================

--if vim.g.colors_name == "dracula" then
--	local palette = require("meg.colorschemes.dracula").palette
--	nx.hl({
--		{ "DiffViewFilePanelFileName", fg = palette.tree_file_name },
--		{ "DiffViewFilePanelCounter", fg = palette.tree_file_name },
--		{ "diffChanged", link = "DiffviewDim1" }, -- there is no `diffChanged` in official dracula
--	})
--end
-- <== }

-- { == Commands ==> ==========================================================

nx.cmd({
	"DiffviewToggle",
	function(e)
		if vim.g.diffview_open then
			vim.cmd("DiffviewClose")
		else
			vim.cmd("DiffviewOpen " .. e.args)
		end
	end,
	nargs = "*",
})
-- <== }
