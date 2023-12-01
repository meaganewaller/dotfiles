return {
  {
    "rmagatti/goto-preview",
    enabled = true,
    config = function()
      require("goto-preview").setup({})

      local map = require("meg.utils").map

      map("n", "<Leader>dD", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", "Preview definition")
      map("n", "<Leader>dR", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", "Preview references")
      map("n", "<esc>", "<cmd>lua require('goto-preview').close_all_win()<CR>", "Close all windows")
    end
  }
}
