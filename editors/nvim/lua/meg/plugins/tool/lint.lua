return {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      markdown = { "markdownlint" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      sh = { "shellcheck" },
      lua = { "luacheck" },
      python = { "pylint" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "BufLeave" }, {
      group = vim.api.nvim_create_augroup("lint", { clear = true }),
      callback = function()
        require('lint').try_lint()
      end,
    })
  end,
}
