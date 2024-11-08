local platform = require("utils.platform")
local M = {}

---@param cfg table
M.setup = function(cfg)
  if platform.is_win then
    cfg.default_prog = { "wsl", "--cd", "~" }
    cfg.launch_menu = {
      { label = "WSL", args = { "wsl", "--cd", "~" } },
      { label = "PowerShell Core", args = { "pwsh" } },
      { label = "PowerShell Desktop", args = { "powershell.exe", "-NoLogo" } },
      { label = "Command Prompt", args = { "cmd" } },
      { label = "Nushell", args = { "nu" } },
    }
  elseif platform.is_mac then
    cfg.default_prog = { "/opt/homebrew/bin/fish", "-l" }
    cfg.launch_menu = {
      { label = "fish", args = { "/opt/homebrew/bin/fish", "-l" } },
    }
  end
end

return M
