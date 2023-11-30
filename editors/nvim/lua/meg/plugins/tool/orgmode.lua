-- local opts = {
--   org_agenda_files = { "~/Documents/org/*" },
--   org_default_notes_file = "~/Documents/org/refile.org",
-- }
--
-- return {
--   "nvim-orgmode/orgmode",
--   enabled = false,
--   event = "VeryLazy",
--   opts = opts,
--   config = function()
--     require("orgmode").setup_ts_grammar()
--   end,
-- }

return {
  "nvim-neorg/neorg",
  enabled = false,
  build = ":Neorg sync-parsers",
  ft = { "norg" },
  cmd = "Neorg",
  opts = {
    load = {
      ["core.keybinds"] = {
        config = {
          default_keybinds = true,
          neorg_leader = ",",
        },
      },
      ["core.defaults"] = {}, -- Loads default behaviour
      ["core.concealer"] = {}, -- Adds pretty icons to your documents
      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
          name = "Neorg",
        },
      },
      ["core.integrations.telescope"] = {}, -- Telescope Integration
      ["core.dirman"] = { -- Manages Neorg workspaces
        config = {
          workspaces = {
            home = "~/garden/",
            work = "~/workspace/notes/",
          },
          index = "index.norg",
        },
      },
    },
  },
  dependencies = { "nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope" },
}
