-- https://github.com/lukas-reineke/indent-blankline.nvim

local ibl = require("ibl")
local hooks = require("ibl.hooks")

-- { == Configuration ==> =====================================================

-- "▏" "│" "▎" "⎸"" "¦" "┆" "" "┊" ""
local indent_char = "▏"
if vim.g.loaded_gui then indent_char = "│" end

local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}

local config = {
	indent = { char = indent_char, highlight = highlight },
	scope = {},
}
-- <== }

-- { == Highlights ==> ========================================================


hooks.register(
	hooks.type.HIGHLIGHT_SETUP,
	function()
    nx.hl({
      { "RainbowRed", fg = "#E06C75" },
      { "RainbowYellow",  fg = "#E5C07B" },
      { "RainbowBlue",  fg = "#61AFEF" },
      { "RainbowOrange",  fg = "#D19A66" },
      { "RainbowGreen",  fg = "#98C379" },
      { "RainbowViolet",  fg = "#C678DD" },
      { "RainbowCyan",  fg = "#56B6C2" },
		})
	end
)
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
-- <== }

-- { == Load Setup ==> =======================================================

ibl.setup(config)
-- <== }
