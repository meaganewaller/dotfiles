-- https://github.com/smjonas/inc-rename.nvim

-- { == Configuration ==> =====================================================
local inc_rename = require("inc_rename")

inc_rename.setup({
  async = true,
  hl_group = "IncSearch",
  input_buffer_type = "dressing",
})
-- <== }
