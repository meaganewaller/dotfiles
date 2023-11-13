-- https://github.com/jose-elias-alvarez/null-ls.nvim

local null_ls = require("null-ls")
local fmt = null_ls.builtins.formatting
local diag = null_ls.builtins.diagnostics

-- { == Configuration ==> =====================================================
null_ls.setup({
  sources = {
    fmt.prettierd.with({
      filetypes = {
        "markdown",
        "json",
        "jsonc",
        "typescript",
        "typescriptreact",
        "javascript",
        "javascriptreact",
        "vue",
        "yaml",
        "html",
        "css",
        "scss",
        "liquid"
      },
      extra_args = { "--use-tabs", "printWidth: 100" },
    }),
    fmt.stylua,
    fmt.shfmt,
    fmt.beautysh,
    fmt.eslint,
  }
})

-- <== }

nx.map({
  { "<Leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", desc = "Format file using LSP" },
})
