
local wezterm = require("wezterm")
local act = wezterm.action

-- Create a function that takes config parameters and returns a config table
local function make_config(config)
	config.leader = { key = "Space", mods = "CMD|SHIFT", timeout_milliseconds = 2000 }

	config.keys = {
		{ key = "P", mods = "CMD|SHIFT", action = wezterm.action.ActivateCommandPalette },
		{ key = "Enter", mods = "LEADER", action = act.QuickSelect },
		{ key = "Enter", mods = "LEADER|SHIFT", action = act.ActivateCopyMode },
		{ key = "LeftArrow", mods = "CMD|SHIFT", action = act.ActivateTabRelative(-1) },
		{ key = "RightArrow", mods = "CMD|SHIFT", action = act.ActivateTabRelative(1) },
		{ key = "LeftArrow", mods = "CMD|ALT", action = act.ActivateTabRelative(-1) },
		{ key = "RightArrow", mods = "CMD|ALT", action = act.ActivateTabRelative(1) },
		{ key = "t", mods = "CMD|SHIFT", action = act.ShowTabNavigator },
		{ key = "H", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
		{ key = "L", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },
		{ key = "K", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
		{ key = "J", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },

		-- Launchers
		{
			key = "l",
			mods = "LEADER",
			action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS|DOMAINS" }),
		},
		{
			key = "s",
			mods = "LEADER",
			action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
		},

		-- Acticate Pane Management mode.
		{
			key = "w",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				name = "PaneManagement",
				one_shot = false,
				timeout_milliseconds = 8000,
				until_unknown = false,
				prevent_fallback = true,
			}),
		},

		-- Acticate Tab Management mode.
		{
			key = "t",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				name = "TabManagement",
				one_shot = false,
				timeout_milliseconds = 8000,
				until_unknown = false,
				prevent_fallback = true,
			}),
		},
	}

	config.key_tables = {
		PaneManagement = {
			-- Pane Activation
			{ key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
			{ key = "h", action = act.ActivatePaneDirection("Left") },
			{ key = "RightArrow", action = act.ActivatePaneDirection("Right") },
			{ key = "l", action = act.ActivatePaneDirection("Right") },
			{ key = "UpArrow", action = act.ActivatePaneDirection("Up") },
			{ key = "k", action = act.ActivatePaneDirection("Up") },
			{ key = "DownArrow", action = act.ActivatePaneDirection("Down") },
			{ key = "j", action = act.ActivatePaneDirection("Down") },

			-- Pane Resizing
			{ key = "LeftArrow", mods = "SHIFT", action = act.AdjustPaneSize({ "Left", 1 }) },
			{ key = "h", mods = "SHIFT", action = act.AdjustPaneSize({ "Left", 1 }) },
			{ key = "RightArrow", mods = "SHIFT", action = act.AdjustPaneSize({ "Right", 1 }) },
			{ key = "l", mods = "SHIFT", action = act.AdjustPaneSize({ "Right", 1 }) },
			{ key = "UpArrow", mods = "SHIFT", action = act.AdjustPaneSize({ "Up", 1 }) },
			{ key = "k", mods = "SHIFT", action = act.AdjustPaneSize({ "Up", 1 }) },
			{ key = "DownArrow", mods = "SHIFT", action = act.AdjustPaneSize({ "Down", 1 }) },
			{ key = "j", mods = "SHIFT", action = act.AdjustPaneSize({ "Down", 1 }) },

			-- Split Pane
			{ key = "s", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
			{ key = "v", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

			-- Rotate Panes
			{ key = "r", action = act.RotatePanes("Clockwise") },
			{ key = "R", mods = "SHIFT", action = act.RotatePanes("CounterClockwise") },

			-- Swap pane position
			{ key = "m", action = act.PaneSelect({ mode = "SwapWithActive" }) },

			-- Zoom pane
			{ key = "z", action = act.TogglePaneZoomState },

			-- Close the active pane
			{ key = "X", mods = "SHIFT", action = act.CloseCurrentPane({ confirm = false }) },

			-- Take the selected pane and create a new tab with it.
			{
				key = "!",
				action = wezterm.action_callback(function(_, pane)
					local tab, window = pane:move_to_new_tab()
				end),
			},

			-- Tab Selection
			{ key = "1", action = act.ActivateTab(0) },
			{ key = "2", action = act.ActivateTab(1) },
			{ key = "3", action = act.ActivateTab(2) },
			{ key = "4", action = act.ActivateTab(3) },
			{ key = "5", action = act.ActivateTab(4) },
			{ key = "6", action = act.ActivateTab(5) },
			{ key = "7", action = act.ActivateTab(6) },
			{ key = "8", action = act.ActivateTab(7) },
			{ key = "9", action = act.ActivateTab(8) },

			-- Exit pane management mode
			{ key = "Escape", action = "PopKeyTable" },
			{ key = "Enter", action = "PopKeyTable" },
		},
		TabManagement = {

			-- Select Tab
			{ key = "LeftArrow", action = act.ActivateTabRelative(-1) },
			{ key = "h", action = act.ActivateTabRelative(-1) },
			{ key = "RightArrow", action = act.ActivateTabRelative(1) },
			{ key = "l", action = act.ActivateTabRelative(1) },

			-- Move Tab
			{ key = "LeftArrow", mods = "SHIFT", action = act.MoveTabRelative(-1) },
			{ key = "h", mods = "SHIFT", action = act.MoveTabRelative(-1) },
			{ key = "RightArrow", mods = "SHIFT", action = act.MoveTabRelative(1) },
			{ key = "l", mods = "SHIFT", action = act.MoveTabRelative(1) },

			-- Activate Tab Number
			{ key = "1", action = act.ActivateTab(0) },
			{ key = "2", action = act.ActivateTab(1) },
			{ key = "3", action = act.ActivateTab(2) },
			{ key = "4", action = act.ActivateTab(3) },
			{ key = "5", action = act.ActivateTab(4) },
			{ key = "6", action = act.ActivateTab(5) },
			{ key = "7", action = act.ActivateTab(6) },
			{ key = "8", action = act.ActivateTab(7) },
			{ key = "9", action = act.ActivateTab(8) },

			-- Rename Tab
			{
				key = "r",
				action = act.Multiple({
					"PopKeyTable",
					act.PromptInputLine({
						description = "Enter new name for tab",
						action = wezterm.action_callback(function(window, pane, line)
							if line then
								window:active_tab():set_title(line)
							end
						end),
					}),
				}),
			},

			-- Create Tab
			{ key = "n", action = act.SpawnTab("CurrentPaneDomain") },
			{
				key = "N",
				mods = "SHIFT",
				action = act.Multiple({
					"PopKeyTable",
					act.PromptInputLine({
						description = "Enter command to spawn in new Tab",
						action = wezterm.action_callback(function(window, pane, line)
							if line then
								window:mux_window():spawn_tab({ args = { line } })
							end
						end),
					}),
				}),
			},

			-- Close Current Tab
			{ key = "X", mods = "SHIFT", action = act.CloseCurrentTab({ confirm = true }) },

			-- Exit tab management mode
			{ key = "Escape", action = "PopKeyTable" },
			{ key = "Enter", action = "PopKeyTable" },
		},
	}
end

return {
	make_config = make_config,
}
