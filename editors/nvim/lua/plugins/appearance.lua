-- Appearance plugins

local Plug = require('utils.plug_utils').Plug
local PlugConfig = require('utils.plug_utils').PlugConfig

return {
  Plug 'rose-pine/neovim' { lazy = false, name = "rose-pine", priority = 1000 };
  Plug 'folke/tokyonight.nvim' { lazy = true, opts = { style = "moon" } };
  Plug 'catppuccin/nvim' {
    lazy = true,
    name = 'catppuccin',
  };

  -- statusline
  Plug 'nvim-lualine/lualine.nvim' {
    event = 'UIEnter',  -- load the plugin earlier than VimEnter, before drawing the UI, to avoid flickering transition
    init = function()
      -- lualine initializes lazily; to hide unwanted text changes in the statusline,
      -- draw an empty statusline with no text before the first draw of lualine
      vim.o.statusline = ' '
    end,
    config = require('config.statusline').setup,
  };

  Plug 'mg979/tabline.nvim' {
    event = 'UIEnter',
    lazy = true,
    init = require('config.tabline').init_tabline(),
    config = require('config.tabline').setup_tabline(),
  };
}
