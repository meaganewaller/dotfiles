local wezterm = require("wezterm")

local menus = require("menus")
local behavior = require("behavior")
local ui = require("ui")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

ui.apply_to_config(config)
behavior.apply_to_config(config)
menus.apply_to_config(config)

return config
