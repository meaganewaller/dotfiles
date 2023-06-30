require("rose-pine").setup({
	variant = "auto",
	dark_variant = "moon",
})

local M = {}

local palette = require("rose-pine.palette")

function M.set_hl()
	-- remove additional dark border around float borders (e.g. wilder command paborder
	nx.hl({
		{ "FloatBorder", fg = "FloatBorder:fg" },
		{ "CursorLine", bg = "CursorLine:bg:#b+15" },
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
