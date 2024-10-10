local wezterm = require("wezterm")
local nf = wezterm.nerdfonts
local helpers = require("utils.helpers")

local function left_status(window, pane)
	local elements = {}
	local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
	local SOLID_LEFT_ARROW = " " .. nf.pl_right_hard_divider

	table.insert(elements, { Foreground = { Color = "#1e2030" } })
	table.insert(elements, { Background = { Color = "#b7bdf8" } })

	table.insert(elements, { Text = " " .. nf.dev_terminal .. " " })

	if pane:get_domain_name() ~= "local" then
		table.insert(elements, { Text = " " .. nf.pl_right_soft_divider })
		table.insert(elements, { Text = " " .. nf.cod_workspace_trusted })
		table.insert(elements, { Text = " " .. pane:get_domain_name() })
	end

	if window:active_workspace() ~= "default" then
		table.insert(elements, { Text = " " .. nf.pl_right_soft_divider })
		table.insert(elements, { Text = " " .. nf.md_domain })
		table.insert(elements, { Text = " " .. window:active_workspace() })
	end

	-- arrow color based on if tab is first pane
	if helpers.get_tab_index(window) ~= 0 then
		table.insert(elements, { Foreground = { Color = "#1e2030" } })
	else
		table.insert(elements, ARROW_FOREGROUND)
	end
	table.insert(elements, { Text = SOLID_LEFT_ARROW })

	window:set_left_status(wezterm.format(elements))
end

local function right_status(window, pane)
	local elements = {}

	local SOLID_RIGHT_ARROW = nf.pl_left_hard_divider .. " "

	local active_bg = "#1e2030"

	if window:leader_is_active() then
		-- table.insert(elements, "ResetAttributes")
		table.insert(elements, { Foreground = { Color = active_bg } })
		active_bg = "#bb0000"
		table.insert(elements, { Background = { Color = active_bg } })
		table.insert(elements, { Text = SOLID_RIGHT_ARROW })
		table.insert(elements, { Foreground = { Color = "#1e2030" } })
		table.insert(elements, { Text = nf.weather_wind_direction .. "  " })
		table.insert(elements, "ResetAttributes")
	end

	-- Key Table
	if window:active_key_table() then
		local text = table.concat({
			nf.md_keyboard,
			window:active_key_table(),
		}, " ")
		table.insert(elements, { Foreground = { Color = active_bg } })
		active_bg = "orange"
		table.insert(elements, { Background = { Color = active_bg } })
		table.insert(elements, { Text = SOLID_RIGHT_ARROW })
		table.insert(elements, { Foreground = { Color = "#1e2030" } })
		table.insert(elements, { Text = text .. " " })
		table.insert(elements, "ResetAttributes")
	end

	if helpers.get_active_pane_info(pane).is_zoomed then
		table.insert(elements, { Foreground = { Color = active_bg } })
		active_bg = "#00b0bb"
		table.insert(elements, { Background = { Color = active_bg } })
		table.insert(elements, { Text = SOLID_RIGHT_ARROW })
		table.insert(elements, { Foreground = { Color = "#1e2030" } })
		table.insert(elements, { Text = nf.md_magnify .. " Zoomed " })
		table.insert(elements, "ResetAttributes")
	end

	-- Date pill
	local date = wezterm.strftime(" %Y-%m-%d %H:%M ")
	table.insert(elements, { Background = { Color = "#b7bdf8" } })
	table.insert(elements, { Foreground = { Color = active_bg } })
	table.insert(elements, { Text = SOLID_RIGHT_ARROW })
	table.insert(elements, { Foreground = { Color = "#1e2030" } })
	table.insert(elements, { Text = nf.fa_clock_o .. date })

	window:set_right_status(wezterm.format(elements))
end

wezterm.on("update-status", function(window, pane)
	left_status(window, pane)
	right_status(window, pane)
end)
