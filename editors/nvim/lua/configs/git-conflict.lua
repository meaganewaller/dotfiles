---@diagnostic disable-next-line: missing-fields
require("git-conflict").setup({
  disable_diagnostics = false,
  list_opener = "copen",
  highlights = {
    incoming = "DiffText",
    current = "DiffAdd",
  },
  default_mappings = {
    ours = "c<",
    theirs = "c>",
    none = "co",
    both = "c.",
    next = "]x",
    prev = "[x",
  },
})
