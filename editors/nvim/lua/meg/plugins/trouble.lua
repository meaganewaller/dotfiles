-- https://github.com/folke/trouble.nvim#%EF%B8%8F-configuration

local function init()
  -- { == Configuration ==> =====================================================

  require("trouble").setup({
    position = "right", -- position of the list can be: bottom, top, left, right
    auto_open = false,
    use_diagnostics_sign = true,
    icons = true,
    signs = {
      -- icons / text used for a diagnostic
      error = "",
      warning = "",
      hint = "",
      information = "",
      other = "﫠",
    },
  })
  -- <== }

  -- Keymaps ====================================================================

  nx.map({
    { "<leader>dw", "<Cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Workspace Diagnostics" },
    { "<leader>dT", "<Cmd>TroubleToggle<CR>", desc = "Trouble Toggle" },
  })
  -- <== }
end

nx.au({ "BufEnter", once = true, pattern = "*.*", callback = init })
