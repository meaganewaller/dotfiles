local settings = {
  Lua = {
    diagnostics = {
      globals = { "vim", "bit", "WindLine" },
    },
    format = {
      enable = false,
    },
    -- use neodev to setup workspace
    -- workspace = {
    -- 	library = {
    -- 		[vim.fn.expand "$VIMRUNTIME/lua"] = true,
    -- 		[vim.fn.stdpath "config" .. "/lua"] = true,
    -- 	},
    -- },
  },
}

return {
  settings = settings,
}
