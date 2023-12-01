local custom = require "meg.custom"
local kinds = vim.iter(custom.icons.kind):fold({}, function(t, k, v)
  t[k] = { icon = v }
  return t
end)

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "main",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "s1n7ax/nvim-window-picker",
  },
  opts = {
    position = 'bottom',
    height = 10,
    icons = true,
    mode = 'workspace_diagnostics',
    fold_open = "",
    fold_closed = "",
    group= true,
    padding=true,
    action_keys={
      cancel='<esc>',
      close_folds='zM',
      close='q',
      jump={'<cr>', '<tab>'},
      open_folds='zR',
      open_split={'<c-x>', 'i'},
      open_vsplit={'<c-v>', 's'},
      preview='p',
      refresh='R',
      toggle_mode='m',
      toggle_preview='P',
      previous='k',
      next='j',
    },
    indent_lines=true,
    auto_open=false,
    auto_close=false,
    auto_preview=false,
    use_diagnostic_signs=true,
    document_symbols = {
      kinds = kinds,
    },
    signs = {
      error = custom.icons.diagnostic.error,
      warning = custom.icons.diagnostic.warn,
      information = custom.icons.diagnostic.info,
      hint = custom.icons.diagnostic.hint,
    },
    use_lsp_diagnostic_signs = false,
  },
  init = function()
    local map = require("meg.utils").map

    map("n", "<leader>e", "<cmd>Neotree toggle<CR>", "Toggle File Explorer")
  end,
}
