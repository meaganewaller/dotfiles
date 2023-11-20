local ts_configs = require("nvim-treesitter.configs")
local ts_context = require("treesitter-context")
local queries = require("nvim-treesitter.query")
local parsers = require("nvim-treesitter.parsers")

local disable_max_size = 2000000

local function should_disable(lang, bufnr)
  local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr or 0))
  if size > disable_max_size or size == -2 then return end

  return false
end

ts_context.setup()

-- { == Configuration ==> =====================================================

local config = {
  -- parser_install_dir = "~/.local/share/nvim/lazy/nvim-treesitter/",
  ensure_installed = {
    "bash",
    "comment",
    "git_rebase",
    "gitcommit",
    "luadoc",
    "markdown",
    "markdown_inline",
    "tsx",
    "typescript",
    "json",
    "yaml",
    "scss",
    "css",
    "html",
    "javascript",
    "vim",
    "vimdoc",
    "jsdoc",
    "graphql",
    "prisma",
    "svelte",
    "sql",
    "regex",
    "lua",
    "ruby",
    "bash",
  }, -- A list of parser names, or "all"
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  -- "comment" results in major performance issues when using block comments
  -- in case TSUninstall is not working: "rm ~/.local/share/nvim/lazy/nvim-treesitter/parser/comment.so",
  ignore_install = { "supercollider", "phpdoc" }, -- List of parsers to ignore installing
  auto_install = true,
  highlight = {
    enable = true,
    disable = { "css", "html", "help", "json" },
    additional_vim_regex_highlighting = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
  autopairs = {
    enable = true,
  },
  indent = { enable = true, disable = { "yaml", "python" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  autotag = {
    enable = true,
    enable_rename = true,
    enable_close = true,
    enable_close_on_slash = false,
    disable = { "xml" },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false,
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
  textobjects = {
    select = {
      enable = true,
      disable = should_disable,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
      },
      include_surrounding_whitespace = false,
    },
  },
  move = {
    enable = true,
    set_jumps = true,
    goto_next_start = {
      ["]f"] = "@function.outer",
      ["]c"] = "@class.outer",
      ["]a"] = "@parameter.inner",
      ["]b"] = "@block.outer",
      ["]l"] = "@loop.outer",
      ["]i"] = "@conditional.outer",
    },
    goto_next_end = {
      ["]F"] = "@function.outer",
      ["]C"] = "@class.outer",
      ["]A"] = "@parameter.inner",
      ["]B"] = "@block.outer",
      ["]L"] = "@loop.outer",
      ["]I"] = "@conditional.outer",
    },
    goto_previous_start = {
      ["[f"] = "@function.outer",
      ["[c"] = "@class.outer",
      ["[a"] = "@parameter.inner",
      ["[b"] = "@block.outer",
      ["[l"] = "@loop.outer",
      ["[i"] = "@conditional.outer",
    },
    goto_previous_end = {
      ["[F"] = "@function.outer",
      ["[C"] = "@class.outer",
      ["[A"] = "@parameter.inner",
      ["[B"] = "@block.outer",
      ["[L"] = "@loop.outer",
      ["[I"] = "@conditional.outer",
    },
  },
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    -- disable = { "c", "ruby" }, -- optional, list of language that will be disabled
    -- [options]
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<Leader>gi",
      scope_incremental = "<Leader>gs",
      node_incremental = "<Leader>gi",
      node_decremental = "<Leader>gd",
    },
  },
}
-- <== }

local function set_ts_win_defaults()
  local parser_name = parsers.get_buf_lang()
  if parsers.has_parser(parser_name) and not should_disable(parser_name, 0) then
    local ok, has_folds = pcall(queries.get_query, parser_name, "folds")
    if ok and has_folds then
      if vim.wo.foldmethod == "manual" then
        vim.api.nvim_win_set_var(0, "ts_prev_foldmethod", vim.wo.foldmethod)
        vim.api.nvim_win_set_var(0, "ts_prev_foldexpr", vim.wo.foldexpr)
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
      end
      return
    end
  end
  if vim.wo.foldexpr == "nvim_treesitter#foldexpr()" then
    local ok, prev_foldmethod = pcall(vim.api.nvim_win_get_var, 0, "ts_prev_foldmethod")
    if ok and prev_foldmethod then
      vim.api.nvim_win_del_var(0, "ts_prev_foldmethod")
      vim.wo.foldmethod = prev_foldmethod
    end
    local ok2, prev_foldexpr = pcall(vim.api.nvim_win_get_var, 0, "ts_prev_foldexpr")
    if ok2 and prev_foldexpr then
      vim.api.nvim_win_del_var(0, "ts_prev_foldexpr")
      vim.wo.foldexpr = prev_foldexpr
    end
  end
end

local aug = vim.api.nvim_create_augroup("MegTSConfig", {})
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  desc = "Set treesitter defaults on win enter",
  pattern = "*",
  callback = set_ts_win_defaults,
  group = aug,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "nvim-treesitter-context highlights",
  pattern = "*",
  command = "highlight link TreesitterContextLineNumber NormalFloat",
  group = aug,
})

local parser_config = parsers.get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

-- { == Keymaps ==> ===========================================================

config.incremental_selection.keymaps = {
  init_selection = "<CR>",
  scope_incremental = "<C-CR>",
  node_incremental = "<CR>",
  node_decremental = "<BS>",
}

nx.map({
  { "<leader>Th", "<Cmd>TSHighlightCapturesUnderCursor<CR>", desc = "Highlight" },
  { "<leader>Tp", "<Cmd>TSPlaygroundToggle<CR>", desc = "Playground" },
	-- stylua: ignore
	{ "<F8>", "<Cmd>TSHighlightCapturesUnderCursor<CR>", desc = "Show TS Highlight Information for Element Under Cursor" },
  { { "<S-F8>", "<F20>" }, "<Cmd>TSPlaygroundToggle<CR>", desc = "Toggle Treesitter Playground" },
})
-- <== }

ts_configs.setup(config)
