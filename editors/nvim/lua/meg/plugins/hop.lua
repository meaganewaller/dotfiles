-- https://github.com/phaazon/hop.nvim

local hop = require("hop")

hop.setup()

local hop_single = function(direction)
  local get_direction = function()
    if direction == "backward" then
      return require("hop.hint").HintDirection.BEFORE_CURSOR
    else
      return require("hop.hint").HintDirection.AFTER_CURSOR
    end
  end
  require("hop").hint_patterns({
    direction = get_direction(),
  })
end

-- { == Commands ==> ==========================================================

local direction = require("hop.hint").HintDirection
-- funnily using commands fixes hop with dotrepeat
-- ATM it makes a difference in a command instead of mapping the function directly
-- so these commands are just created to be called with keymaps
nx.cmd({
  {
    "HopChar1t",
    function()
      hop.hint_char1({ direction = direction.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
    end,
  },
  {
    "HopChar1T",
    function()
      hop.hint_char1({ direction = direction.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
    end,
  },
})
-- <== }

-- { == Keymaps ==> ===========================================================

nx.map({
  -- use commands instead of mapping functions directly as it is compatible with dot repeat
  {
    "f",
    function()
      hop_single("forward")
    end,
    { noremap = true },
  },
  { "s", "<Cmd>HopChar2<CR>" },
  { "S", "<Cmd>HopChar1<CR>" },
  { "<leader>s", "<Cmd>HopChar2<CR>", "", wk_label = "ignore" },
  { "<leader>S", "<Cmd>HopChar1<CR>", "", wk_label = "ignore" },
  { "<leader>j", "<Cmd>HopLineStartAC<cr>", "", wk_label = "ignore" },
  { "<leader>k", "<Cmd>HopLineStartBC<cr>", "", wk_label = "ignore" },
  { "f", "<Cmd>HopChar1CurrentLineAC<CR>", "" },
  { "F", "<Cmd>HopChar1CurrentLineBC<CR>", "" },
  { "t", "<Cmd>HopChar1t<CR>", "" },
  { "T", "<Cmd>HopChar1T<CR>", "" },
})
-- <== }

hop.setup()
