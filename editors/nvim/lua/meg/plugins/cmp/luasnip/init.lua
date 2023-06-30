local loaded, luasnip = pcall(require, 'luasnip')
if not loaded then
  mw.loading_error_msg("LuaSnip")
  return
end

local function setup(luasnip)
  require("luasnip/loaders/from_vscode").lazy_load()
end

setup(luasnip)
