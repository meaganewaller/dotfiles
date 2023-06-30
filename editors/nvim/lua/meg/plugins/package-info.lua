local package_info = require("package-info")

local config = {
	icons = {
		enable = true,
		style = {
			up_to_date = "|  ",
			outdated = "|  ",
		},
	},
	autostart = true,
	hide_up_to_date = true,
	hide_unstable_versions = false,
}

package_info.setup(config)
