-- https://github.com/hrsh7th/nvim-cmp

local cmp = require("cmp")
require("luasnip.loaders.from_vscode").lazy_load()

-- { == Configuration ==> ====================================================

cmp.setup({
	method = "getCompletionsCycling",
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	completion = {
		completeopt = vim.o.completeopt,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-e>"] = cmp.mapping(cmp.mapping.close(), { "i", "s", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "copilot" },
		{ name = "codeium" },
		{ name = "tabnine" },
		{ name = "path" },
		{ name = "emoji" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "fish" },
	},
	formatting = {
		format = function(_, item)
			local icons = {
				Array = " ",
				Boolean = " ",
				Class = " ",
				Color = " ",
				Constant = " ",
				Constructor = " ",
				Copilot = " ",
				Codeium = "󰘦 ",
				Enum = " ",
				EnumMember = " ",
				Event = " ",
				Field = " ",
				File = " ",
				Folder = " ",
				Function = " ",
				Interface = " ",
				Key = " ",
				Keyword = " ",
				Method = " ",
				Module = " ",
				Namespace = " ",
				Null = " ",
				Number = " ",
				Object = " ",
				Operator = " ",
				Package = " ",
				Property = " ",
				Reference = " ",
				Snippet = " ",
				String = " ",
				Struct = " ",
				Text = " ",
				TypeParameter = " ",
				Unit = " ",
				Value = " ",
				Variable = " ",
			}
			if icons[item.kind] then
				item.kind = icons[item.kind] .. item.kind
			end
			return item
		end,
	},
	window = { border = "rounded" },
	experimental = {
		ghost_text = {
			hl_group = "LspCodeLens",
		},
	},
})

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "Man", "!" },
			},
		},
	}),
})

cmp.setup.filetype("gitcommit", {
	sources = {
		{ name = "commit" },
		{ name = "emoji", option = { insert = false } },
	},
})

cmp.setup.filetype("markdown", {
	sources = {
		{ name = "emoji", option = { insert = false } },
	},
})

-- local cmp_kinds = {
-- 	Text = "",
-- 	Method = "",
-- 	Function = "",
-- 	Constructor = "",
-- 	Field = "",
-- 	Variable = "",
-- 	Class = "",
-- 	Interface = "",
-- 	Module = "",
-- 	Property = "",
-- 	Unit = "",
-- 	Value = "",
-- 	Enum = "",
-- 	Keyword = "",
-- 	Snippet = "",
-- 	Color = "",
-- 	File = "",
-- 	Reference = "",
-- 	Folder = "",
-- 	EnumMember = "",
-- 	Constant = "",
-- 	Struct = "",
-- 	Event = "",
-- 	Operator = "",
-- 	TypeParameter = "",
-- }
--
-- local config = {
-- 	snippet = {
-- 		expand = function(args)
-- 			require("luasnip").lsp_expand(args.body)
-- 		end,
-- 	},
-- 	sources = {
-- 		{ name = "nvim_lsp" },
-- 		{ name = "nvim_lua" },
-- 		{ name = "copilot" },
-- 		{ name = "codeium" },
-- 		{ name = "cmp_tabnine" },
-- 		{ name = "path" },
-- 		{ name = "emoji" },
-- 		{ name = "luasnip" },
-- 		{ name = "buffer" },
-- 		{ name = "fish" },
-- 		{ name = "cmp_tabnine" },
-- 		{ name = "nerdfont" },
-- 	},
-- 	confirm_opts = {
-- 		behavior = cmp.ConfirmBehavior.Replace,
-- 		select = false,
-- 	},
-- 	formatting = {
-- 		fields = { "kind", "abbr", "menu" },
-- 		format = function(entry, item)
-- 			if entry.source.name == "cmp_tabnine" then
-- 				item.kind = "Tabnine"
-- 			end
-- 			item.menu = item.kind
--
-- 			local icon = cmp_kinds[item.kind]
-- 			if entry.source.name == "cmp_tabnine" then
-- 				icon = "⌬ "
-- 			end
-- 			if entry.source.name == "copilot" then
-- 				icon = " "
-- 			end
-- 			if entry.source.name == "codeium" then
-- 				icon = "󰘦 "
-- 			end
-- 			item.kind = icon
--
-- 			return item
-- 		end,
-- 	},
-- 	window = {
-- 		completion = {
-- 			border = nx.opts.float_win_border,
-- 			scrollbar = "║",
-- 			winhighlight = "Normal:Normal", -- transparent bg
-- 		},
-- 		documentation = {
-- 			border = nx.opts.float_win_border,
-- 			scrollbar = "║",
-- 			winhighlight = "Normal:Normal",
-- 		},
-- 	},
-- 	experimental = {
-- 		ghost_text = false,
-- 		-- native_menu = false,
-- 	},
-- 	mapping = {},
-- }
-- -- <== }
--
-- -- { == Keymaps ==> ==========================================================
--
-- config.mapping = {
-- 	-- Navigation completion suggestion
-- 	-- ["<C-n>"] = cmp.mapping.select_next_item(), -- use for snippet navigation
-- 	-- ["<C-p>"] = cmp.mapping.select_prev_item(), -- use for snippet navigation
-- 	["<C-j>"] = cmp.mapping.select_next_item(),
-- 	["<C-k>"] = cmp.mapping.select_prev_item(),
-- 	["<Down>"] = cmp.mapping.select_next_item(),
-- 	["<Up>"] = cmp.mapping.select_prev_item(),
--
-- 	-- Misc
-- 	["<C-d>"] = cmp.mapping.scroll_docs(-4),
-- 	["<C-f>"] = cmp.mapping.scroll_docs(4),
-- 	["<C-e>"] = cmp.mapping.close(),
--
-- 	-- Invoke completion manually
-- 	["<C-Space>"] = cmp.mapping.complete(),
--
-- 	-- Confrim completion
-- 	["<C-l>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
-- 	["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
-- 	-- ["<Tab>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
-- 	-- Use tab for codeium and it should fall back to cmp when it's inactive
-- 	["<Tab>"] = cmp.mapping(function(fallback)
-- 		if cmp.visible() and vim.g.codeium_enabled ~= 1 then
-- 			cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
-- 		else
-- 			fallback()
-- 		end
-- 	end, { "i", "s" }),
-- }
-- -- <== }
--
-- cmp.setup(config)
--
-- cmp.setup.cmdline(":", {
-- 	mapping = cmp.mapping.preset.cmdline,
-- 	sources = cmp.config.sources({
-- 		{ name = "path" },
-- 	}, {
-- 		{
-- 			name = "cmdline",
-- 			option = {
-- 				ignore_cmds = { "Man", "!" },
-- 			},
-- 		},
-- 	}),
-- })
--
-- cmp.setup.filetype("gitcommit", {
-- 	sources = {
-- 		{ name = "commit" },
-- 		{ name = "emoji", option = { insert = false } },
-- 	},
-- })
--
-- cmp.setup.filetype("markdown", {
-- 	sources = {
-- 		{ name = "emoji", option = { insert = false } },
-- 	},
-- })
