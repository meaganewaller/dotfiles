local function setup(copilot)
  copilot.setup({
    filetypes = {
      TelescopePrompt = false,
      TelescopeResults = false,
    },
    ft_disable = { "go", "dap-repl" },
    suggestion = { auto_trigger = true },
    panel = { enabled = false },
  })
end

local loaded_copilot, copilot = pcall(require, "copilot")
if not loaded_copilot then
  mw.loading_error_msg("copilot")
  return
end

setup(copilot)
