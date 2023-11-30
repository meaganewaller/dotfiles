return {
  "williamboman/mason-lspconfig.nvim",
  config = function()
    require("mason-lspconfig").setup({
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, {
          "delve",
          "gotests",
          "golangci-client",
          "gofumpt",
          "goimports",
          "golangci-lint-langserver",
          "impl",
          "gomodifytags",
          "iferr",
          "gotestsum",
          "intelephense",
          "phpactor",
        })
      end,
    })
  end
}
