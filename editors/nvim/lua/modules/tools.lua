return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = { 'Telescope', 'FZF' },
    keys = {
      '<Leader>.',
      '<Leader>F',
      '<Leader>f',
      '<Leader>f*',
      '<Leader>f/',
      '<Leader>f;',
      '<Leader>fD',
      '<Leader>fO',
      '<Leader>fS',
      '<Leader>fb',
      '<Leader>fc',
      '<Leader>fd',
      '<Leader>fe',
      '<Leader>ff',
      '<Leader>fg',
      '<Leader>fh',
      '<Leader>fH',
      '<Leader>fk',
      '<Leader>fm',
      '<Leader>fm',
      '<Leader>fo',
      '<Leader>fp',
      '<Leader>fq',
      '<Leader>fq:',
      '<Leader>fq?',
      '<Leader>fr',
      '<Leader>fs',
      '<Leader>fu',
    },
    dependencies = {
      'plenary.nvim',
      'telescope-fzf-native.nvim',
      'telescope-undo.nvim',
    },
    config = function()
      require('configs.telescope')
    end,
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    lazy = true,
    dependencies = { 'plenary.nvim', 'telescope.nvim' },
  },

  {
    'debugloop/telescope-undo.nvim',
    lazy = true,
    dependencies = { 'plenary.nvim', 'telescope.nvim' },
  },

  {
    'willothy/flatten.nvim',
    event = 'BufReadPre',
    config = function()
      require('configs.flatten')
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    -- stylua: ignore start
    keys = {
      { '<M-i>',        mode = { 'n', 't' } },
      { '<C-\\>v',      mode = { 'n', 't' } },
      { '<C-\\>s',      mode = { 'n', 't' } },
      { '<C-\\>t',      mode = { 'n', 't' } },
      { '<C-\\>f',      mode = { 'n', 't' } },
      { '<C-\\>g',      mode = { 'n', 't' } },
      { '<C-\\><C-v>',  mode = { 'n', 't' } },
      { '<C-\\><C-s>',  mode = { 'n', 't' } },
      { '<C-\\><C-t>',  mode = { 'n', 't' } },
      { '<C-\\><C-f>',  mode = { 'n', 't' } },
      { '<C-\\><C-g>',  mode = { 'n', 't' } },
      { '<C-\\><C-\\>', mode = { 'n', 't' } },
    },
    -- stylua: ignore end
    cmd = {
      'Lazygit',
      'TermExec',
      'ToggleTerm',
      'ToggleTermSetName',
      'ToggleTermToggleAll',
      'ToggleTermSendCurrentLine',
      'ToggleTermSendVisualLines',
      'ToggleTermSendVisualSelection',
    },
    config = function()
      require('configs.toggleterm')
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    dependencies = 'plenary.nvim',
    config = function()
      require('configs.gitsigns')
    end,
  },

  {
    'tpope/vim-fugitive',
    cmd = {
      'G',
      'Gcd',
      'Gclog',
      'Gdiffsplit',
      'Gdrop',
      'Gedit',
      'Ggrep',
      'Git',
      'Glcd',
      'Glgrep',
      'Gllog',
      'Gpedit',
      'Gread',
      'Gsplit',
      'Gtabedit',
      'Gvdiffsplit',
      'Gvsplit',
      'Gwq',
      'Gwrite',
    },
    event = { 'BufWritePost', 'BufReadPre' },
    config = function()
      require('configs.vim-fugitive')
    end,
  },

  {
    'akinsho/git-conflict.nvim',
    event = 'BufReadPre',
    config = function()
      require('configs.git-conflict')
    end,
  },

  {
    'kevinhwang91/rnvimr',
    config = function()
      require('configs.rnvimr')
    end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufNew', 'BufRead' },
    config = function()
      require('configs.nvim-colorizer')
    end,
  },

  {
    'ekickx/clipboard-image.nvim',
    ft = 'markdown',
    init = function()
      vim.keymap.set('n', '<Leader>mp', '<cmd>PasteImg<CR>')
    end,
    config = function()
      require('configs.clipboard-image')
    end,
  },
  {
    "Exafunction/codeium.vim",
    init = function()
      vim.keymap.set("i", "<c-.>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, desc = "Codeium: Go to next completion" })
      vim.keymap.set("i", "<c-,>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, desc = "Codeium: Go to previous completion" })
      vim.keymap.set("i", "<c-x>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, desc = "Codeium: Clear current completion" })
      vim.keymap.set("i", "<c-cr>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, desc = "Codeium: Accept current completion" })
    end,
  },
  {
    'linty-org/key-menu.nvim',
    config = function()
      require('configs.key-menu')
    end,
  },
}
