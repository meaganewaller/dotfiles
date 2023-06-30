local genie = require("SnippetGenie")
genie.setup({
	regex = [[-\+ Snippets goes here]],
	snippets_directory = "/home/viv/.config/nvim/snippets/",
	file_name = "generated",
	snippet_skeleton = [[
        s(
            "{trigger}",
            fmt([=[
        {body}
        ]=], {{
                {nodes}
            }})
        ),
        ]],
})

nx.map({
	{
		"<CR>",
		function()
			genie.create_new_snippet_or_add_placeholder()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true))
		end,
		{ "x" },
	},
	{
		";<CR>",
		function()
			genie.finalize_snippet()
		end,
	},
})

nx.cmd({
	"SnipCreate",
	function()
		vim.notify("<cr> to start and ;<cr> to add the variables")
	end,
	{ force = true },
})
