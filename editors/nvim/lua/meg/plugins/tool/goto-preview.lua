return {
  {
    "rmagatti/goto-preview",
    enabled = true,
    keys = {
      {
        "<Leader>dD",
        "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
        desc = "Preview definition",
      },
      {
        "<Leader>dR",
        "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
        desc = "Preview references",
      },
      {
        "<esc>",
        "<cmd>lua require('goto-preview').close_all_win()<CR>",
        desc = "Close all windows",
      },
    },
    config = function()
      require("goto-preview").setup({})
    end
  }
}
