-- https://github.com/numToStr/Comment.nvim

require("Comment").setup({
  padding = true,
  sticky = true,
  ignore = nil,
  toggler = {
    line = "gcc",
    block = "gbc",
  },
  opleader = {
    ---Line-comment keymap
    line = "gc",
    ---Block-comment keymap
    block = "gb",
  },
  ---LHS of extra mappings
  ---@type table
  extra = {
    ---Add comment on the line above
    above = "gcO",
    ---Add comment on the line below
    below = "gco",
    ---Add comment at the end of line
    eol = "gcA",
  },
  ---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
  ---@type table
  mappings = {
    basic = true,
    extra = true,
  },
  ---Pre-hook, called before commenting the line
  ---@type function
--  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),

  ---Post-hook, called after commenting is done
  ---@type function
  post_hook = nil,
})
-- <== }

-- { == Keymaps ==> ===========================================================

local toggle = require("Comment.api").toggle

nx.map({
	-- GUIs + some TUIs (e.g, kitty) can map <C-/> directly
	{ "<C-/>", toggle.linewise.current, { "n", "i" }, desc = "Toggle Line Comment" },
	-- {"<C-/>", function() toggle.linewise(vim.fn.visualmode()) end, "v",  desc = "Toggle Line Comment" },
	{
		"<C-/>",
		"<Esc><Cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
		"v",
		desc = "Toggle Line Comment",
	},
	{ "<leader><C-/>", toggle.blockwise.current, desc = "Toggle Block Comment", wk_label = "ignore" },
	{
		"<leader><C-/>",
		function()
			toggle.blockwise(vim.fn.visualmode())
		end,
		"v",
		desc = "Toggle Block Comment",
		wk_label = "ignore",
	},
	-- map '<C-_>' for other TUIs to recognize '<C-/>'
	{ "<C-_>", toggle.linewise.current, { "n", "i" }, desc = "Toggle Line Comment" },
	-- { "<C-_>", function() toggle.linewise(vim.fn.visualmode()) end, "v",  desc = "Toggle Line Comment" },
	{
		"<C-_>",
		"<Esc><Cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
		"v",
		desc = "Toggle Line Comment",
	},
	{
		"<leader><C-_>",
		function()
			toggle.blockwise()
		end,
		desc = "Toggle Block Comment",
		wk_label = "ignore",
	},
	{
		"<leader><C-_>",
		function()
			toggle.blockwise(vim.fn.visualmode())
		end,
		"v",
		desc = "Toggle Block Comment",
		wk_label = "ignore",
	},
})
-- <== }
