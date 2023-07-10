local function setup(autosession)
  autosession.setup({
    log_level = "error",
    auto_session_suppress_dirs = { "~/" },
    auto_session_use_git_branch = nil,
  })
end

local loaded_autosession, autosession = pcall(require, "auto-session")

if not loaded_autosession then
  mw.loading_error_msg("auto-session")
  return
end

setup(autosession)
