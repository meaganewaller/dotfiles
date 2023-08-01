-- https://github.com/max397574/better-escape.nvim

local function init()
  -- { == Configuration ==> ====================================================

  require("better_escape").setup({
    mapping = { "jk" },
    timeout = 300,
    clear_empty_lines = true,
    keys = "<Esc>",
  })
  -- <== }
end

-- { == Events ==> ============================================================

nx.au({ "InsertEnter", once = true, callback = init })
-- <== }
