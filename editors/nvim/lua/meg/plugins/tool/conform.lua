return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black", "ruff" },
      javascript = { { "prettierd", "prettier" } },
      typescript = { { "prettierd", "prettier" } },
      typescriptreact = { { "prettierd", "prettier" } },
      javascriptreact = { { "prettierd", "prettier" } },
      go = { "gofmt", "goimports" },
      elixir = { "mix" },
    },
  },
  init = function()
    local map = require("meg.utils").map

    map("n", "<Leader>ff", function()
      require("conform").format { lsp_fallback = true }
    end, "Format Document")
  end,
}
