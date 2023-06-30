-- https://github.com/rcarriga/nvim-notify#usage
local notify = require("notify")

-- { == Configuration ==> =====================================================

notify.setup({
	render = "minimal", -- Render function for notifications. See notify-render()
	timeout = 2500, -- Default timeout for notifications
	-- For stages that change opacity this is treated as the highlight behind the window
	background_colour = "PMenu", -- Highlight group or hex value "#000000"
	minimum_width = 10, -- Minimum width for notification windows
})
-- <== }

vim.notify = notify
