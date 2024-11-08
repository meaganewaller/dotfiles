local wezterm   = require 'wezterm'
local ui        = require "ui"
local program   = require "program"
local keymaps   = require "keymaps"
local tab_title = require "events.tab_title"
local zen_mode  = require "events.zen_mode"

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

ui.setup(config)
program.setup(config)
keymaps.setup(config)
tab_title.setup(ui.colors)
zen_mode.setup()

return config
-- local config = wezterm.config_builder()
-- local helpers = require 'utils.helpers'
--
-- local regular_font = "SpaceMono Nerd Font"
-- local italic_font  = "VictorMono NF"
-- local frame_font   = "SpaceMono Nerd Font"
--
-- local colorscheme = "light-pink"
--
-- local colors = nil
--
-- ok, colors = pcall(wezterm.color.load_scheme, wezterm.home_dir .. "/.config/wezterm/colors/" .. colorscheme .. ".toml")
-- if not ok then
-- 	wezterm.log_info("external colorscheme not found using built-in colors")
-- 	colors = wezterm.get_builtin_color_schemes()[colorscheme]
-- end
--
-- -- Visual Decorations --
-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 15
-- config.native_macos_fullscreen_mode = true
-- config.window_frame = { font = wezterm.font(frame_font) }
-- config.front_end = "WebGpu"
--
-- -- Visual Settings --
-- config.font_size = 22
-- config.command_palette_font_size = 24
-- config.font = wezterm.font({ family = regular_font, weight = "Regular" })
-- config.font_rules = {
-- 	{
-- 		italic = true,
-- 		intensity = "Normal",
-- 		font = wezterm.font({ family = italic_font, style = "Italic" }),
-- 	},
-- 	{
-- 		italic = true,
-- 		intensity = "Half",
-- 		font = wezterm.font({
-- 			family = italic_font,
-- 			weight = "DemiBold",
-- 			style = "Italic",
-- 		}),
-- 	},
-- 	{
-- 		italic = true,
-- 		intensity = "Bold",
-- 		font = wezterm.font({
-- 			family = italic_font,
-- 			weight = "Bold",
-- 			style = "Italic",
-- 		}),
-- 	},
-- }
-- config.color_scheme = colorscheme
-- config.command_palette_fg_color = colors.foreground
-- config.command_palette_bg_color = colors.background
--
-- config.default_cursor_style = 'SteadyBar'
-- config.enable_scroll_bar = false
--
-- -- Tab Config
-- config.use_fancy_tab_bar = false
-- config.tab_max_width = 25
-- config.hide_tab_bar_if_only_one_tab = false
-- config.tab_bar_at_bottom = false
-- config.show_tabs_in_tab_bar = true
-- config.show_new_tab_button_in_tab_bar = false
--
-- -- Keyboard fiddling
-- config.send_composed_key_when_left_alt_is_pressed = true
--
-- -- Background Image --
-- config.background = {
-- 	{
-- 		source = { File = wezterm.config_dir .. "/backgrounds/crt-term.jpg" },
-- 		opacity = 0.90,
-- 		hsb = {
-- 			hue = 0.9,
-- 			saturation = 0.6,
-- 			brightness = 0.1,
-- 		},
-- 	},
-- }
--
-- -- Load the event handlers --
-- require('events.gui_startup')
-- require('events.format_tab_title')
-- require('events.format_window_title')
-- require('events.update_status')
-- require('keys').make_config(config)
--
-- if helpers.file_exists(wezterm.config_dir .. "/domains/ssh_domains.lua") then
-- 	config.ssh_domains = require('domains.ssh_domains')
-- end
--
-- return config
