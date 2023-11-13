-- https://github.com/LudoPinelli/comment-box.nvim

local cb = require("comment-box")

-- { == Configuration ==> =====================================================
cb.setup({
  doc_width = 80,
  box_width = 60,
  borders = {
    top = "─",
    bottom = "─",
    left = "│",
    right = "│",
    top_left = "┌",
    top_right = "┐",
    bottom_left = "└",
    bottom_right = "┘",
  },
  line_width = 70,
  line = { -- symbols used to draw a line
    line = "─",
    line_start = "─",
    line_end = "─",
  },
  outer_blank_lines = false, -- insert a blank line above and below the box
  inner_blank_lines = false, -- insert a blank line above and below the text
  line_blank_line_above = false, -- insert a blank line above the line
  line_blank_line_below = false, -- insert a blank line below the line
})

-- <== }

-- { == Keymaps ==> ===========================================================
nx.map({
  { "<Leader>cb", cb.lbox, desc = "Left aligned box with left aligned text", { "n", "v" } },
  { "<Leader>cc", cb.ccbox, desc = "Centered box with centered text", { "n", "v" } },
  { "<Leader>cl", cb.cline, desc = "Centered line" },
  { "<M-l>", cb.cline, desc = "Centered line", { "i" } },
})
-- <== }
