local function setup()
  vim.keymap.set("n", "<F1>", "<Plug>VimspectorToggleBreakpoint")
  vim.keymap.set("n", "<F3>", "<Plug>VimspectorAddFunctionBreakpoint")
  vim.keymap.set("n", "<F4>", "<Plug>VimspectorRunToCursor")
  vim.keymap.set("n", "<F5>", "<Plug>VimspectorContinue")
  vim.keymap.set("n", "<Right>", "<Plug>VimspectorStepOver")
  vim.keymap.set("n", "<Up>", "<Plug>VimspectorStepOut")
  vim.keymap.set("n", "<Down>", "<Plug>VimspectorStepInto")

  vim.api.nvim_create_user_command("VimspectorPause", "vimspector#Pause()", { force = true })
  vim.api.nvim_create_user_command("VimspectorStop", "vimspector#Stop()", { force = true })
end

local loaded, _ = pcall(require, "vimspector")
if not loaded then
  return
end

setup()
