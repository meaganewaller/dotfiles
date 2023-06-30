local function setup(copilot)
  copilot.setup({
    ft_disable = { "go", "dap-repl" },
    suggestion = { enabled = false },
    panel = { enabled = false },
  })
end

local loaded_copilot, copilot = pcall(require, "copilot")
if not loaded_copilot then
  mw.loading_error_msg("copilot")
  return
end

setup(copilot)
