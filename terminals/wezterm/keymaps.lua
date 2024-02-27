local wezterm = require("wezterm")
local platform = require("utils.platform")
local workspaceHandler = require("workspace")

local action = wezterm.action

-- | name            | MacOS     | Windows
-- ---------------------------------------
-- | SUPER, CMD, WIN | Command   | Win
-- | CTRL            | Ctrl      | Ctrl
-- | SHIFT           | Shift     | Shift
-- | ALT, OPT, META  | Option    | Alt
local mod = "SHIFT|SUPER"
local alt = "SUPER"
if platform.is_win or platform.is_linux then
  mod = "SHIFT|ALT"
  alt = "ALT"
end

local M = {}

---@param cfg table
M.setup = function(cfg)
  local toggleBlur = wezterm.action_callback(function(window)
    if window:effective_config().window_background_opacity == 1 then
      window:set_config_overrides({ window_background_opacity = 0.75, win32_system_backdrop = "Acrylic" })
    else
      window:set_config_overrides({ window_background_opacity = 1, win32_system_backdrop = "None" })
    end
  end)

  -- disable all the default mappings
  cfg.disable_default_key_bindings = true

  -- leader key: CTRL + a
  cfg.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

  cfg.keys = {
    -- window management: splits, movement, spawn
    { mods = "LEADER", key = "|", action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { mods = "LEADER", key = "-", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { mods = "LEADER", key = "_", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) }, --window
    { mods = "LEADER", key = "x", action = action.CloseCurrentPane({ confirm = true }) },
    { mods = "LEADER", key = "]", action = action.ActivateTabRelative(1) },
    { mods = "LEADER", key = "[", action = action.ActivateTabRelative(-1) },
    { mods = "LEADER", key = "t", action = action.SplitHorizontal },
    { mods = "LEADER", key = "c", action = action.SpawnTab("CurrentPaneDomain") },
    { mods = "LEADER", key = "l", action = action.ShowLauncher },
    { mods = "LEADER", key = "p", action = action.ActivateCommandPalette },
    {
      mods = "LEADER",
      key = "n",
      action = action.PromptInputLine({
        description = wezterm.format({
          { Attribute = { Intensity = "Bold" } },
          { Foreground = { AnsiColor = "Fuchsia" } },
          { Text = "Enter name for new workspace" },
        }),
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:perform_action(
              action.SwitchToWorkspace({
                name = line,
              }),
              pane
            )
            wezterm.reload_configuration()
          end
        end),
      }),
    },
    {
      mods = "LEADER",
      key = "w",
      action = wezterm.action_callback(function(window, pane)
        workspaceHandler.selectWorkspace(window, pane)
      end),
    },
    {
      mods = "LEADER",
      key = "C",
      action = action.ClearScrollback("ScrollbackAndViewport"),
    },
    { mods = alt, key = "UpArrow", action = action.ActivatePaneDirection("Up") },
    { mods = alt, key = "DownArrow", action = action.ActivatePaneDirection("Down") },
    { mods = alt, key = "LeftArrow", action = action.ActivatePaneDirection("Left") },
    { mods = alt, key = "RightArrow", action = action.ActivatePaneDirection("Right") },
    { mods = mod, key = "[", action = action.ActivateTabRelative(-1) },
    { mods = mod, key = "]", action = action.ActivateTabRelative(1) },
    { mods = mod, key = "{", action = action.ActivateTabRelative(-1) }, -- windows
    { mods = mod, key = "}", action = action.ActivateTabRelative(1) }, -- windows

    -- text management: copy-paste, font size
    { mods = "CTRL|SHIFT", key = "c", action = action.CopyTo("Clipboard") },
    { mods = "CTRL|SHIFT", key = "v", action = action.PasteFrom("Clipboard") },
    { mods = "CTRL|SHIFT", key = "_", action = action.DecreaseFontSize },
    { mods = "CTRL|SHIFT", key = "+", action = action.IncreaseFontSize },
    { mods = "CTRL|SHIFT", key = ")", action = action.ResetFontSize },

    -- UI
    { mods = mod, key = "b", action = toggleBlur },
  }

  -- url openr with mouse
  cfg.mouse_bindings = {
    {
      mods = "CTRL",
      event = { Up = { streak = 1, button = "Left" } },
      action = action.OpenLinkAtMouseCursor,
    },
    -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
    {
      event = { Down = { streak = 1, button = "Left" } },
      mods = "CTRL",
      action = action.Nop,
    },
  }
end

return M
