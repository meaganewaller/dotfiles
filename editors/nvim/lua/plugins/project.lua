local status_ok, project = pcall(require, "project_nvim")
if not status_ok then return end

project.setup({
  patterns = {
    ".git",
    "_darcs",
    ".hg",
    ".bzr",
    ".svn",
    "Makefile",
    "package.json",
    ".solution",
  },
  exclude_dirs = { "~/" },
  silent_chdir = true,
  manual_mode = false,
  exclude_filetype_chdir = {"", "OverseerList", "alpha"},
  -- Don't auto-chdir for specific buftypes.
  exclude_buftype_chdir = {"nofile", "terminal"},

  ignore_lsp = { "lua_ls" },
})
