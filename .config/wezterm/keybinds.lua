local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local M = {}

function M.setup(config)
    config.key_map_preference = "Physical"
    config.mouse_bindings = {
        {
            event = { Up = { streak = 1, button = "Left" } },
            mods = "CTRL|SHIFT",
            action = "OpenLinkAtMouseCursor",
        },
    }

    config.leader = {
        key = "a",
        mods = "CTRL",
        timeout_milliseconds = 2000,
    }

    config.keys = {
        { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
        { key = "f", mods = "ALT", action = act.TogglePaneZoomState },
        { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
        { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
        { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
        { key = "w", mods = "LEADER", action = act.ShowTabNavigator },
        {
            key = ",",
            mods = "LEADER",
            action = act.PromptInputLine({
                description = "Enter new name for tab",
                action = wezterm.action_callback(function(window, pane, line)
                    if line then
                        window:active_tab():set_title(line)
                    end
                end),
            }),
        },

        -- Vertical split
        {
            key = "|",
            mods = "LEADER|SHIFT",
            action = act.SplitPane({
                direction = "Right",
                size = { Percent = 50 },
            }),
        },
        -- Horizontal split
        {
            -- -
            key = "-",
            mods = "LEADER",
            action = act.SplitPane({
                direction = "Down",
                size = { Percent = 50 },
            }),
        },
        -- LEADER + (h,j,k,l) to move between panes
        { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
        { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
        { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
        { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
        -- ALT + (h,j,k,l) to resize panes
        { key = "h", mods = "ALT", action = act.AdjustPaneSize({ "Left", 5 }) },
        { key = "j", mods = "ALT", action = act.AdjustPaneSize({ "Down", 5 }) },
        { key = "k", mods = "ALT", action = act.AdjustPaneSize({ "Up", 5 }) },
        { key = "l", mods = "ALT", action = act.AdjustPaneSize({ "Right", 5 }) },

        -- Swapping panes
        { key = "{", mods = "LEADER|SHIFT", action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }) },
        -- CLosing panes and tabs
        { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
        { key = "&", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },

        -- Attaching and detaching to muxer
        { key = "a", mods = "LEADER", action = act.AttachDomain("unix") },
        { key = "d", mods = "LEADER", action = act.DetachDomain({ DomainName = "unix" }) },
        -- Rename current session; analagous to command in tmux
        {
            key = "$",
            mods = "LEADER|SHIFT",
            action = act.PromptInputLine({
                description = "Enter new name for session",
                action = wezterm.action_callback(function(window, pane, line)
                    if line then
                        mux.rename_workspace(window:mux_window():get_workspace(), line)
                    end
                end),
            }),
        },
        -- Show list of workspaces
        { key = "s", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },
    }
end

return M
