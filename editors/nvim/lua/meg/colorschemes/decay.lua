local present, decay = pcall(require, "decay")
if not present then
	return
end

local STYLE = "default"
local colors = require("decay.core").get_colors(STYLE)

decay.setup({
	style = STYLE,
	italics = {
		comments = true,
		code = true,
	},
	cmp = {
		block_kind = false,
	},
})

local M = {}

function M.set_hl()
	nx.hl({
		{ "FloatBorder", fg = "FloatBorder:fg" },
		{ "CursorLine", bg = "CursorLine:bg" },
		{ { "FloatShadow", "FloatShadowThrough" }, link = "Float" },
	})

	if vim.o.background ~= "light" then
		nx.hl({
			{ "WinSeparator", fg = "WinSeparator:fg:#b-1" },
		})
	else
		nx.hl({
			{ "TabLine", link = "DiffChange" },
			{ "BufferLineOffset", link = "TabLine" },
		})
	end
end

return M
