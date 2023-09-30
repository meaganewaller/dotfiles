return {
  settings = {
    Lua = {
      format = {
        enable = false,
      },
      hint = {
        enable = true,
        arrayIndex = "Disable",
        await = true,
        paramName = "Disable",
        paramType = false,
        semicolon = "Disable",
        setType = true,
      },
      runtime = {
        version = "5.4",
        special = {
          reload = "require",
        },
      },
      diagnostics = {
        globals = { "vim" },
        disable = {
          "different-requires",
        },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}
