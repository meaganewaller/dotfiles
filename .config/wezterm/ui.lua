local wez = require("wezterm")
local plugin_config = require("plugin_config")
local tabline = wez.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
local workspace = wez.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

local M = {}

M.apply_to_config = function(c)
	c.color_scheme = "Catppuccin Mocha"
	local scheme = wez.color.get_builtin_schemes()["Catppuccin Mocha"]
	c.colors = {
		background = scheme.background,
		cursor_border = scheme.ansi[2],
		tab_bar = {
			background = plugin_config.tab_background,
			active_tab = {
				bg_color = scheme.background,
				fg_color = scheme.ansi[3],
			},
			inactive_tab = {
				bg_color = plugin_config.tab_background,
				fg_color = scheme.ansi[1],
			},
			inactive_tab_hover = {
				bg_color = plugin_config.tab_background,
				fg_color = scheme.ansi[1],
			},
		},
	}
	c.window_padding = {
		left = 5,
		right = 5,
		top = 5,
		bottom = 5,
	}
	c.window_background_image_hsb = {
		brightness = 1,
		saturation = 1,
		hue = 1,
	}
	c.window_decorations = "RESIZE"
	c.show_new_tab_button_in_tab_bar = false
	c.enable_scroll_bar = false
	c.tab_bar_at_bottom = false
	c.tab_max_width = 50
	c.use_fancy_tab_bar = false
	workspace.get_choices = function(opts)
		return workspace.choices.get_workspace_elements({})
	end
	tabline.setup(plugin_config.tabline)
end

return M
