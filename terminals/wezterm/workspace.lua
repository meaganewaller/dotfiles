local wezterm = require("wezterm")

local workspaces = {
  {
    id = ".dotfiles",
    label = wezterm.format({
      { Attribute = { Italic = true } },
      { Foreground = { AnsiColor = "Purple" } },
      { Text = ".dotfiles" },
    }),
    cwd = wezterm.home_dir .. "/.dotfiles",
    tabs = {
      {
        title = "Folder",
      },
      {
        title = "Neovim",
        args = { "nvim", "." },
        toActivate = true,
      },
    },
  },
}

local function generateWorkspace(inner_window, inner_pane, id)
  local workspace
  for _, w in pairs(workspaces) do
    if w.id == id then
      workspace = w
    end
  end

  if not workspace.cwd then
    workspace.cwd = wezterm.home_dir
  end

  inner_window:perform_action(
    wezterm.action.Multiple({
      wezterm.action.SwitchToWorkspace({
        name = id,
        spawn = {
          cwd = workspace.cwd,
        },
      }),
    }),
    inner_pane
  )

  local muxWindow
  for _, w in pairs(wezterm.mux.all_windows()) do
    if w:get_workspace() == id then
      muxWindow = w
      break
    end
  end
  local guiWindow = muxWindow:gui_window()

  if not workspace.tabs then
    return
  end

  for i, tab in pairs(workspace.tabs) do
    local muxTab
    local pane
    if i ~= 1 then
      muxTab, pane, _ = muxWindow:spawn_tab({
        cwd = tab.cwd,
      })
    else
      muxTab = muxWindow:tabs()[1]
      pane = muxTab:panes()[1]
    end

    if tab.args then
      local command = ""
      for argId, arg in pairs(tab.args) do
        if argId == 1 then
          command = arg
        else
          command = command .. " " .. arg
        end
      end

      guiWindow:perform_action(
        wezterm.action.Multiple({
          wezterm.action.SendString(command),
          wezterm.action.SendKey({
            key = "Enter",
          }),
        }),
        pane
      )
    end

    if tab.title then
      muxTab:set_title(tab.title)
    end

    if tab.toActivate then
      muxTab:activate()
    end
  end
end

local function switchToWorkspace(window, pane, id)
  window:perform_action(
    wezterm.action.SwitchToWorkspace({
      name = id,
    }),
    pane
  )

  wezterm.log_info("Selected ", id)
end

local function selectWorkspace(window, pane)
  local choices = {}
  local currentWindows = wezterm.mux.all_windows()

  for _, workspace in pairs(workspaces) do
    table.insert(choices, {
      id = workspace.id,
      label = workspace.label,
    })
  end

  for _, w in pairs(currentWindows) do
    local workspaceDefined = false
    for _, choice in pairs(choices) do
      if w:get_workspace() == choice.id then
        workspaceDefined = true
      end
    end

    if not workspaceDefined then
      table.insert(choices, {
        id = w:get_workspace(),
        label = w:get_workspace(),
      })
    end
  end

  window:perform_action(
    wezterm.action.InputSelector({
      action = wezterm.action_callback(function(inner_window, inner_pane, id, _)
        if id == nil then
          wezterm.log_info("Cancelled!")
        else
          local workspaceAlreadyOpen = false
          for _, w in pairs(wezterm.mux.all_windows()) do
            if w:get_workspace() == id then
              workspaceAlreadyOpen = true
              break
            end
          end

          if workspaceAlreadyOpen then
            switchToWorkspace(inner_window, inner_pane, id)
          end
          if not workspaceAlreadyOpen then
            generateWorkspace(inner_window, inner_pane, id)
          end
          wezterm.reload_configuration()
        end
      end),
      title = "Workspace selection",
      choices = choices,
      alphabet = "123456789",
      description = "Write the number you want to choose or press / to search.",
      fuzzy_description = "Fuzzy find and/or make a workspace : ",
    }),
    pane
  )
end

return { selectWorkspace = selectWorkspace }
