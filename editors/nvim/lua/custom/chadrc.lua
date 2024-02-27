-- -@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local overrides = require("custom.configs.overrides")

M.plugins = "custom.plugins"

M.ui = overrides.ui

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

M.base46 = {
  integrations = {
    "blankline",
    "cmp",
    "defaults",
    "devicons",
    "git",
    "lsp",
    "mason",
    "nvchad_updater",
    "nvcheatsheet",
    "nvdash",
    "nvimtree",
    "statusline",
    "syntax",
    "tbline",
    "telescope",
    "whichkey",
    "dap",
    "hop",
    "treesitter",
    "rainbowdelimiters",
    "todo",
    "trouble",
    "notify",
  },
}

return M
