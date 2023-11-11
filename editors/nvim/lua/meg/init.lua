local lazy = require("meg.plugins.lazy")

vim.g.multigrid = vim.api.nvim_list_uis()[1].ext_multigrid

require("meg.plugins.visual-multi")

local modules = {
  { dir = "meg/colorschemes", priority = 90, config = "colorschemes", eager = true },
  { dir = "meg/client", priority = 95, config = "client", eager = true },
  { dir = "meg/keymaps", priority = 80, config = "keymaps", eager = true },
  { dir = "meg/autocmds", priority = 80, config = "autocmds", eager = true },
  { dir = "meg/options", priority = 80, config = "options", eager = true },
   { dir = "meg/lsp", priority = 80, config = "lsp" },
  { "wakatime/vim-wakatime", priority = 90, eager = true },
  { "tenxsoydev/nx.nvim", priority = 100, config = function() _G.nx = require("nx") end, eager = true },
  --  { "tenxsoydev/size-matters.nvim", lazy = true },
  { "folke/lazy.nvim", tag = "v9.10.0" },
  { "nvim-tree/nvim-web-devicons", config = "plugins.devicons", eager = true },
  "nvim-lua/plenary.nvim",

  { "goolord/alpha-nvim", config = "plugins.alpha", eager = true },
  --  { "windwp/windline.nvim", config = "plugins.windline", eager = true },
  --  { "gelguy/wilder.nvim", dependencies = "romgrk/fzy-lua-native", event = "CmdlineEnter", config = "plugins.wilder" },
  { "MunifTanjim/nui.nvim" },
  { "folke/noice.nvim", config = not vim.g.multigrid and "plugins.noice" or false },
  { "AckslD/messages.nvim", event = "VeryLazy", config = vim.g.multigrid and "plugins.messages" or false },
  { "rcarriga/nvim-notify", config = "plugins.notify", eager = true },
  --  { "nvim-neo-tree/neo-tree.nvim", dependencies = "MunifTanjim/nui.nvim", config = "plugins.neo-tree" },
  { "akinsho/toggleterm.nvim", event = "VeryLazy", config = "plugins.toggleterm" },
  { "willothy/flatten.nvim", priority = 100, config = "plugins.flatten" },
  { "numToStr/Comment.nvim", event = "VeryLazy", config = "plugins.comment" },
  { "folke/todo-comments.nvim", event = "VeryLazy", config = "plugins.todo-comments" },
  { "LudoPinelli/comment-box.nvim", event = "VeryLazy", config = "plugins.comment-box" },
  --  { "tversteeg/registers.nvim", event = "VeryLazy", config = "plugins.registers" },
  --  { "tenxsoydev/karen-yank.nvim", event = "VeryLazy", config = true },
  --
  --  -- Buffer- & Window Management -----------------------------------------------
  { "romgrk/barbar.nvim", event = "VeryLazy", config = "plugins.barbar" },
  { "Bekaboo/dropbar.nvim", event = "VeryLazy", config = "plugins.dropbar" },
  { "kwkarlwang/bufresize.nvim", event = "VeryLazy", config = true }, -- handle split window sizes on client resize
  --  { "gorbit99/codewindow.nvim", event = "VeryLazy", config = "plugins.codewindow" },
  --  { "petertriho/nvim-scrollbar", event = "VeryLazy", config = "plugins.scrollbar" },
  --  { "s1n7ax/nvim-window-picker", event = "VeryLazy", config = "plugins.window-picker" },
  { "mrjones2014/smart-splits.nvim", event = "VeryLazy", config = "plugins.smart-splits" },
  { "m4xshen/smartcolumn.nvim", opts = {}, eventt = "VeryLazy" },
  --  {
  --    "anuvyklack/windows.nvim",
  --    dependencies = { "anuvyklack/middleclass", "anuvyklack/animation.nvim" },
  --    event = "VeryLazy",
  --    config = "plugins.windows",
  --  },
  --  { "christoomey/vim-tmux-navigator", event = "VeryLazy", config = function() vim.keymap.del("", "<C-Bslash>") end },
  { "folke/zen-mode.nvim", event = "VeryLazy", config = "plugins.zen-mode" },
  { "famiu/bufdelete.nvim", lazy = true },
  --  { "nvimtools/none-ls.nvim", event = "VeryLazy" },
  --  { "sindrets/diffview.nvim", event = "VeryLazy", config = "plugins.diffview" },
  { "akinsho/git-conflict.nvim", event = "VeryLazy", config = "plugins.git-conflict" },
  { "f-person/git-blame.nvim", event = "VeryLazy" },
  { "ruifm/gitlinker.nvim", event = "VeryLazy", config = true },
  { "lewis6991/gitsigns.nvim", event = "VeryLazy", config = "plugins.gitsigns" },
  { "tobealive/neogit", branch = "fix-noice-commit-confirm-message", event = "VeryLazy", config = "plugins.neogit" },
  { "kair8m/git-worktree.nvim", event = "VeryLazy", config = "plugins.git-worktree" },
  { "toppair/peek.nvim", build = "deno task --quiet build:fast", event = "VeryLazy", config = "plugins.peek-nvim" },
  { "mattn/vim-gist", event = "VeryLazy", config = "plugins.gist" },
  { "mattn/webapi-vim" },
  --  { "chrisgrieser/nvim-spider", event = "VeryLazy" },
  --  { "Wansmer/treesj", event = "VeryLazy" },
  { "koenverburg/peepsight.nvim", event = "VeryLazy", config = "plugins.peepsight" },
  { "ray-x/starry.nvim", event = "VeryLazy" },
  {
    "ethanholz/nvim-lastplace",
    opts = {
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
      lastplace_open_folds = true,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = "plugins.treesitter",
  },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "haringsrob/nvim_context_vt", dependencies = { "nvim-treesitter/nvim-treesitter" } },
  { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = { "nvim-treesitter/nvim-treesitter" } },
  { "windwp/nvim-ts-autotag", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "JoosepAlviste/nvim-ts-context-commentstring", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "nvim-treesitter/playground", dependencies = "nvim-treesitter/nvim-treesitter" },
  --  {
  --    "mizlan/iswap.nvim",
  --    event = "VeryLazy",
  --    dependencies = "nvim-treesitter/nvim-treesitter",
  --    config = "plugins.iswap",
  --  },
  { "HiPhish/rainbow-delimiters.nvim", config = "plugins.rainbow-delimiters" },
  --  {
  --    "aarondiel/spread.nvim",
  --    event = "VeryLazy",
  --    dependencies = "nvim-treesitter/nvim-treesitter",
  --    config = "plugins.spread",
  --  },
  {
    "nvim-telescope/telescope.nvim",
    config = "plugins.telescope",
    tag = "0.1.4",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-lua/popup.nvim" },
      { "nvim-telescope/telescope-fzy-native.nvim", dependencies = "romgrk/fzy-lua-native", lazy = true },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        version = "^1.0.0",
      },
    },
  },
  -- { "nvim-telescope/telescope-live-grep-args.nvim", lazy = true },
  -- { "nvim-telescope/telescope-media-files.nvim", lazy = true },
  -- { "gbrlsnchs/telescope-lsp-handlers.nvim", dependencies = { "nvim-telescope/telescope.nvim" }, lazy = true },
  -- --  { "Maan2003/lsp_lines.nvim", lazy = true },
  -- {
  --   "nvim-telescope/telescope-file-browser.nvim",
  --   dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  --   lazy = true,
  -- },
  -- { "kkharji/sqlite.lua", event = "VeryLazy" },
  -- { "smartpde/telescope-recent-files", lazy = true },
  -- { "nvim-telescope/telescope-smart-history.nvim", dependencies = { "kkharji/sqlite.lua" }, lazy = true },
  -- { "tknightz/telescope-termfinder.nvim", lazy = true },
  --  { "folke/neodev.nvim", config = true, lazy = true },
  { "neovim/nvim-lspconfig", config = "lsp.plugins.lspconfig" },
  { "jose-elias-alvarez/null-ls.nvim", config = "lsp.plugins.null-ls" }, -- inject external formatters and linters
  { "glepnir/lspsaga.nvim", event = "VeryLazy", config = "lsp.plugins.lspsaga" },
  --  { "j-hui/fidget.nvim", event = "VeryLazy", config = "lsp.plugins.fidget", tag = "legacy" },
   { "ray-x/lsp_signature.nvim", event = "VeryLazy", config = "lsp.plugins.lsp-signature" },
  --  { "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim", event = "VeryLazy", config = "lsp.plugins.lsp-toggle" },
  "b0o/SchemaStore.nvim",
  { "RRethy/vim-illuminate", dependencies = "nvim-treesitter/nvim-treesitter", config = "plugins.illuminate" },
  { "smjonas/inc-rename.nvim", branch = "main", config = "plugins.inc-rename" },
  --  -- Mason
  { "williamboman/mason.nvim", config = "lsp.plugins.mason" },
  --  -- stylua: ignore
  { "williamboman/mason-lspconfig.nvim", dependencies = "williamboman/mason.nvim" },
  { "jayp0521/mason-null-ls.nvim", dependencies = "williamboman/mason.nvim", config = true },
  { "jay-babu/mason-nvim-dap.nvim" },
  --  -- Language Specific
  -- { "simrat39/rust-tools.nvim", config = "lsp.plugins.rust-tools" },
  { "jose-elias-alvarez/typescript.nvim", lazy = true },
  { "onsails/lspkind.nvim", lazy = true },
  { "WhoIsSethDaniel/mason-tool-installer.nvim", event = "VeryLazy" },
  -- { "linux-cultist/venv-selector.nvim", config = "plugins.venv-selector", event = "VeryLazy" },
  { "kevinhwang91/nvim-bqf", event = "VeryLazy", config = "plugins.bqf" },
  { "folke/trouble.nvim", event = "VeryLazy", config = "plugins.trouble" },
  { "hrsh7th/nvim-cmp", event = "InsertEnter", config = "plugins.cmp" },
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp",
  "chrisgrieser/cmp-nerdfont",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "hrsh7th/cmp-nvim-lsp-document-symbol",
  { "Exafunction/codeium.vim", event = "InsertEnter", config = "plugins.codeium" },
  { "zbirenbaum/copilot.lua", config = "plugins.copilot" },
  { "zbirenbaum/copilot-cmp", dependencies = "zbirenbaum/copilot.lua", config = true },
  { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
  -- Snippets
  { "L3MON4D3/LuaSnip", event = "VeryLazy", config = "plugins.luasnip" }, --snippet engine
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  { "tomasky/bookmarks.nvim", config = "plugins.bookmarks" },
  { "ThePrimeagen/harpoon", event = "VeryLazy", config = "plugins.harpoon" },
  { "olimorris/persisted.nvim", config = "plugins.persisted" },
  --  { "ahmedkhalf/project.nvim", config = "plugins.project" },
  --  { "chentoast/marks.nvim", event = "VeryLazy", config = "plugins.marks" },
  --  { "preservim/vim-markdown", config = "plugins.markdown", ft = "markdown" },
  --  { "dkarter/bullets.vim", ft = "markdown", config = "plugins.bullets" },
  --  {
  --    "iamcco/markdown-preview.nvim",
  --    build = "cd app && npm install",
  --    event = "VeryLazy",
  --    config = "plugins.markdown-preview",
  --    ft = "markdown",
  --  },
  --  { "tenxsoydev/vim-markdown-checkswitch", ft = "markdown" },
  --  -- use nvim for PKM / Zettelkasten
  --  -- { "renerocksai/telekasten.nvim", config = "plugins.telekasten" },
  --  -- { "epwalsh/obsidian.nvim", config = "plugins.obsidian" },
  { "max397574/better-escape.nvim", event = "InsertEnter", config = "plugins.better-escape" }, -- remove delay from escape keys while typing in insert mode
  { "nat-418/boole.nvim", event = "VeryLazy", config = "plugins.boole" }, -- extend increment / decrement to cycle through related words
  { "stevearc/dressing.nvim", event = "VeryLazy", config = "plugins.dressing" },
  { "NMAC427/guess-indent.nvim", event = "VeryLazy", config = true },
  { "smoka7/hop.nvim", event = "VeryLazy", config = "plugins.hop" },
  { "kevinhwang91/nvim-hlslens", event = "VeryLazy", config = "plugins.hlslens" },
  { "edluffy/hologram.nvim", event = "VeryLazy" },
  { "lukas-reineke/indent-blankline.nvim", event = "VeryLazy", config = "plugins.indentline" },
  { "echasnovski/mini.nvim", config = "plugins.mini" },
  { "karb94/neoscroll.nvim", config = "plugins.neoscroll" },
  { "nacro90/numb.nvim", event = "VeryLazy", config = true },
  { "windwp/nvim-autopairs", event = "VeryLazy", config = "plugins.autopairs" },
  { "NvChad/nvim-colorizer.lua", event = "VeryLazy", config = "plugins.colorizer" },
  { "RaafatTurki/hex.nvim", opts = {}, event = "VeryLazy" },
   { "windwp/nvim-spectre", event = "VeryLazy", config = "plugins.spectre" },
   { "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async", config = "plugins.ufo" },
   { "michaelb/sniprun", event = "VeryLazy", build = "bash ./install.sh", config = "plugins.sniprun" },
  { "luukvbaal/statuscol.nvim", config = "plugins.statuscol" },
  { "levouh/tint.nvim", event = "VeryLazy", config = "plugins.tint" },
   { "tenxsoydev/tabs-vs-spaces.nvim", config = true, event = "VeryLazy" },
   { "andymass/vim-matchup", event = "VeryLazy", config = "plugins.matchup" }, -- highlight matching patterns and extend `%` navigation
  { "shellRaining/hlchunk.nvim", event = { "UIEnter" }, lazy = true, config = "plugins.hlchunk" },
  { "tpope/vim-repeat", event = "VeryLazy", lazy = true },
  { "tpope/vim-fugitive", lazy = true },
  { "kylechui/nvim-surround", version = "*", lazy = true, config = "plugins.surround" },
  { "andrewferrier/wrapping.nvim", lazy = true, config = "plugins.wrapping" },
  "mg979/vim-visual-multi", -- needs to be loaded outside of lazy.nvim for its global variable config values to work
  { "folke/which-key.nvim", lazy = true, config = "plugins.which-key" },
   { "smjonas/live-command.nvim", lazy = true, config = "plugins.live-command" },
   { "tamton-aquib/zone.nvim", lazy = true, config = "plugins.zone" },
  { "samodostal/image.nvim", lazy = true, config = true, config = "plugins.image" },
   { "simrat39/inlay-hints.nvim", lazy = true },
  { "mbbill/undotree", lazy = true, config = "plugins.undotree" },
   {
     "nvim-neotest/neotest",
     lazy = true,
     dependencies = {
       "nvim-lua/plenary.nvim",
       "nvim-treesitter/nvim-treesitter",
       "antoinemadec/FixCursorHold.nvim",
     },
     config = "plugins.neotest",
   },

  {"dracula/vim", as = "dracula" },
  --  "folke/tokyonight.nvim",
  --  "olivercederborg/poimandres.nvim",
  --  { "spaceduck-theme/nvim", as = "spaceduck" },
  --  { "daschw/leaf.nvim" },
  --  { "slim-template/vim-slim", event = "FileType", ft = "slim" },
  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    config = "plugins.silicon",
  },
}

-- { == Transform to LazySpec Table ==> =======================================

---Config load helper
---@param plugin_config string
---@param eager? "eager"
local function get(plugin_config, eager)
  if (plugin_config:match("plugins") or plugin_config:match("colorschemes")) and not plugin_config:match("meg") then
    plugin_config = "meg." .. plugin_config
  end

  if eager == "eager" then return function() require(plugin_config) end end

  return function()
    -- scheduled loading the majority of config files - results in 30-35% faster startup
    vim.schedule(function() require(plugin_config) end)
  end
end

for i, module in ipairs(modules) do
  if type(module) == "string" then goto continue end

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
  if module.eager then module.eager = nil end

  ::continue::
  modules[i] = module
end
-- <== }

-- { == Load Setup ==> ========================================================

lazy.setup(modules, {
  ui = { border = "rounded" },
  dev = { path = "~/code/neovim-plugins" },
})
--- <== }

-- { == Events ==> ============================================================

-- Add path for easy `gf` to the config file of a plugin in `get "<plugins.pluginname">` functions above
nx.au({
  "BufEnter",
  pattern = { vim.fn.stdpath("config") .. "*/init.lua" },
  callback = function()
    vim.opt_local.path = { ",,", vim.fn.stdpath("config") .. "/lua/meg/" }
    vim.cmd("setlocal inex=tr(v:fname,'.','/')")
  end,
})
-- <== }

--- { == Keymaps ==> ===========================================================

nx.map({ "<leader>P", "<Cmd>Lazy<CR>", desc = "Plugin Manager" })
--- <== }
