local neorg = require("neorg")
neorg.setup({
  load = {
    ["core.defaults"] = {},
    ["core.keybinds"] = {},
    ["core.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },
    ["core.concealer"] = {
      config = {
        icons = {
          heading = {
            icons = { "◈", "◆", "◇", "❖", "⟡", "⋄" },
          },
        },
        dim_code_blocks = {
          conceal = false, -- do not conceal @code and @end
        },
      },
    },
    ["core.qol.toc"] = {},
    ["core.qol.todo_items"] = {},
    ["core.dirman"] = {
      config = {
        autodetect = true,
        workspaces = {
          main = "~/notes",
        },
      },
    },
    ["core.journal"] = {},
    ["core.presenter"] = {
      config = {
        zen_mode = "zen-mode",
      },
    },
    ["core.esupports.hop"] = {},
    ["core.esupports.metagen"] = {
      config = {
        type = "empty",
      },
    },
    ["core.manoeuvre"] = {},
    ["core.export"] = {},
    ["core.export.markdown"] = {
      config = {
        extensions = "all",
      },
    },
    ["core.tangle"] = {},
    ["core.tempus"] = {},
    ["core.clipboard"] = {},
    ["core.clipboard.code-blocks"] = {},
    ["core.ui.calendar"] = {},
  },
})
