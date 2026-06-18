require("lualine").setup({
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = {
      "location",
      {
        function()
          return vim.fn.reg_recording() ~= "" and "recording @" .. vim.fn.reg_recording() or ""
        end,
        cond = function()
          return vim.fn.reg_recording() ~= ""
        end,
      },
    },
  },
  options = {
    globalstatus = true,
  },
})

vim.opt.laststatus = 3

require("nvim-web-devicons").setup()
