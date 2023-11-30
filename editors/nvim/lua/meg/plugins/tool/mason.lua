local custom = require "meg.custom"

return {
  "williamboman/mason.nvim",
  build = ":MasonInstallAll",
  config = function()
    local cmd = require ("meg.utils").cmd
    require("mason").setup({
      ui = {
        border = custom.border,
        zindex = 99,
      },
    })

    cmd("MasonInstallAll", function()
      vim.cmd("MasonUpdate")
      local ensure_installed = {
        "bash-language-server",
        "black",
        "clang-format",
        "css-lsp",
        "dockerfile-language-server",
        "eslint-lsp",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "php-cs-fixer",
        "prettierd",
        "python-lsp-server",
        "rust-analyzer",
        "shellcheck",
        "shellharden",
        "shfmt",
        "stylua",
        "tailwindcss-language-server",
        "terraform-lsp",
        "tflint",
        "typescript-language-server",
        "vim-language-server",
        "yaml-language-server",
      }
      vim.cmd('MasonInstall ' .. table.concat(ensure_installed, ' '))
    end, { desc = 'Install all LSP tools' })
  end,
}
