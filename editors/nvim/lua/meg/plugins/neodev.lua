local neodev = require("neodev")

local setup = {
  experimental = {
    pathStrict = true,
  },
}

neodev.setup(setup)
local lsp = require("meg.lsp")
local lua_lang_server = os.getenv("HOME") .. "/.local/share/nvim/language-servers/lua-language-server"
local lua_binary = lua_lang_server .. "/bin/lua-language-server"
lsp.safe_setup("lua_ls", {
  cmd = { lua_binary, "-E", lua_lang_server .. "/main.lua" },
  settings = {
    Lua = {
      IntelliSense = {
        traceLocalSet = true,
      },
      diagnostics = {
        globals = { "vim", "it", "describe", "before_each", "after_each", "a" },
      },
      telemetry = {
        enable = false,
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
})
