local wezterm = require 'wezterm'
local session = require 'session'
local config = wezterm.config_builder()

config.font_size = 14

config.font = wezterm.font_with_fallback({ "FiraCode Nerd Font" })

config.window_background_opacity = 0.90
config.color_scheme = "Snazzy"
config.status_update_interval = 500

require("keymap")(config)
require("components")(config)
require("program")(config)

wezterm.on("gui-startup", function(cmd) session.load() end)

return config
