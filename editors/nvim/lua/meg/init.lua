vim.g.multigrid = vim.api.nvim_list_uis()[1].ext_multigrid
-- [ Modules ] -----------------------------------------------------------------

---@class MegModule : LazyPluginSpec
---@diagnostic disable-next-line: duplicate-doc-field
---@field config? fun()|boolean|string @add `string` as possible config type.
---@field eager? boolean

local modules = {
  { dir = "meg/colorschemes", priority = 90, config = "colorschemes", eager = true },
  { dir = "meg/keymaps", priority = 80, config = "keymaps", eager = true },
  { dir = "meg/autocmds", priority = 80, config = "autocmds", eager = true },
  { dir = "meg/options", priority = 80, config = "options", eager = true },
  { dir = "meg/lsp", priority = 80, config = "lsp" },

  { "nvim-lua/plenary.nvim" },

  { "folke/lazy.nvim", tag = "v9.10.0" },
  { "tenxsoydev/nx.nvim", priority = 100, config = function() _G.nx = require("nx") end, eager = true },
  { "folke/which-key.nvim", config = "plugins.which-key", eager = true },
  { "wakatime/vim-wakatime", eager = true },
  { "anuvyklack/hydra.nvim", eager = true, config = "plugins.hydra" },

  { "luukvbaal/statuscol.nvim", config = "plugins.statuscol" },

  { "goolord/alpha-nvim", eager = true, config = "plugins.alpha" },

  -- UI Improvements
  { "stevearc/dressing.nvim", config = "plugins.dressing" },
  { "kevinhwang91/nvim-hlslens", config = "plugins.nvim-hlslens" },
  { "rcarriga/nvim-notify", config = "plugins.notify" },
  { "folke/todo-comments.nvim", config = "plugins.todo-comments" },
  { "lukas-reineke/indent-blankline.nvim", config = "plugins.indent-blankline" },
  { "anuvyklack/pretty-fold.nvim", config = "plugins.pretty-fold" },
  { "lewis6991/satellite.nvim", config = "plugins.satellite" },
  { "echasnovski/mini.nvim", config = "plugins.mini.animate" },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = "plugins.treesitter" },
  { "mrjones2014/nvim-ts-rainbow" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "JoosepAlviste/nvim-ts-context-commentstring" },

  -- Artifical Intelligence
  { "zbirenbaum/copilot.lua", config = "plugins.copilot", eager = true },

  -- LSP
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "WhoIsSethDaniel/mason-tool-installer.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "ray-x/lsp_signature.nvim" },
  { "jose-elias-alvarez/null-ls.nvim" },
  { "smjonas/inc-rename.nvim" },
  { "j-hui/fidget.nvim", tag = "legacy" },
  { "SmiteshP/nvim-navic" },
  { "DNLHC/glance.nvim" },

  -- Completion
  { "hrsh7th/nvim-cmp", config = "plugins.cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },
  { "hrsh7th/cmp-buffer" },
  { "f3fora/cmp-spell" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip", config = "plugins.cmp.luasnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "zbirenbaum/copilot-cmp", config = "plugins.cmp.copilot" },

  -- Buffer & Window Management
  { "windwp/windline.nvim", config = "plugins.windline", eager = true },
  { "romgrk/barbar.nvim", event = "VeryLazy", config = "plugins.barbar" },
  { "famiu/bufdelete.nvim", cmd = { "Bdelete" } },

  -- Code Utilities
  { "stevearc/aerial.nvim", config = "plugins.aerial" },
  { "numToStr/Comment.nvim", config = "plugins.comment" },
  { "kylechui/nvim-surround", config = "plugins.nvim-surround" },
  { "godlygeek/tabular", cmd = { "Tabularize" } },
  { "folke/trouble.nvim", config = "plugins.trouble" },
  { "RRethy/vim-illuminate", config = "plugins.illuminate" },

  -- File explorer
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = 'plugins.oil'
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      's1n7ax/nvim-window-picker',
    },
    config = 'plugins.neotree'
  },

  -- Telescope
  { 'nvim-telescope/telescope.nvim', config = 'plugins.telescope' },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  'nvim-telescope/telescope-frecency.nvim',
  'tami5/sqlite.lua',
  'nvim-telescope/telescope-file-browser.nvim',
  'benfowler/telescope-luasnip.nvim',
  'princejoogie/dir-telescope.nvim',
  { "ibhagwan/fzf-lua", enabled = vim.fn.executable("fzf") == 1, config = "plugins.fzf-lua" },

  -- Testing
  { 'nvim-neotest/neotest', config = 'plugins.neotest' },
  { 'nvim-neotest/neotest-plenary' },
  { 'olimorris/neotest-rspec' },
  { 'stevearc/overseer.nvim', config = 'plugins.overseer' },

  -- Git Integrations
  { "lewis6991/gitsigns.nvim", config = "plugins.gitsigns" },

  -- Colorschemes
  { "rose-pine/neovim", name = "rose-pine" },
}

local function get(plugin_config, eager)
  if (plugin_config:match("plugins") or
    plugin_config:match("colorschemes")) and not plugin_config:match("meg") then
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
  ui = { border = mw.ui.borders.round },
  dev = { path = "~/code/neovim-plugins/" },
})
