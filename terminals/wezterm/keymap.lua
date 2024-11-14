local session = require("session")
local wezterm = require("wezterm") --[[@as wezterm.WezTerm]]

local act = wezterm.action

---@param config wezterm.Config
return function(config)
    config.disable_default_key_bindings = true
    config.keys = {
        {
            key = "c",
            mods = "CTRL|SHIFT",
            action = act.CopyTo("Clipboard"),
        },
        {
            key = "v",
            mods = "CTRL|SHIFT",
            action = act.PasteFrom("Clipboard"),
        },
        {
            key = "p",
            mods = "CTRL|SHIFT",
            action = act.ActivateCommandPalette,
        },
        {
            key = "+",
            mods = "CTRL|SHIFT",
            action = act.IncreaseFontSize,
        },
        {
            key = "-",
            mods = "CTRL|SHIFT",
            action = act.DecreaseFontSize,
        },
        {
            key = "s",
            mods = "CTRL|SHIFT",
            action = wezterm.action_callback(function(window, pane)
                window:perform_action(
                    act.PromptInputLine({
                        description = "Input session name",
                        action = wezterm.action_callback(function(_, _, name)
                            if not name then
                                window:toast_notification("Session", "cancel")
                                return
                            end
                            session.save(name)
                        end),
                    }),
                    pane
                )
            end),
        },
        {
            key = "a",
            mods = "CTRL",
            action = act.ActivateKeyTable({ name = "tmux_keys", one_shot = true }),
        },
        {
            key = "b",
            mods = "CTRL",
            action = act.SendKey({ key = "a", mods = "CTRL" }),
        },
    }

    config.key_tables = {
        tmux_keys = {
            -- pane
            {
                key = "z",
                action = act.TogglePaneZoomState,
            },
            {
                key = "x",
                action = act.CloseCurrentPane({ confirm = true }),
            },
            {
                key = "v",
                action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
            },
            {
                key = "s",
                action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
            },
            {
                key = "h",
                action = act.ActivatePaneDirection("Left"),
            },
            {
                key = "j",
                action = act.ActivatePaneDirection("Down"),
            },
            {
                key = "k",
                action = act.ActivatePaneDirection("Up"),
            },
            {
                key = "l",
                action = act.ActivatePaneDirection("Right"),
            },

            {
                key = "H",
                action = act.Multiple({
                    act.AdjustPaneSize({ "Left", 2 }),
                    act.ActivateKeyTable({ name = "resize_pane", timeout_milliseconds = 600, one_shot = false, until_unknow = true }),
                }),
            },
            {
                key = "J",
                action = act.Multiple({
                    act.AdjustPaneSize({ "Down", 2 }),
                    act.ActivateKeyTable({ name = "resize_pane", timeout_milliseconds = 600, one_shot = false, until_unknow = true }),
                }),
            },
            {
                key = "K",
                action = act.Multiple({
                    act.AdjustPaneSize({ "Up", 2 }),
                    act.ActivateKeyTable({ name = "resize_pane", timeout_milliseconds = 600, one_shot = false, until_unknow = true }),
                }),
            },
            {
                key = "L",
                action = act.Multiple({
                    act.AdjustPaneSize({ "Right", 2 }),
                    act.ActivateKeyTable({ name = "resize_pane", timeout_milliseconds = 600, one_shot = false, until_unknow = true }),
                }),
            },
            -- tab
            {
                key = "c",
                action = act.SpawnTab("CurrentPaneDomain"),
            },
            {
                key = "1",
                action = act.ActivateTab(0),
            },
            {
                key = "2",
                action = act.ActivateTab(1),
            },
            {
                key = "3",
                action = act.ActivateTab(2),
            },
            {
                key = "4",
                action = act.ActivateTab(3),
            },
            {
                key = "5",
                action = act.ActivateTab(4),
            },
            {
                key = "6",
                action = act.ActivateTab(5),
            },
            {
                key = "7",
                action = act.ActivateTab(6),
            },
        },

        resize_pane = {
            {
                key = "H",
                action = act.AdjustPaneSize({ "Left", 2 }),
            },
            {
                key = "J",
                action = act.AdjustPaneSize({ "Down", 2 }),
            },
            {
                key = "K",
                action = act.AdjustPaneSize({ "Up", 2 }),
            },
            {
                key = "L",
                action = act.AdjustPaneSize({ "Right", 2 }),
            },
        },
    }
end
