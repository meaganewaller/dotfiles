local conform = require("conform")
local prettier = { "prettierd", "prettier" }

conform.setup({
  quiet = true,
  formatters_by_ft = {
    typescript = { prettier },
    typescriptreact = { prettier },
    javascript = { prettier, "standardjs" },
    javascriptreact = { prettier },
    json = { prettier, "jq" },
    jsonc = { prettier },
    html = { prettier, "htmlbeautifier" },
    css = { prettier },
    scss = { prettier },
    python = { "isort", "black" },
    lua = { "stylua" },
    markdown = { prettier, "markdown-toc", "injected" },
    graphql = { prettier },
    yaml = { prettier, "yamlfix" },
    sh = { "beautysh", "shellcheck" },
    zsh = { "beautysh" },
    vue = { prettier },
    erb = { "erb_format", "htmlbeautifier" },
    fish = { "fish_indent" },
    ruby = { "standardrb" },
    ["_"] = { "trim_whitespace", "trim_newlines" },
  },
  formatters = {
    shfmt = {
      prepend_args = { "-i", "2" },
    },
    prettierd = {
      range_args = false,
    },
  },
  log_level = vim.log.levels.TRACE,
  format_on_save = function(bufnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname:match("/node_modules/") then return end

    return { timeout_ms = 5000, lsp_fallback = true, async = true }
  end,
  format_after_save = { lsp_fallback = true },
})

require("conform.formatters.prettier").args = function(ctx)
  local args = { "--stdin-filepath", "$FILENAME" }
  local localPrettierConfig = vim.fs.find(".prettierrc.json", {
    upward = true,
    path = ctx.dirname,
    type = "file",
  })[1]
  local globalPrettierConfig = vim.fs.find(".prettierrc.json", {
    path = vim.fn.expand("~/.config/nvim"),
    type = "file",
  })[1]

  -- Project config takes precedence over global config
  if localPrettierConfig then
    vim.list_extend(args, { "--config", localPrettierConfig })
  elseif globalPrettierConfig then
    vim.list_extend(args, { "--config", globalPrettierConfig })
  end

  local isUsingTailwind = vim.fs.find("tailwind.config.js", {
    upward = true,
    path = ctx.dirname,
    type = "file",
  })[1]
  local localTailwindcssPlugin = vim.fs.find("node_modules/prettier-plugin-tailwindcss/dist/index.mjs", {
    upward = true,
    path = ctx.dirname,
    type = "file",
  })[1]

  if localTailwindcssPlugin then
    vim.list_extend(args, { "--plugin", localTailwindcssPlugin })
  else
    if isUsingTailwind then
      vim.notify(
        "Tailwind was detected for your project. You can really benefit from automatic class sorting. Please run npm i -D prettier-plugin-tailwindcss",
        vim.log.levels.WARN
      )
    end
  end

  return args
end

conform.formatters.beautysh = {
  prepend_args = function() return { "--indent-size", "2", "--force-function-style", "fnpar" } end,
}

vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
