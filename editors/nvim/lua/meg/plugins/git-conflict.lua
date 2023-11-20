-- https://github.com/akinsho/git-conflict.nvim

-- { == Configuration ==> =====================================================

require("git-conflict").setup({
  default_mappings = false,
  disable_diagnostics = true,
  highlights = { -- They must have background color, otherwise the default color will be used
    incoming = "DiffText",
    current = "DiffAdd",
  },
})
-- <== }

vim.api.nvim_create_autocmd("User", {
  pattern = "GitConflictDetected",
  callback = function()
    vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
  end,
})
