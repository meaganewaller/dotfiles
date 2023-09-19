return {
  -- Wakatime
  { 'wakatime/vim-wakatime',     event = 'VeryLazy' },
  -- Editor Improvements
  { 'NMAC427/guess-indent.nvim', config = true },
  { 'tpope/vim-projectionist' },
  {
    'ggandor/leap.nvim',
    name = 'leap',
    dependencies = { 'tpope/vim-repeat' },
    cond = not vim.g.vscode,
    event = "BufWinEnter",
    config = function()
      require('leap').add_default_mappings()
    end,
  },
  {
    'kylechui/nvim-surround',
    config = true,
    event = 'BufWinEnter',
  },
  {
    'windwp/nvim-autopairs',
    config = true,
    cond = not vim.g.vscode,
    event = 'BufWinEnter',
  },
  {
    'michaeljsmith/vim-indent-object',
    event = 'BufWinEnter',
  },
  {
    "numToStr/Comment.nvim",
    config = true,
    event = "BufWinEnter",
  },
  {
    'echasnovski/mini.align',
    version = false,
    config = true,
    event = 'VeryLazy',
  },
  {
    'tpope/vim-unimpaired',
    config = function()
      vim.keymap.set('n', 'crp', 'crm', { remap = true })
      vim.keymap.set('n', 'cr-', 'crk', { remap = true })
    end
  },
  'tpope/vim-characterize',
  'tpope/vim-speeddating',
  'tpope/vim-rsi',
  'tpope/vim-abolish',

  {
    "ckolkey/ts-node-action",
    dependencies = { "nvim-treesitter" },
    config = function()
      require("ts-node-action").setup({})
      vim.keymap.set({ "n" }, "gs", require("ts-node-action").node_action, { desc = "Trigger Node Action" })
    end,
  },

  -- Buffer/Split/Windows
  {
    'mrjones2014/smart-splits.nvim',
  },
  {
    'kazhala/close-buffers.nvim',
    cond = not vim.g.vscode,
    config = true,
  },
  {
    'sindrets/winshift.nvim',
    cond = not vim.g.vscode,
    config = true,
  },
  { 'tpope/vim-sleuth',  event = 'VeryLazy' },
  { 'LunarVim/bigfile.nvim' },

  -- language support
  {
    'lmeijvogel/vim-yaml-helper',
    cond = not vim.g.vscode,
    ft = 'yaml',
  },

  -- Git
  {
    'sindrets/diffview.nvim',
    cond = not vim.g.vscode,
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh' },
    dependencies = 'nvim-tree/nvim-web-devicons',
  },
  {
    'tanvirtin/vgit.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    cond = not vim.g.vscode,
    opts = {
      hls = {
        GitComment = 'diffComment'
      }
    }
  },
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    cond = not vim.g.vscode,
    config = true,
  },
  { 'tpope/vim-fugitive' },

  -- IDE-like features
  {
    'akinsho/toggleterm.nvim',
    cmd = { 'ToggleTerm', 'ToggleTermSendCurrentLine', 'ToggleTermSendVisualLines', 'ToggleTermSendVisualSelection' },
    cond = not vim.g.vscode,
    opts = {
      size = function(term)
        if term.direction == 'horizontal' then
          return vim.o.lines * 0.3
        elseif term.direction == 'vertical' then
          return math.max(vim.o.columns * 0.4, 25)
        else
          return 20
        end
      end,
    }
  },

  -- colorschemes
  { "catppuccin/nvim" },
  { "projekt0n/github-nvim-theme" },
  { "ellisonleao/gruvbox.nvim" },
  { "hardhackerlabs/theme-vim" },
  { "loctvl842/monokai-pro.nvim" },
  { "edeneast/nightfox.nvim" },
  { "navarasu/onedark.nvim" },
  { "folke/tokyonight.nvim" },
  { "sainnhe/everforest" },
}
