local ok, wk = pcall(require, "which-key")
if not ok then return end

wk.register({
  y = { '"+y', " Yank to clipboard" },
  ["W"] = {
    function() vim.cmd.w() end,
    " Write",
  },
  ["S"] = {
    function() vim.cmd.Format() end,
    " Format",
  },
  q = {
    name = " Quickfix",
    n = { "<cmd>cnext<CR>", "Next Entry" },
    p = { "<cmd>cprevious<CR>", "Previous Entry" },
    o = { "<cmd>copen<CR>", "Open" },
  },
  w = {
    name = " Window",
    ["w"] = { "<C-W>p", "Previous" },
    ["d"] = { "<C-W>c", "Delete" },
    ["-"] = { "<C-W>s", "Split below" },
    ["|"] = { "<C-W>v", "Split right" },
    ["2"] = { "<C-W>v", "Layout Double Columns" },
    ["h"] = { "<C-W>h", "Window left" },
    ["j"] = { "<C-W>j", "Window below" },
    ["l"] = { "<C-W>l", "Window right" },
    ["k"] = { "<C-W>k", "Window up" },
    ["H"] = { "<C-W>5<", "Expand left" },
    ["J"] = { ":resize +5<CR>", "Expand below" },
    ["L"] = { "<C-W>5>", "Expand right" },
    ["K"] = { ":resize -5<CR>", "Expand up" },
    ["="] = { "<C-W>=", "Balance" },
    ["s"] = { "<C-W>s", "Split below" },
    ["v"] = { "<C-W>v", "Split right" },
  },
  i = {
    name = " Insert",
    o = {
      function()
        local lines = {}
        for _ = 1, math.max(vim.v.count, 1) do
          table.insert(lines, "")
        end
        vim.api.nvim_buf_set_lines(
          0,
          vim.api.nvim_win_get_cursor(0)[1],
          vim.api.nvim_win_get_cursor(0)[1],
          false,
          lines
        )
      end,
      "Empty line below",
    },
    O = {
      function()
        local lines = {}
        for _ = 1, math.max(vim.v.count, 1) do
          table.insert(lines, "")
        end
        vim.api.nvim_buf_set_lines(
          0,
          vim.api.nvim_win_get_cursor(0)[1] - 1,
          vim.api.nvim_win_get_cursor(0)[1] - 1,
          false,
          lines
        )
      end,
      "Empty line above",
    },
    i = { "i <ESC>l", "Space before" },
    a = { "a <ESC>h", "Space after" },
    e = { "<cmd>Telescope emoji<cr>", "Emoji" },
    ["<CR>"] = { "i<CR><ESC>", "Linebreak at Cursor" },
  },

  v = {
    name = " View",
    f = {
      function()
        ---@diagnostic disable-next-line: undefined-field
        require("nabla").toggle_virt()
      end,
      "Formulas",
    },
    h = {
      function() vim.cmd.TSHighlightCapturesUnderCursor() end,
      "Highlight Groups",
    },
  },
  p = { '"0p', " Paste Last Yank" },

  Q = { ":let @q='<c-r><c-r>q", " Edit Macro Q" },

  m = {
    name = " Messages",
    v = {
      function() mw.view_messages() end,
      "View",
    },
    s = {
      "<cmd>messages<cr>",
      "Show",
    },
    y = {
      function() vim.cmd.let([[@0 = execute('messages')]]) end,
      "Yank",
    },
    c = {
      function() vim.cmd.let([[@+ = execute('messages')]]) end,
      "Copy to Clipboard",
    },
  },
}, {
  prefix = "<leader>",
  mode = "n",
  silent = true,
})
