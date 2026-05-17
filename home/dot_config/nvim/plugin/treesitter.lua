-- Treesitter via the native package manager. nvim-treesitter's `main`
-- branch is the modern Lua-only API for nvim 0.10+; setup() configures
-- highlight/indent and TSInstall fetches parsers on demand.

vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

local ok, ts = pcall(require, "nvim-treesitter.configs")
if not ok then return end

ts.setup({
  ensure_installed = {
    "bash",
    "c",
    "diff",
    "fish",
    "git_config",
    "gitcommit",
    "gitignore",
    "go",
    "html",
    "json",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "ruby",
    "rust",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
})

-- Use treesitter for folds when a parser is attached, but keep folds
-- open by default so opening a file doesn't feel claustrophobic.
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
