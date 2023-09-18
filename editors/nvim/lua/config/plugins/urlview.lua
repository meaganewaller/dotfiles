local M = {
  "axieax/urlview.nvim",
  cmd = "Urlview",
  keys = {
    {
      "<Leader>mu", "<cmd>UrlView buffer action=clipboard<cr>", desc = "Copy URL"
    },
  },
}

return M
