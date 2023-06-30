local function setup(copilot_cmp)
  copilot_cmp.setup()
end

local loaded_copilot_cmp, copilot_cmp = pcall(require, "copilot_cmp")
if not loaded_copilot_cmp then
  mw.loading_error_msg("copilot_cmp")
  return
end

setup(copilot_cmp)
