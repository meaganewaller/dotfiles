return {
  settings = {
    Lua = {
      completion = { callSnippet = 'Replace' },
      diagnostics = {
        enable = true,
        globals = { 'vim' },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
        },
      },
      telemetry = { enable = false },
    },
  },
}
