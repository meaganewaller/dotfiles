-- https://github.com/williamboman/mason.nvim

-- { == Configuration ==> =====================================================

require("mason").setup({ ui = { border = nx.opts.float_win_border } })
require("mason-lspconfig").setup({
  ensure_installed = {
    "pyright",
    "tsserver",
    "html",
    "cssls",
    "eslint",
    "lua_ls",
    "tailwindcss",
    "bashls",
    "rust_analyzer",
  },
})

require("mason-null-ls").setup({
  ensure_installed = {
    "prettier",
    "stylua",
    "eslint_d",
    "html_lint",
    "fixjson",
    "autopep8",
    "shellcheck",
    "jsonlint",
    "markdownlint",
    "quick-lint-js",
    "shellcheck",
    "beautysh",
    "rustfmt",
    "codespell"
  },
})
-- <== }

-- { == Keymaps ==> ===========================================================

nx.map({ "<leader>lM", "<Cmd>Mason<CR>" })
-- <== }
