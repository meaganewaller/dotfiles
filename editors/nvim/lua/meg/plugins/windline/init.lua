local windline = require("windline")
local style_meg = require("meg.plugins.windline.styles.meg")

-- { == Configuration ==> =====================================================

local config = {
	global_skip_filetypes = { "fern", "NvimTree", "lir", "filetree", "neo-tree" },
	statuslines = {
		style_meg.default,
		style_meg.quickfix,
		style_meg.explorer,
		style_meg.dashboard,
		style_meg.terminal,
		style_meg.diffview,
	},
}
-- <== }

-- { == Highlights ==> =====================================================

config.colors_name = function(colors)
	local inactive_fg, inactive_bg, filename_fg, statusline_path
	if vim.g.colors_name == "rose-pine" then
		local get_hl = require("meg.utils").get_hl
		nx.hl({ "StatusLine", bg = "TabLine:bg" })

		inactive_fg = require("windline.themes").get_hl_color("SignColumn")
		inactive_bg = get_hl("TabLine", "bg")
		filename_fg = require("rose-pine.palette").muted
		statusline_path = require("rose-pine.palette").subtle
	end

	if vim.g.colors_name == "tokyonight" then
		filename_fg = require("windline.themes").get_hl_color("StatusLine")
	end

	--- add new colors
	-- colors.FilenameFg = colors.white_light
	-- colors.FilenameBg = colors.black

	-- this color will not update if you change a colorscheme
	-- colors.gray = "#fefefe"

	-- dynamically get color from colorscheme hightlight group
	local searchFg, searchBg = require("windline.themes").get_hl_color("Search")
	colors.SearchFg = searchFg or colors.white
	colors.SearchBg = searchBg or colors.yellow
	colors.InactiveFg = inactive_fg or colors.InactiveFg
	colors.InactiveBg = inactive_bg or colors.InactiveBg

	colors.FilenameFg = filename_fg or colors.white_light
	colors.StatusLinePath = statusline_path or colors.white_light

	return colors
end
-- <== }

windline.setup(config)
