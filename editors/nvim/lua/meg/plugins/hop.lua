-- https://github.com/phaazon/hop.nvim

local hop = require("hop")

-- { == Keymaps ==> ===========================================================

nx.map({
  -- use commands instead of mapping functions directly as it is compatible with dot repeat
  { "s", ":HopChar1<cr>", "", wk_label = "ignore" },
  { "S", ":HopWord<cr>", "", wk_label = "ignore" },
})
-- <== }

hop.setup({
  keys = "etovxqpdygfblzhckisuran",
  create_hl_autocmd = true,
  jump_on_sole_occurrence = true,
})
