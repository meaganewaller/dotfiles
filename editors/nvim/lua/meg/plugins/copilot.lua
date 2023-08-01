local function setup(copilot)
  copilot.setup({
    suggestion = { auto_trigger = false },
    panel = {
      enabled = true,
      layout = {
        position = "bottom",
        size = 0.4
      }
    },
  })
end

local loaded_copilot, copilot = pcall(require, "copilot")
if not loaded_copilot then
  mw.loading_error_msg("copilot")
  return
end

setup(copilot)
