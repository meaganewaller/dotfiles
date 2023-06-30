return {
  {
    "rafi/theme-loader.nvim",
    lazy = false,
    priority = 99,
    opts = { initial_colorscheme = "rose-pine-moon" },
  },

  {
    "rose-pine/neovim",
    lazy = false,
    priority = 100,
    name = "rose-pine",
    opts = {
      dark_variant = 'moon',
    }
  },
  { 'AlexvZyl/nordic.nvim' },
  { 'folke/tokyonight.nvim', opts = { style = 'night' }},
  { 'rebelot/kanagawa.nvim' },
  { 'olimorris/onedarkpro.nvim' },
  { 'EdenEast/nightfox.nvim' },
  { 'catppuccin/nvim', name = 'catppuccin' },
  { 'nyoom-engineering/oxocarbon.nvim' },
}
