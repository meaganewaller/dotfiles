vim.g.multigrid = vim.api.nvim_list_uis()[1].ext_multigrid
-- [ Modules ] -----------------------------------------------------------------

---@class MegModule : LazyPluginSpec
---@diagnostic disable-next-line: duplicate-doc-field
---@field config? fun()|boolean|string @add `string` as possible config type.
---@field eager? boolean
-- Problem childs that need to be loaded outside of `lazy.setup`
require("meg.plugins.visual-multi") -- `VM_maps` config won't work otherwise afaik

local modules = {
  -- Modules
  { dir = "meg/colorschemes", priority = 90, config = "colorschemes", eager = true },
  { dir = "meg/client", priority = 95, config = "client", eager = true },
  -- { dir = "meg/keymaps", priority = 80, config = "keymaps", eager = true },
  { dir = "meg/autocmds", priority = 80, config = "autocmds", eager = true },
  { dir = "meg/settings", priority = 80, config = "settings", eager = true },
  { dir = "meg/abbr", priority = 80, config = "abbr", eager = true },
  { dir = "meg/statusline", priority = 80, config = "statusline", eager = true },
  { dir = "meg/lsp", priority = 80, config = "lsp" },

  -- Must have utilities
  "lewis6991/impatient.nvim",
  {
    "tenxsoydev/nx.nvim",
    priority = 100,
    config = function()
      _G.nx = require("nx")
    end,
    eager = true,
  },
  { "folke/lazy.nvim", tag = "v9.10.0" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-lua/popup.nvim" },
  { "folke/which-key.nvim", config = "plugins.which-key", eager = true },
  { "wakatime/vim-wakatime", eager = true },
  { "anuvyklack/hydra.nvim", eager = true, config = "plugins.hydra" },

  -- Dashboard
  { "goolord/alpha-nvim", eager = true, config = "plugins.alpha" },

  -- UI Improvements
  { "luukvbaal/statuscol.nvim", config = "plugins.statuscol" },
  { "stevearc/dressing.nvim", config = "plugins.dressing" },
  { "folke/noice.nvim", config = not vim.g.multigrid and "plugins.noice" or false },
  { "kevinhwang91/nvim-hlslens", config = "plugins.nvim-hlslens", event = "VeryLazy" },
  { "edluffy/hologram.nvim", event = "VeryLazy" },
  { "AckslD/messages.nvim", event = "VeryLazy", config = vim.g.multigrid and "plugins.messages" or false },
  { "rcarriga/nvim-notify", config = vim.g.multigrid and "plugins.notify" or false },
  { "folke/todo-comments.nvim", config = "plugins.todo-comments", event = "VeryLazy" },
  { "lukas-reineke/indent-blankline.nvim", event = "VeryLazy", config = "plugins.indent-blankline" },
  { "nacro90/numb.nvim", event = "VeryLazy", config = true },
  { "NvChad/nvim-colorizer.lua", event = "VeryLazy", config = "plugins.colorizer" },
  { "nvim-tree/nvim-web-devicons", config = "plugins.devicons", eager = true },
  { "karb94/neoscroll.nvim", config = "plugins.neoscroll" },
  { "echasnovski/mini.nvim", config = "plugins.mini" },
  { "tenxsoydev/size-matters.nvim", lazy = true },
  { "levouh/tint.nvim", event = "VeryLazy", config = "plugins.tint" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = "plugins.treesitter",
  },
  {
    "nvim-treesitter/nvim-treesitter-refactor",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
  },
  {
    "yioneko/nvim-yati",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
  },
  {
    "yioneko/vim-tmindent",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/playground",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "mrjones2014/nvim-ts-rainbow",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
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

  -- Artifical Intelligence
  { "zbirenbaum/copilot.lua", config = "plugins.copilot", eager = true, event = "InsertEnter" },

  -- DB
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIFindBuffer" },
    config = "plugins.dadbod",
  },

  -- LSP / Formatters
  {
    "folke/neodev.nvim",
    config = "plugins.completion.cmp_configs.neodev",
  },
  { "neovim/nvim-lspconfig", config = "lsp.plugins.lspconfig" },
  { "jose-elias-alvarez/null-ls.nvim", config = "lsp.plugins.null-ls", event = "VeryLazy" }, -- inject external formatters and linters
  { "yioneko/nvim-vtsls", event = "VeryLazy" },
  { "RRethy/vim-illuminate", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "williamboman/mason.nvim", config = "lsp.plugins.mason" },
  -- stylua: ignore
  { "williamboman/mason-lspconfig.nvim", dependencies = "williamboman/mason.nvim", config = "lsp.plugins.mason.lspconfig" },
  { "SmiteshP/nvim-navic", event = "VeryLazy" },

  -- Debug
  { "kevinhwang91/nvim-bqf", event = "VeryLazy", config = "plugins.bqf" },
  { "folke/trouble.nvim", event = "VeryLazy", config = "plugins.trouble" },
  { "puremourning/vimspector", event = "VeryLazy", config = "plugins.vimspector" },
  { "mfussenegger/nvim-dap", lazy = true, config = "plugins.dap" },
  { "jbyuki/one-small-step-for-vimkind", lazy = true },
  { "mxsdev/nvim-dap-vscode-js", lazy = true },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    config = "plugins.completion.cmp_configs.cmp",
    event = "InsertEnter",
    dependencies = {
      "chrisgrieser/cmp-nerdfont",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "onsails/lspkind-nvim",
      "saadparwaiz1/cmp_luasnip",
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    config = "plugins.completion.cmp_configs.lspsignature_cmp",
  },
  {
    "tzachar/cmp-tabnine",
    build = "./install.sh",
    config = "plugins.completion.cmp_configs.tabnine",
  },
  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    config = "plugins.completion.cmp_configs.codeium",
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = "zbirenbaum/copilot.lua",
    config = true,
  },
  { "zbirenbaum/neodim", event = { "LspAttach" }, config = true },

  -- Snippets
  { "L3MON4D3/LuaSnip", event = "VeryLazy", config = "plugins.luasnip" }, --snippet engine
  -- "tamago324/nlsp-settings.nvim",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  { "michaelb/sniprun", event = "VeryLazy", build = "bash ./install.sh", config = "plugins.sniprun" },

  -- Buffer & Window Management
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
  { "gennaro-tedesco/nvim-jqx", cmd = { "JqxList", "JqxQuery" } },
  { "folke/zen-mode.nvim", event = "VeryLazy", config = "plugins.zen-mode" },

  -- Code Utilities
  {
    "nvim-neorg/neorg",
    ft = "norg",
    build = ":Neorg sync-parsers",
    config = "plugins.neorg",
    dependencies = { "nvim-web-devicons", "nvim-lua/plenary.nvim" },
  },
  { "numToStr/Comment.nvim", config = "plugins.comment", event = "VeryLazy" },
  { "kylechui/nvim-surround", config = true },
  { "godlygeek/tabular", cmd = { "Tabularize" } },
  { "RRethy/vim-illuminate", config = "plugins.illuminate" },
  { "windwp/nvim-autopairs", event = "InsertEnter", config = "plugins.completion.autopairs" },
  { "nat-418/boole.nvim", event = "VeryLazy", config = "plugins.boole" }, -- extend increment/decrement to cycle through related words
  { "stefandtw/quickfix-reflector.vim", event = "VeryLazy" },
  {
    "kristijanhusak/vim-js-file-import",
    build = "pnpm install",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = "plugins.javascript",
  },
  {
    "axelvc/template-string.nvim",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = "plugins.template_string",
  },
  { "jose-elias-alvarez/typescript.nvim", lazy = true },

  -- Editor Improvements
  {
    "ggandor/flit.nvim",
    config = "plugins.flit",
  },
  {
    "ggandor/leap.nvim",
    config = "plugins.leap",
    dependencies = { "tpope/vim-repeat" },
  },

  --
  { "LunarVim/bigfile.nvim" },
  { "max397574/better-escape.nvim", event = "InsertEnter", config = "plugins.better-escape" }, -- remove delay from escape keys while typing in insert mode.
  { "NMAC427/guess-indent.nvim", event = "VeryLazy", config = true },
  { "windwp/nvim-spectre", event = "VeryLazy", config = "plugins.spectre" },
  { "tenxsoydev/tabs-vs-spaces.nvim", config = true },
  { "monkoose/matchparen.nvim", config = true },
  { "andymass/vim-matchup", event = "VeryLazy", config = "plugins.matchup" }, -- highlight matching patterns and extend `%` navigation
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-surround", event = "VeryLazy" },
  { "tpope/vim-sleuth", event = "VeryLazy" },
  { "tpope/vim-abolish", event = "VeryLazy" },
  { "Wansmer/treesj", event = "VeryLazy", config = "plugins.treesj" },
  "mg979/vim-visual-multi", -- needs to be loaded outside of lazy.nvim for its global variable config values to work

  -- File explorer
  {
    "loichyan/neo-tree.nvim",
    branch = "fix-obsolete-icons",
    dependencies = "MunifTanjim/nui.nvim",
    config = "plugins.neo-tree",
  },

  -- Terminal
  { "akinsho/toggleterm.nvim", event = "VeryLazy", config = "plugins.toggleterm" },
  { "NvChad/nvterm", config = "plugins.nvterm" },
  {
    "willothy/flatten.nvim",
    cond = function()
      return not os.getenv("NVIM") ~= nil
    end,
    lazy = false,
    priority = 1001,
    config = "plugins.flatten",
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    cmd = { "Telescope" },
    config = "plugins.telescope",
    tag = "0.1.2",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  { "nvim-telescope/telescope-frecency.nvim", dependencies = "kkharji/sqlite.lua", lazy = true },
  { "nvim-telescope/telescope-live-grep-args.nvim", lazy = true },
  { "nvim-telescope/telescope-media-files.nvim", lazy = true },
  { "smartpde/telescope-recent-files", lazy = true },
  { "tknightz/telescope-termfinder.nvim", lazy = true },

  { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },
  { "nvim-telescope/telescope-symbols.nvim" },

  -- Testing
  { "nvim-neotest/neotest", config = "plugins.neotest", eager = true },
  { "nvim-neotest/neotest-plenary" },
  { "olimorris/neotest-rspec" },
  { "zidhuss/neotest-minitest" },
  { "nvim-neotest/neotest-vim-test", dependencies = { "vim-test/vim-test" } },
  { "stevearc/overseer.nvim", config = "plugins.overseer" },

  -- Git Integrations
  { "sindrets/diffview.nvim", event = "VeryLazy", config = "plugins.diffview" },
  { "akinsho/git-conflict.nvim", event = "VeryLazy", config = "plugins.git-conflict" },
  { "ruifm/gitlinker.nvim", event = "VeryLazy", config = "plugins.gitlinker" },
  { "lewis6991/gitsigns.nvim", event = "VeryLazy", config = "plugins.gitsigns" },
  { "tobealive/neogit", branch = "fix-noice-commit-confirm-message", event = "VeryLazy", config = "plugins.neogit" },
  { "mattn/vim-gist", event = "VeryLazy", config = "plugins.gist" },
  { "mattn/webapi-vim" },

  -- Colorschemes
  { "rose-pine/neovim", name = "rose-pine" },

  -- Marks & Session
  { "tomasky/bookmarks.nvim", config = "plugins.bookmarks" },
  { "olimorris/persisted.nvim", config = "plugins.persisted" },
  { "rmagatti/auto-session", config = "plugins.auto-session" },
  { "ahmedkhalf/project.nvim", config = "plugins.project" },
  { "chentoast/marks.nvim", event = "VeryLazy", config = "plugins.marks" },
  { "ThePrimeagen/harpoon", event = "VeryLazy", config = "plugins.harpoon" },

  -- Yank & Register Handling
  {
    "tversteeg/registers.nvim",
    event = "VeryLazy",
    config = "plugins.registers",
    commit = "0a461e635403065b3f9a525bd77eff30759cfba0",
  },
  { "tenxsoydev/karen-yank.nvim", event = "VeryLazy", config = true, branch = "remove-cut-esc" },

  -- Markdown
  { "preservim/vim-markdown", config = "plugins.markdown" },
  { "dkarter/bullets.vim", ft = "markdown", config = "plugins.bullets" },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    event = "VeryLazy",
    config = "plugins.markdown-preview",
  },
  { "tenxsoydev/vim-markdown-checkswitch", ft = "markdown" },
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
  ui = {
    border = mw.ui.borders.round,
    custom_keys = {
      ["<Leader>ll"] = function(plugin)
        require("lazy.util").float_term({ "lazygit", "log" }, {
          cwd = plugin.dir,
        })
      end,
    },
  },
  dev = { path = "~/code/neovim-plugins/" },
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})

nx.au({
  "BufEnter",
  pattern = { vim.fn.stdpath("config") .. "*/init.lua" },
  callback = function()
    vim.opt_local.path = { ",,", vim.fn.stdpath("config") .. "/lua/meg/" }
    vim.cmd("setlocal inex=tr(v:fname,'.','/')")
  end,
})

nx.map({ "<leader>P", "<Cmd>Lazy<CR>", desc = "Plugin Manager" })
