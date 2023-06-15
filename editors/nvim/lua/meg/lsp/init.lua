local icons = mw.ui.icons
local borders = mw.ui.borders.default

local servers = {
  "bashls",
  "cssls",
  "emmet_ls",
  "eslint",
  "jsonls",
  "pyright",
  "lua_ls",
  "solargraph",
  "sorbet",
  "standardrb",
  "tailwindcss",
  "tsserver",
  "vimls",
  "yamlls",
}

local border = {
  { borders.tl, "FloatBorder" },
  { borders.t, "FloatBorder" },
  { borders.tr, "FloatBorder" },
  { borders.r, "FloatBorder" },
  { borders.br, "FloatBorder" },
  { borders.b, "FloatBorder" },
  { borders.bl, "FloatBorder" },
  { borders.l, "FloatBorder" },
}

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts = {
    border = border,
    width = 80,
  }
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Configure lsp handlers
vim.diagnostic.config({
  virtual_text = {
    source = "if_many", --"always" "if_many"
    spacing = 4,
    prefix = icons.lsp.diagnostics[1],
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Set diagnostic signs
local signs = {
  Error = icons.lsp.error[1],
  Warn = icons.lsp.warn[1],
  Hint = icons.lsp.hint[1],
  Info = icons.lsp.info[1],
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, {
    text = icon,
    texthl = hl,
    numhl = hl,
  })
end

-- Files to look for when searching for project root dir
local root_files = {
  "selene.toml",
  "selene.yml",
  "stylua.toml",
  ".git",
  ".luarc.json",
  ".luacheckrc",
  "Makefile",
  ".nvim",
  ".stylua.toml",
  ".eslintrc.js",
  "node_modules",
  "Gemfile",
}

-- Setup language servers and null-ls
require("meg.lsp.config").setup(icons, border, root_files, servers)
require("meg.lsp.install").setup(servers)

-- Setup lsp utilities
require("meg.lsp.utils.signature").setup(icons, border)
require("meg.lsp.utils.fidget").setup(icons, borders)
require("meg.lsp.utils.inc-rename").setup()
require("meg.lsp.utils.glance").setup(icons, borders)
