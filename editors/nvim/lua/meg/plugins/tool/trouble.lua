return {
  "folke/trouble.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  },
  cmd = { "TroubleToggle", "Trouble", "TroubleRefresh" },
  config = function()
    local icons = require("meg.custom").icons

    require("trouble").setup({
      position = "bottom",
      height = 10,
      width = 50,
      icons = true,
      mode = "workspace_diagnostics",
      fold_open = " ",
      fold_closed = " ",
      group = true,
      padding = true,
      action_keys = {
        close = "q",
        cancel = "<esc>",
        refresh = "r",
        jump = { "<cr>", "<tab>" },
        open_split = { "<c-x>" },
        open_vsplit = { "<c-v>" },
        open_tab = { "<c-t>" }, -- open buffer in new tab
        jump_close = { "o" }, -- jump to the diagnostic and close the list
        toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = "P", -- toggle auto_preview
        hover = "K", -- opens a small popup with the full multiline message
        preview = "p", -- preview the diagnostic location
        close_folds = { "zM", "zm" }, -- close all folds
        open_folds = { "zR", "zr" }, -- open all folds
        toggle_fold = { "zA", "za" }, -- toggle fold of current file
        previous = "k", -- preview item
        next = "j", -- next item
      },
      indent_lines = true, -- add an indent guide below the fold icons
      auto_open = false, -- automatically open the list when you have diagnostics
      auto_close = false, -- automatically close the list when you have no diagnostics
      auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
      auto_fold = false, -- automatically fold a file trouble list at creation
      auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
      signs = {
        -- icons / text used for a diagnostic
        error = icons.diagnostic.error,
        warning = icons.diagnostic.warn,
        hint = icons.diagnostic.hint,
        information = icons.diagnostic.info,
        other = "",
      },
      use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
    })

    local map = require("meg.utils").map

    map("n", "<Leader>x", "<cmd>TroubleToggle<CR>", "Toggle Trouble")
  end,
}
