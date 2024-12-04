local wezterm = require("wezterm")
local ui = require("ui")
local font = require("font")
local keys = require("keymap")
local plugin_config = require("plugin_config")
local smart_workspace = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local quick_domains = wezterm.plugin.require("https://github.com/DavidRR-F/quick_domains.wezterm")

local c = {}
if wezterm.config_builder then
	c = wezterm.config_builder()
end
c.default_prog = { "/opt/homebrew/bin/zsh", "-l" }
c.default_workspace = "main"
c.disable_default_key_bindings = true
c.enable_wayland = false
c.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
c.keys = keys.general
c.key_tables = { tmux = keys.tmux }
c.launch_menu = {
	{ label = "󰊢 GitHub Dashboard", args = { "gh", "dash" } },
	{ label = " Lazy Docker", args = { "lazydocker" } },
	{ label = "󱃾 K9S", args = { "k9s" } },
	{ label = "󰻫 Yazi", args = { "yazi" } },
}

ui.apply_to_config(c)
font.apply_to_config(c)

quick_domains.apply_to_config(c, plugin_config.quick_domains)
smart_workspace.apply_to_config(c)

return c
