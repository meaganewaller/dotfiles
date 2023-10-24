-- https://github.com/s1n7ax/nvim-window-picker

-- { == Configuration ==> =====================================================

require("window-picker").setup({
	highlights = {
		statusline = {
			unfocused = {
				bg = require("meg.utils").get_hl("StatusLine", "bg"),
				bold = true,
			},
		},
	},
})

-- <== }
