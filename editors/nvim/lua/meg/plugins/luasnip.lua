-- https://github.com/L3MON4D3/LuaSnip

local ls = require("luasnip")
local ft_functions = require("luasnip.extras.filetype_functions")

-- { == Configuration ==> =====================================================

ls.config.setup {
  enable_autosnippets = true,
  history = false,
  updateevents = "TextChanged,TextChangedI",
  region_check_events = { "CursorMoved", "CursorMovedI", "CursorHold" },
  ft_func = ft_functions.from_pos_or_filetype,
  store_selection_keys = "<C-/>",
}


-- { == Snippets ==> ==========================================================

-- <== }

-- { == Keymaps ==> ===========================================================

-- <== }
