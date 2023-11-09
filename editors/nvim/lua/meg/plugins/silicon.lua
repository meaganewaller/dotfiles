require("silicon").setup({
  font = "FiraCode Nerd Font Mono=26",
  line_number = true,
  output = {
    clipboard = true,
    path = "/Users/meaganwaller/Pictures/Screenshots",
  },
  watermark = {
    text = " @meaganewaller",
  },
  window_title = function() return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ":~:.") end,
})

vim.api.nvim_create_user_command(
  "CaptureSel",
  function(opts)
    require("silicon").capture({
      font = "FiraCode Nerd Font Mono=26",
      line_number = true,
      line1 = opts.line1,
      line2 = opts.line2,
      highlight_selection = true,
      output = {
        clipboard = false,
        path = "/Users/meaganwaller/Pictures/Screenshots",
      },
    })
  end,
  { range = true }
)

nx.map({
  { "<LocalLeader>ss", ":Silicon<CR>", desc = "Screenshot code" },
  { "<LocalLeader>sc", ":CaptureSel<CR>", desc = "Screenshot highlighted lines" },
})
