return {
  "folke/trouble.nvim",
  dependencies = {
    'folke/lsp-colors.nvim',
    'nvim-tree/nvim-web-devicons'
  },
  cond = not vim.g.vscode,
  opts = function()
    return {
      mode = 'document_diagnostics',
      action_keys = {
        cancel = "q",
      }
    }
  end,

  config = function(_, opts)
    local trouble = require("trouble")
    trouble.setup(opts)
    require("which-key").register({
      ["<space>"] = {
        l = {
          name = "List..",
          d = { function() trouble.toggle("document_diagnostics") end, "Diagnostics in file" },
          D = { function() trouble.toggle("workspace_diagnostics") end, "Diagnostics in workspace" },
          r = { function() trouble.toggle("lsp_references") end, "References" },
        }
      }
    })
  end,
  event = "LspAttach",
}
