-- vim-xtabline

local M = {}

local highlight = function(...) vim.api.nvim_set_hl(0, ...) end

M.init_tabline = function()
  vim.o.showtabline = 2
end

M.setup_tabline = function()
  local ok, tl = pcall(require, 'tabline')
  if not ok then
    return
  end
  local tabline = require('tabline.setup')
  local g = tabline.global

  local settings = {
    modes = { 'tabs', 'buffers', 'args' },
    mode_badge = { tabs = 'TABS', buffers = 'BUFS', args = 'ARGS', auto = '' },
    tabs_mode = {
      visibility = { 'tabs', 'buffers', 'args' },
      left = true,
      fraction = true,
    },
    label_style = 'order',
    show_full_path = true,
    mapleader = '',
    theme = false,
    overflow_arrows = true,
    default_mappings = false,
    cd_mappings = true,
    fzf_layout = vim.g.fzf_layout,
  }

  tabline.setup(settings)
  tabline.mappings()

  vim.keymap.set('n', '<Leader>tb', '<Cmd>Tabline mode buffers<CR>')
  vim.keymap.set('n', '<Leader>tt', '<Cmd>Tabline mode tabs<CR>')
  vim.keymap.set('n', '<Leader>ta', '<Cmd>Tabline mode args<CR>')
  vim.keymap.set('n', '<Leader>tf', '<Cmd>Tabline filtering!<CR>')
  vim.keymap.set('n', '<Leader>tp', '<Cmd>Tabline pin!<CR>')
  vim.keymap.set('n', '<Leader>tu', '<Cmd>Tabline reopen<CR>')
  vim.keymap.set('n', '<Leader>tU', '<Cmd>Tabline closedtabs<CR>')
  -- Session mappings
  vim.keymap.set('n', '<Leader>sn', '<Cmd>Tabline session new<CR>')
  vim.keymap.set('n', '<Leader>ss', '<Cmd>Tabline session save<CR>')
  vim.keymap.set('n', '<Leader>sl', '<Cmd>Tabline session load<CR>')
  vim.keymap.set('n', '<Leader>sd', '<Cmd>Tabline session delete<CR>')
  vim.keymap.set('n', '<Leader>sp', function()
    if not g.persist then
      vim.cmd('Tabline persist')
      if g.persist then
        print('Session persistance is enabled')
      end
    else
      vim.cmd('Tabline persist!')
      print('Session persistance is disabled')
    end
  end)
end

M.init_xtabline = function()
  vim.g.xtabline_settings = {
    -- Use 'buffers' as the default xtabline mode, but show 'tabs' if #tabs >= 2
    -- since we use global statusline (laststatus = 3)
    tabline_modes = { 'buffers', 'tabs', 'arglist' },
    -- always show the current xtabline mode
    mode_labels = 'all',
    -- if true, show whether [W]indow or [T]ab local cwd is set
    wd_type_indicator = false,

    --[[ Buffers ]]
    -- 1: buffer numbers, 2: buffer index (position).
    buffer_format = 1,
    -- Do not filter buffers in the list based on directory.
    buffer_filtering = 0,
  }
end

M.setup_xtabline = function()
  local c = require('config.appearance').colors.catppuccin_colors
  if vim.g.current_theme == 'rose-pine' then
    c = require('config.appearance').colors.rose_pine_colors
  end
  require("utils.rc_utils").RegisterHighlights(function()
    -- background filler
    highlight('XTFill',       { bg = c.violet })
    -- selected (the current buffer)
    highlight('XTNumSel',     { bg = c.comment, fg = c.violet, bold = true })
    highlight('XTSelect',     { bg = c.comment, fg = c.fg, bold = true })
    -- buffer: currently shown in other window
    highlight('XTNum',        { bg = c.bg,   fg = c.fg_gutter })
    highlight('XTVisible',    { bg = c.bg, fg = c.pink })
    -- buffer: loaded but hidden (including tabs)
    highlight('XTHidden',     { bg = c.black_br, fg = c.fg })
    highlight('XTHiddenMod',  { bg = c.black_br, fg = c.red })

    highlight('XTCorner',     { link = 'Special' })
    highlight('XTSpecial',    { link = 'XTExtra' })
  end)

  -- Show 'tabs' when #tabs >= 2; otherwise show buffers.
  local change_xtabline_mode = function()
    if vim.fn.tabpagenr('$') >= 2 then
      vim.cmd.XTabMode { args = {'tabs'}, mods = { silent = true }, }
    else
      vim.cmd.XTabMode { args = {'buffers'}, mods = { silent = true }, }
    end
  end
  change_xtabline_mode()
  vim.api.nvim_create_autocmd({'TabNew', 'TabClosed'}, {
    group = vim.api.nvim_create_augroup('xtabline-hybrid', { clear = true }),
    callback = change_xtabline_mode,
  })

  -- Keymaps and commands
  vim.keymap.set('n', '<leader>bH', '<cmd>XTabMoveBufferPrev<CR>')
  vim.keymap.set('n', '<leader>bL', '<cmd>XTabMoveBufferNext<CR>')
  vim.fn.CommandAlias('bmove', 'XTabMoveBuffer')
end

-- Resourcing support
if ... == nil then
  M.setup_tabline()
end

return M
