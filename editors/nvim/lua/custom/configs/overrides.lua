local M = {}

M.treesitter = {
  auto_install = true,
	ensure_installed = {
		"vim",
		"lua",
    "bash",
    "json",
    "json5",
    "jq",
    "yaml",
    "java",
    "dockerfile",
    "regex",
    "toml",
		"html",
		"css",
		"typescript",
		"c",
    "markdown",
    "markdown_inline",
    "go",
    "gomod",
    "gowork",
    "gosum",
    "javascript",
    "tsx",
    "astro",
	},
  indent = {
    enable = true,
  },
  playground = {
    enabled = true,
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
  textsubjects = {
    enable = true,
     keymaps = {
      ["."] = "textsubjects-smart",
      [";"] = "textsubjects-container-outer",
      ["i;"] = "textsubjects-container-inner",
    },
  },
   tree_setter = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = false,
    max_file_lines = 1000,
    query = {
      "rainbow-parens",
      html = "rainbow-tags",
      javascript = "rainbow-tags-react",
      tsx = "rainbow-tags",
    },
  },
  autotag = {
    enable = true,
  },
}

M.mason = {
	ensure_installed = {
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- web dev stuff
		"css-lsp",
		"html-lsp",
		"typescript-language-server",
		"deno",

		-- C / C++
		"clangd",
		"clang-format",
		"cmake-language-server",
		"cpplint",
		"cpptools",

		-- shell
		"shellcheck",
		"shellharden",
		"bash-language-server",
		"bash-debug-adapter",
		"awk-language-server",

		-- python
		"pyright",
		"pylint",

		-- go
		"delve",
		"go-debug-adapter",
		"gofumpt",
		"goimports",
		"goimports-reviser",
		"golangci-lint",
		"golangci-lint-langserver",
		"golines",
		"gomodifytags",
		"gopls",
	},
}

-- git support in nvimtree
M.nvimtree = {
	git = {
		enable = true,
	},

	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
			},
		},
	},
}

M.gitsigns = {
	signs = {
		add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr" },
		change = { hl = "DiffAdd", text = "▎", numhl = "GitSignsChangeNr" },
		delete = { hl = "DiffDelete", text = "-", numhl = "GitSignsDeleteNr" },
		topdelete = { hl = "DiffDelete", text = "- ", numhl = "GitSignsDeleteNr" },
		changedelete = { hl = "DiffChangeDelete", text = "~", numhl = "GitSignsChangeNr" },
	},
}

M.ui = {
	tabufline = {
		lazyload = false,
		overriden_modules = nil,
	},
  theme = "light-pinkish",
  theme_toggle = {
    "light-pinkish",
    "dark-pinkish",
  },
  hl_override = require("custom.highlights").override,
  hl_add = require("custom.highlights").add,
}

M.cmp = {
	formatting = {
		format = function(entry, vim_item)
			local icons = require("nvchad.icons.lspkind")
			vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
			vim_item.menu = ({
				luasnip = "[Luasnip]",
				nvim_lsp = "[Nvim LSP]",
				buffer = "[Buffer]",
				nvim_lua = "[Nvim Lua]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},
}

M.telescope = {
	defaults = {
		vimgrep_arguments = {
			"rg",
			"-L",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
		},
		mappings = {
			i = {
				["<esc>"] = function(...)
					require("telescope.actions").close(...)
				end,
			},
		},
	},
  extensions_list = {
    "themes",
    "terms",
    "notify",
    "undo",
    "ast_grep",
    "ctags_plus",
    "luasnip",
    "import",
    "fzf",
  },
  extensions = {
    fzf = {
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
      fuzzy = true,
    },
    ast_grep = {
      command = {
        "sg",
        "--json=stream",
        "-p",
      },
      grep_open_files = false,
      lang = nil,
    },
    import = {
      insert_at_top = true,
    },
  },
}

return M
