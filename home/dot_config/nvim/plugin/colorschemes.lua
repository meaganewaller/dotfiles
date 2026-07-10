-- Installs the colorschemes lua/theme/init.lua's managed_themes list knows
-- how to switch between (see docs/adrs/0005-universal-theme-switcher.md).
-- Loads before plugin/theme.lua (alphabetically) so its `:colorscheme` call
-- always has something on runtimepath to find.
vim.pack.add({
  { src = "https://github.com/danilo-augusto/vim-afterglow" },
  { src = "https://github.com/rockerBOO/boo-colorscheme-nvim" },
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/zootedb0t/citruszest.nvim" },
  { src = "https://github.com/xero/evangelion.nvim" },
  { src = "https://github.com/everviolet/nvim", name = "evergarden" },
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
  { src = "https://github.com/rebelot/kanagawa.nvim" },
  { src = "https://github.com/savq/melange-nvim" },
  { src = "https://github.com/xero/miasma.nvim" },
  { src = "https://github.com/trapd00r/neverland-vim-theme" },
  { src = "https://github.com/EdenEast/nightfox.nvim" },
  { src = "https://github.com/navarasu/onedark.nvim" },
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/vague-theme/vague.nvim" },
  { src = "https://github.com/bettervim/yugen.nvim" },
})
