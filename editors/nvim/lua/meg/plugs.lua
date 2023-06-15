vim.g.multigrid = vim.api.nvim_list_uis()[1].ext_multigrid

-- [ Modules ] -----------------------------------------------------------------

---@class MegModule : LazyPluginSpec
---@diagnostic disable-next-line: duplicate-doc-field
---@field config? fun()|boolean|string @add `string` as possible config type.
---@field eager? boolean

require("meg.plugins.visual-multi")

local modules = {
  { dir = "meg/colorschemes", priority = 90, config = "colorschemes", eager = true },
  { dir = "meg/client", priority = 95, config = "client", eager = true },
  { dir = "meg/keymaps", priority = 80, config = "keymaps", eager = true },
  { dir = "meg/autocmds", priority = 80, config = "autocmds", eager = true },
  { dir = "meg/options", priority = 80, config = "options", eager = true },
  { dir = "meg/lsp", priority = 80, config = "lsp" },
  { "tenxsoydev/nx.nvim", priority = 100, config = function() _G.nx = require("nx") end, eager = true },
  { "folke/lazy.nvim", tag = "v9.10.0" },

  { "RishabhRD/nvim-lsputils", dependencies = { "RishabhRD/popfix" } },
  { "neovim/nvim-lspconfig", config = "lsp.plugins.lspconfig" },
  { "danro/rename.vim", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-endwise", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-repeat", event = { "BufReadPost", "BufNewFile" } },
  { "nvim-lua/plenary.nvim" },
  { "antoinemadec/FixCursorHold.nvim" },
  { "kosayoda/nvim-lightbulb", event = { "BufReadPost", "BufNewFile" } },
  { "ray-x/guihua.lua", build = "cd lua/fzy && make" },
  { "ray-x/navigator.lua" },
  { "zbirenbaum/copilot.lua", config = "plugins.copilot" },
  { "machakann/vim-sandwich", event = { "BufReadPost", "BufNewFile" } },
  { "lukoshkin/trailing-whitespace", event = { "BufReadPost", "BufNewFile" } },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = "lsp.plugins.mason.lspconfig",
  },
  { "williamboman/mason.nvim", config = "lsp.plugins.mason" },

  -- Important utilities
  { "nvim-lua/plenary.nvim" },
  "mg979/vim-visual-multi", -- needs to be loaded outside of lazy.nvim for its global variable config values to work
  { "wakatime/vim-wakatime", eager = "VeryLazy" },

  -- Dashboard
  { "goolord/alpha-nvim", config = "plugins.alpha", eager = true },

  -- UI Improvements
  { "folke/noice.nvim", config = "plugins.noice" },
  { "MunifTanjim/nui.nvim" },
  { "nvim-lua/popup.nvim" },
  { "stevearc/dressing.nvim", event = "VeryLazy", config = "plugins.dressing" },
  { "AckslD/messages.nvim", event = "VeryLazy", config = vim.g.multigrid and "plugins.messages" or false },
  { "vigoux/notifier.nvim", event = "VeryLazy", config = vim.g.multigrid and "plugins.notifier" or false },

  -- File Tree
  -- TODO: Use Oil instead.
  {
  	"loichyan/neo-tree.nvim",
  	branch = "fix-obsolete-icons",
  	dependencies = "MunifTanjim/nui.nvim",
  	config = "plugins.neo-tree",
  },

  -- Terminal
  { "akinsho/toggleterm.nvim", event = "VeryLazy", config = "plugins.toggleterm" },
  { "willothy/flatten.nvim", priority = 100, config = "plugins.flatten" },

  -- Comments
  { "numToStr/Comment.nvim", event = "VeryLazy", config = "plugins.comment" },
  { "folke/todo-comments.nvim", event = "VeryLazy", config = "plugins.todo-comments" },

  -- -- Yank & Register Handling
  -- {
  -- 	"tversteeg/registers.nvim",
  -- 	event = "VeryLazy",
  -- 	config = "plugins.registers",
  -- 	commit = "0a461e635403065b3f9a525bd77eff30759cfba0",
  -- },
  { "gbprod/substitute.nvim", config = "plugins.substitute" },
  { "tenxsoydev/karen-yank.nvim", event = "VeryLazy", config = true, branch = "remove-cut-esc" },
  --
  -- -- Buffer- & Window Management -----------------------------------------------
  { "windwp/windline.nvim", config = "plugins.windline", eager = true },
  { "romgrk/barbar.nvim", event = "VeryLazy", config = "plugins.barbar" },
  { "kwkarlwang/bufresize.nvim", event = "VeryLazy", config = true }, -- handle split window sizes on client resize
  { "gorbit99/codewindow.nvim", event = "VeryLazy", config = "plugins.codewindow" },
  { "petertriho/nvim-scrollbar", event = "VeryLazy", config = "plugins.scrollbar" },
  { "s1n7ax/nvim-window-picker", event = "VeryLazy", config = "plugins.window-picker" },
  { "mrjones2014/smart-splits.nvim", event = "VeryLazy", config = "plugins.smart-splits" },
  {
  	"anuvyklack/windows.nvim",
  	dependencies = { "anuvyklack/middleclass", "anuvyklack/animation.nvim" },
  	event = "VeryLazy",
  	config = "plugins.windows",
  },
  { "folke/zen-mode.nvim", event = "VeryLazy", config = "plugins.zen-mode" },
  { "folke/twilight.nvim", event = "VeryLazy", config = "plugins.twilight" },

  -- Git -----------------------------------------------------------------------
  { "sindrets/diffview.nvim", event = "VeryLazy", config = "plugins.diffview" },
  { "akinsho/git-conflict.nvim", event = "VeryLazy", config = "plugins.git-conflict" },
  { "ruifm/gitlinker.nvim", event = "VeryLazy", config = true },
  { "lewis6991/gitsigns.nvim", event = "VeryLazy", config = "plugins.gitsigns" },
  { "tobealive/neogit", branch = "fix-noice-commit-confirm-message", event = "VeryLazy", config = "plugins.neogit" },
  { "mattn/vim-gist", event = "VeryLazy", config = "plugins.gist" },
  { "mattn/webapi-vim" },
  { "junegunn/gv.vim" },
  -- "ThePrimeagen/git-worktree.nvim",

  -- Treesitter ----------------------------------------------------------------
  {
  	"nvim-treesitter/nvim-treesitter",
  	build = ":TSUPdate",
  	event = { "BufReadPost", "BufNewFile" },
  	config = "plugins.treesitter",
  },
  { "nvim-treesitter/nvim-treesitter-context", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "RRethy/nvim-treesitter-endwise", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "nvim-treesitter/nvim-treesitter-refactor", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "RRethy/nvim-treesitter-textsubjects", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "ziontee113/syntax-tree-surfer", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "nvim-treesitter/tree-sitter-query", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "windwp/nvim-ts-autotag", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "JoosepAlviste/nvim-ts-context-commentstring", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "mrjones2014/nvim-ts-rainbow", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "nvim-treesitter/playground", dependencies = "nvim-treesitter/nvim-treesitter" },
  {
  	"mizlan/iswap.nvim",
  	event = "VeryLazy",
  	dependencies = "nvim-treesitter/nvim-treesitter",
  	config = "plugins.iswap",
  },
  {
  	"aarondiel/spread.nvim",
  	event = "VeryLazy",
  	dependencies = "nvim-treesitter/nvim-treesitter",
  	config = "plugins.spread",
  },

  -- Telescope -----------------------------------------------------------------
  { "nvim-telescope/telescope.nvim", config = "plugins.telescope" },
  { "nvim-telescope/telescope-frecency.nvim", dependencies = "kkharji/sqlite.lua", lazy = true },
  { "nvim-telescope/telescope-fzy-native.nvim", dependencies = "romgrk/fzy-lua-native", lazy = true },
  { "nvim-telescope/telescope-live-grep-args.nvim", lazy = true },
  { "nvim-telescope/telescope-media-files.nvim", lazy = true },
  { "smartpde/telescope-recent-files" },
  { "tknightz/telescope-termfinder.nvim", lazy = true },
  {
  	"princejoogie/dir-telescope.nvim",
  	dependencies = "nvim-telescope/telescope.nvim",
  	config = "plugins.dir-telescope",
  },
  --
  -- -- LSP / Formatters ----------------------------------------------------------
  { "folke/neodev.nvim", config = true },
  { "jose-elias-alvarez/null-ls.nvim", config = "lsp.plugins.null-ls" }, -- inject external formatters and linters
  -- { "glepnir/lspsaga.nvim", event = "VeryLazy", config = "lsp.plugins.lspsaga" },
  -- { "j-hui/fidget.nvim", tag = "legacy", event = "VeryLazy", config = "lsp.plugins.fidget" },
  -- { "ray-x/lsp_signature.nvim", event = "VeryLazy", config = "lsp.plugins.lsp-signature" },
  -- { "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim", event = "VeryLazy", config = "lsp.plugins.lsp-toggle" },
  "b0o/SchemaStore.nvim",
  -- { "RRethy/vim-illuminate", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "davidosomething/format-ts-errors.nvim" },

  -- -- Language Specific
  {
  	"mattn/emmet-vim",
  	config = "plugins.emmet",
  	ft = { "html", "css", "vue", "javascript", "javascriptreact", "svelte", "typescript", "typescriptreact" },
  },
  -- { "jose-elias-alvarez/typescript.nvim", lazy = true },
  -- { "dmmulroy/tsc.nvim", config = function() require("tsc").setup() end },
  -- { "simrat39/rust-tools.nvim", config = "lsp.plugins.rust-tools" },
  --  { "olexsmir/gopher.nvim", ft = "go", config = "plugins.gopher" },
  -- { "jxnblk/vim-mdx-js", ft = "mdx" },
  {
  	"laytan/tailwind-sorter.nvim",
  	dependencies = {
  		"nvim-treesitter/nvim-treesitter",
  		"nvim-lua/plenary.nvim",
  	},
  	build = "cd formatter && npm i && npm run build",
  },
  -- -- "ron-rs/ron.vim",
  -- { "linux-cultist/venv-selector.nvim", config = "plugins.venv-selector", event = "VeryLazy" },
  --
  -- Debug ---------------------------------------------------------------------
  { "mfussenegger/nvim-dap", config = "plugins.dap" },
  "theHamsta/nvim-dap-virtual-text",
  { "rcarriga/nvim-dap-ui", dependencies = "mfussenegger/nvim-dap" },
  { "ecomba/vim-ruby-refactoring", ft = "ruby" },
  { "kevinhwang91/nvim-bqf", event = "VeryLazy", config = "plugins.bqf", ft = { "qf" } },
  { "folke/trouble.nvim", event = "VeryLazy", config = "plugins.trouble" },
  --
  -- Task runner -------------------------------------------------------------------
  { "stevearc/overseer.nvim", config = "plugins.overseer" },
  "vim-test/vim-test",
  {
  	"nvim-neotest/neotest",
  	dependencies = {
  		"nvim-lua/plenary.nvim",
  		"nvim-treesitter/nvim-treesitter",
  		"nvim-neotest/neotest-go",
  		"nvim-neotest/neotest-python",
  		"nvim-neotest/neotest-plenary",
  		"haydenmeade/neotest-jest",
  		"marilari88/neotest-vitest",
  		"olimorris/neotest-rspec",
  		"zidhuss/neotest-minitest",
  		"thenbe/neotest-playwright",
  		"nvim-neotest/neotest-vim-test",
  	},
  	config = "plugins.neotest",
  },

  -- Code Completion -----------------------------------------------------------
  { "hrsh7th/nvim-cmp", event = "InsertEnter", config = "plugins.completion.cmp_configs.cmp" },
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-emoji",
  "chrisgrieser/cmp-nerdfont",
  "hrsh7th/cmp-nvim-lua",
  { "mtoohey31/cmp-fish", ft = "fish" },
  { "tzachar/cmp-tabnine", build = "./install.sh", config = "plugins.tabnine" },
  {
  	"jcdickinson/codeium.nvim",
  	dependencies = { "jcdickinson/http.nvim", build = "cargo build --workspace --release" },
  	config = "plugins.codeium",
  },
  "jcha0713/cmp-tw2css",
  { "zbirenbaum/copilot.lua", config = "plugins.copilot" },
  { "zbirenbaum/copilot-cmp", dependencies = "zbirenbaum/copilot.lua", config = true },
  { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },

  -- Snippets
  { "L3MON4D3/LuaSnip", event = "VeryLazy", config = "plugins.luasnip" }, --snippet engine
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  {
  	"ziontee113/SnippetGenie",
  	event = "VeryLazy",
  	lazy = true,
  	keys = { { "<cr>", mode = "x" }, { ";<cr>", mode = "n" } },
  	config = "plugins.snippetgenie",
  },
  { "danymat/neogen", dependencies = "nvim-treesitter/nvim-treesitter", config = true, version = "*" },

  -- -- Marks & Session -----------------------------------------------------------
  { "tomasky/bookmarks.nvim", config = "plugins.bookmarks" },
  { "ThePrimeagen/harpoon", event = "VeryLazy", config = "plugins.harpoon" },
  { "olimorris/persisted.nvim", config = "plugins.persisted" },
  { "ahmedkhalf/project.nvim", config = "plugins.project" },
  { "chentoast/marks.nvim", event = "VeryLazy", config = "plugins.marks" },
  -- Markdown ------------------------------------------------------------------
  { "preservim/vim-markdown", config = "plugins.markdown" },
  { "dkarter/bullets.vim", ft = "markdown", config = "plugins.bullets" },
  {
  	"iamcco/markdown-preview.nvim",
  	build = "cd app && yarn install",
  	init = function()
  		vim.g.mkdp_filetypes = { "markdown" }
  	end,
  	event = "VeryLazy",
  	config = "plugins.markdown-preview",
  },
  { "tenxsoydev/vim-markdown-checkswitch", ft = "markdown" },

  -- use nvim for PKM / Zettelkasten
  -- { "renerocksai/telekasten.nvim", config = "plugins.telekasten" },
  -- { "epwalsh/obsidian.nvim", config = "plugins.obsidian" },

  -- Utility -------------------------------------------------------------------
  -- TODO: Categorize these utilities better
  { "junegunn/vim-easy-align", config = "plugins.easyalign" },
  { -- View images in neovim
  	"princejoogie/chafa.nvim",
  	dependencies = { "nvim-lua/plenary.nvim", "m00qek/baleia.nvim" },
  	config = function()
  		require("chafa").setup({
  			render = { min_padding = 5, show_label = true },
  			events = { update_on_nvim_resize = true },
  		})
  	end,
  },
  { -- New features and capabilities for wildmenu
  	"gelguy/wilder.nvim",
  	dependencies = "romgrk/fzy-lua-native",
  	event = "CmdlineEnter",
  	config = "plugins.wilder",
  },
  { "max397574/better-escape.nvim", event = "InsertEnter", config = "plugins.better-escape" }, -- remove delay from escape keys while typing in insert mode
  { "nat-418/boole.nvim", event = "VeryLazy", config = "plugins.boole" }, -- extend increment / decrement to cycle through related words
  { "NMAC427/guess-indent.nvim", event = "VeryLazy", config = true },
  { "phaazon/hop.nvim", event = "VeryLazy", config = "plugins.hop", enabled = false },
  { "kevinhwang91/nvim-hlslens", event = "VeryLazy", config = "plugins.hlslens" },
  { "edluffy/hologram.nvim", event = "VeryLazy" },
  { "lukas-reineke/indent-blankline.nvim", event = "VeryLazy", config = "plugins.indentline" },
  { "echasnovski/mini.nvim", config = "plugins.mini" },
  { "karb94/neoscroll.nvim", config = "plugins.neoscroll" },
  { "nacro90/numb.nvim", event = "VeryLazy", config = true },
  { "windwp/nvim-autopairs", event = "VeryLazy", config = "plugins.autopairs" },
  { "NvChad/nvim-colorizer.lua", event = "VeryLazy", config = "plugins.colorizer" },
  { "vuki656/package-info.nvim", event = "VeryLazy", config = "plugins.package-info" },
  { "windwp/nvim-spectre", event = "VeryLazy", config = "plugins.spectre" },
  { "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async", config = "plugins.ufo" },
  { "nvim-tree/nvim-web-devicons", config = "plugins.devicons" },
  { "tenxsoydev/size-matters.nvim", lazy = true },
  { "michaelb/sniprun", event = "VeryLazy", build = "bash ./install.sh", config = "plugins.sniprun" },
  { "luukvbaal/statuscol.nvim", config = "plugins.statuscol" },
  { "levouh/tint.nvim", event = "VeryLazy", config = "plugins.tint" },
  { "tenxsoydev/tabs-vs-spaces.nvim", config = true },
  { "andymass/vim-matchup", event = "VeryLazy", config = "plugins.matchup" }, -- highlight matching patterns and extend `%` navigation
  { "kylechui/nvim-surround", config = "plugins.surround", event = "VeryLazy" },
  { "tpope/vim-abolish", event = "VeryLazy" },
  { "tpope/vim-characterize", event = "VeryLazy" },
  { "tpope/vim-eunuch", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-unimpaired", event = "VeryLazy" },
  { "tpope/vim-vinegar", event = "VeryLazy" },
  { "AndrewRadev/splitjoin.vim", connfig = "plugins.splitjoin" },
  { "cohama/lexima.vim" },

  { "folke/which-key.nvim", lazy = true, config = "plugins.which-key" },

  -- Editor improvements
  { "monaqa/dial.nvim", config = "plugins.dial" },
  { "shortcuts/no-neck-pain.nvim", config = "plugins.no-neck-pain", event = "VeryLazy" },
  { "chrisgrieser/nvim-recorder", config = "plugins.recorder", event = { "BufReadPost", "BufNewFile" } },
  { "johmsalas/text-case.nvim", config = "plugins.textcase" },

  -- Ruby/Rails Development
  { "tpope/vim-rails", ft = "ruby" },
  { "tpope/vim-rake", ft = "ruby" },
  { "tpope/vim-bundler", ft = "ruby" },
  { "tpope/vim-rhubarb", ft = "ruby" },

  -- Colorschemes
  { "decaycs/decay.nvim", name = "decay" },
  { "rose-pine/neovim", name = "rose-pine" },
  "dracula/vim",
  "folke/tokyonight.nvim",
  "vim-scripts/ScrollColors",
  "numToStr/Sakura.nvim",
  "yonlu/omni.vim",
  "flazz/vim-colorschemes",
  "NLKNguyen/papercolor-theme",
  "navarasu/onedark.nvim",
  "marko-cerovac/material.nvim",
  "EdenEast/nightfox.nvim",
  "projekt0n/github-nvim-theme",
  "catppuccin/nvim",
  "wadackel/vim-dogrun",
  "rebelot/kanagawa.nvim",
  "Everblush/everblush.vim",
  "cocopon/iceberg.vim",
  "beardage/orlock.nvim",
}

local function get(plugin_config, eager)
  if (plugin_config:match("plugins") or plugin_config:match("colorschemes")) and not plugin_config:match("meg") then
    plugin_config = "meg." .. plugin_config
  end

  if eager == "eager" then
    return function()
      require(plugin_config)
    end
  end

  return function()
    -- scheduled loading the majority of config files - results in 30-35% faster startup
    vim.schedule(function()
      require(plugin_config)
    end)
  end
end

for i, module in ipairs(modules) do
  if type(module) == "string" then
    goto continue
  end

  -- handle config string values (paths) else keep the module.config value
  if type(module.config) == "string" then
    if module.dir and module.dir:match("meg") and not module.config:match("meg") then
      module.config = "meg." .. module.config
    end
    if module.eager then
      ---@diagnostic disable-next-line: param-type-mismatch
      module.config = get(module.config, "eager")
    else
      ---@diagnostic disable-next-line: param-type-mismatch
      module.config = get(module.config)
    end
  end

  -- remove custom fields
  if module.eager then
    module.eager = nil
  end

  ::continue::
  modules[i] = module
end

require("lazy").setup(modules, {
  ui = { border = "rounded" },
  dev = { path = "~/code/neovim-plugins/" },
})

nx.au({
  "BufEnter",
  pattern = { vim.fn.stdpath("config") .. "*/init.lua" },
  callback = function()
    vim.opt_local.path = { ",,", vim.fn.stdpath("config") .. "/lua/meg/" }
    vim.cmd("setlocal inex=tr(v:fname,'.','/')")
  end,
})

nx.map({ "<Leader>P", "<cmd>Lazy<CR>", desc = "Plugin Manager" })
