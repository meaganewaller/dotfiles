-- https://github.com/nvim-treesitter/nvim-treesitter

local loaded, nvim_treesitter = pcall(require, "nvim-treesitter.configs")
if not loaded then
  mw.loading_error_msg("nvim-treesitter")
  return
end

local function setup(nvim_treesitter)
  nvim_treesitter.setup({
    ensure_installed = "all",
    ignore_install = { "comment" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        scope_incremental = "<S-CR>",
        node_decremental = "<BS>",
      },
    },
    rainbow = {
      enable = true,
      extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      max_file_lines = nil, -- Do not enable for files with more than n lines, int
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]a"] = "@parameter.inner",
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[a"] = "@parameter.inner",
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
    },
  })
end

setup(nvim_treesitter)
-- local ts_configs = require("nvim-treesitter.configs")
--
-- -- { == Configuration ==> =====================================================
--
-- local config = {
-- 	enable = true,
-- 	-- parser_install_dir = "~/.local/share/nvim/lazy/nvim-treesitter/",
-- 	ensure_installed = {
-- 		"css",
-- 		"dockerfile",
-- 		"gitignore",
-- 		"go",
-- 		"graphql",
-- 		"html",
-- 		"javascript",
-- 		"json",
-- 		"json5",
-- 		"lua",
-- 		"markdown",
-- 		"query",
-- 		"regex",
-- 		"ruby",
-- 		"scss",
-- 		"tsx",
-- 		"typescript",
-- 		"yaml",
-- 	},
-- 	sync_install = true, -- install languages synchronously (only applied to `ensure_installed`)
-- 	-- "comment" results in major performance issues when using block comments
-- 	-- in case TSUninstall is not working: "rm ~/.local/share/nvim/lazy/nvim-treesitter/parser/comment.so",
-- 	ignore_install = { "comment" }, -- List of parsers to ignore installing
-- 	highlight = {
-- 		-- use_languagetree = true,
-- 		enable = true, -- false will disable the whole extension
-- 		disable = { "css", "html", "help" }, -- list of language that will be disabled
-- 		additional_vim_regex_highlighting = false,
-- 	},
-- 	autopairs = {
-- 		enable = true,
-- 	},
-- 	endwise = { enable = true },
-- 	textsubjects = {
-- 		enable = true,
-- 	},
-- 	textobjects = {
-- 		select = {
-- 			enable = true,
-- 			lookahead = true,
-- 			keymaps = {
-- 				["af"] = "@function.outer",
-- 				["if"] = "@function.inner",
-- 				["ac"] = "@class.outer",
-- 				["ic"] = "@class.inner",
-- 			},
-- 		},
-- 	},
-- 	indent = { enable = true, disable = { "yaml", "python", "css" } },
-- 	context_commentstring = {
-- 		enable = true,
-- 		enable_autocmd = false,
-- 	},
-- 	autotag = {
-- 		enable = true,
-- 		disable = { "xml" },
-- 	},
-- 	rainbow = {
-- 		enable = true,
-- 		colors = {
-- 			"Gold",
-- 			"Orchid",
-- 			"DodgerBlue",
-- 			-- "Cornsilk",
-- 			-- "Salmon",
-- 			-- "LawnGreen",
-- 		},
-- 		disable = { "html" },
-- 	},
-- 	move = {
-- 		enable = true,
-- 		set_jumps = true,
-- 	},
-- 	playground = {
-- 		enable = true,
-- 	},
-- 	matchup = {
-- 		enable = true, -- mandatory, false will disable the whole extension
-- 		-- disable = { "c", "ruby" }, -- optional, list of language that will be disabled
-- 		-- [options]
-- 	},
-- 	incremental_selection = {
-- 		enable = true,
-- 		keymaps = {},
-- 	},
-- }
-- -- <== }
--
-- -- { == Keymaps ==> ===========================================================
--
-- config.incremental_selection.keymaps = {
-- 	init_selection = "<CR>",
-- 	scope_incremental = "<C-CR>",
-- 	node_incremental = "<CR>",
-- 	node_decremental = "<BS>",
-- }
--
-- nx.map({
-- 	{ "<leader>Th", "<Cmd>TSHighlightCapturesUnderCursor<CR>", desc = "Highlight" },
-- 	{ "<leader>Tp", "<Cmd>TSPlaygroundToggle<CR>", desc = "Playground" },
--   -- stylua: ignore
--   { "<F8>", "<Cmd>TSHighlightCapturesUnderCursor<CR>", desc = "Show TS Highlight Information for Element Under Cursor" },
-- 	{ { "<S-F8>", "<F20>" }, "<Cmd>TSPlaygroundToggle<CR>", desc = "Toggle Treesitter Playground" },
-- })
-- -- <== }
--
-- ts_configs.setup(config)
--
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
--
-- require("treesitter-context").setup({
-- 	enable = true,
-- 	max_lines = 0,
-- 	trim_scope = "outer",
-- 	min_window_height = 0,
-- 	patterns = {
-- 		default = {
-- 			"class",
-- 			"function",
-- 			"method",
-- 			"for",
-- 			"while",
-- 			"if",
-- 			"switch",
-- 			"case",
-- 			"def",
-- 		},
-- 	},
-- 	zindex = 20,
-- 	mode = "cursor",
-- 	separator = nil,
-- })
