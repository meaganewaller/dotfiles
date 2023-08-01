-- https://github.com/numToStr/Comment.nvim

require("Comment").setup({
  padding = true,
  sticky = true,
  ignore = nil,
  toggler = {
    line = "gcc",
    block = "gbc",
  },
  opleader = {
    ---Line-comment keymap
    line = "gc",
    ---Block-comment keymap
    block = "gb",
  },
  ---LHS of extra mappings
  ---@type table
  extra = {
    ---Add comment on the line above
    above = "gcO",
    ---Add comment on the line below
    below = "gco",
    ---Add comment at the end of line
    eol = "gcA",
  },
  ---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
  ---@type table
  mappings = {
    basic = true,
    extra = true,
  },
  ---Pre-hook, called before commenting the line
  ---@type function
--  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),

  ---Post-hook, called after commenting is done
  ---@type function
  post_hook = nil,
})
-- <== }

-- { == Keymaps ==> ===========================================================

require("meg.keymaps").comment()
