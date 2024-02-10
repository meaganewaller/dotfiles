-- Config for nvim-ufo

local M = {}

M.setup_ufo = function()
  local ufo = require('ufo')

  -- This is required by nvim-ufo (see kevinhwang91/nvim-ufo#30, kevinhwang91/nvim-ufo#57)
  -- otherwise folds will be unwantedly open/closed when nvim-ufo is in action
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.g.has_folding_ufo = 1

  -- See $VIMPLUG/nvim-ufo/lua/ufo/config.lua
  -- See https://github.com/kevinhwang91/nvim-ufo/blob/master/README.md#setup-and-description
  ufo.setup {
    open_fold_hl_timeout = 150,
    provider_selector = function(bufnr, filetype)
      -- Use treesitter if available
      if pcall(require, 'nvim-treesitter.parsers') then
        if require("config.treesitter").has_parser(filetype) then
          return {'treesitter', 'indent'}
        end
      end

      -- Otherwise, might need to disable 'fold providers'
      -- so that we can fallback to the default vim's folding behavior (per foldmethod).
      -- This can be also helpful for a bug where all open/closed folds are lost and reset
      -- whenever fold is updated when, for instance, saving the buffer (when foldlevel != 99).
      -- For more details, see kevinhwang91/nvim-ufo#30
      return ''
    end,

    -- see #26, #38, #74 (enables ctx.end_virt_text)
    enable_get_fold_virt_text = true,

    ---@type UfoFoldVirtTextHandler
    fold_virt_text_handler = function(...)
      return require("config.folding").virtual_text_handler(...)
    end,
  }
end

M.before_ufo = function()
  -- Need to disable zM, zR during init, because it will change foldlevel
  -- if zM/zR executed before the keymap settings of nvim-ufo has been effective.
  local ufo_not_ready = vim.schedule_wrap(function()
    vim.notify("nvim-ufo is yet to be initialized, please try again later...",
      vim.log.levels.WARN, { timeout = 500, title = "nvim-ufo" })
  end)
  vim.keymap.set('n', 'zM', ufo_not_ready, { silent = true })
  vim.keymap.set('n', 'zR', ufo_not_ready, { silent = true })
end


--- (highlighted) preview of folded region.
-- Preview, # of folded lines, etc.
-- Part of code brought from kevinhwang91/nvim-ufo#38, credit goes to @ranjithshegde
---@return UfoExtmarkVirtTextChunk[]  return a list of virtual text chunks: { text, highlight }[].
---@type UfoFoldVirtTextHandler
M.virtual_text_handler = function(virtText, lnum, endLnum, width, truncate, ctx)
  local newVirtText = {}
  local suffix = (" ⋯ %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0

  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end



-- Keymaps for nvim-ufo
-- Most of fold-related keys such as zR, zM, etc. need to be remapped
-- because nvim-ufo overrides most of fold operations and foldlevel.

M.attach_ufo_if_necessary = function()
  local bufnr = vim.api.nvim_get_current_buf()
  if not require("ufo").hasAttached(bufnr) then
    require("ufo").attach()
    return true
  end
  return false
end

M.enable_ufo_fold = function()
  vim.wo.foldenable = true
  vim.wo.foldlevel = 99   -- sometimes get lost. Ensure to be 99 at all times (see kevinhwang91/nvim-ufo#89)
  M.attach_ufo_if_necessary()  -- some buffers may not have been attached
  require("ufo").enableFold()   -- setlocal foldenable
end


-- Open/Close fold
-- Note: z<space> ==> see vimrc
M.open_all_folds = function()  -- zR
  M.enable_ufo_fold()
  require("ufo").openAllFolds()
end
M.close_all_folds = function()  -- zM
  M.enable_ufo_fold()
  require("ufo").closeAllFolds()
end
M.reduce_folding = function()  -- zr
  M.enable_ufo_fold()
  require("ufo").closeFoldsWith()
end
M.more_folding = function()  -- zm
  M.enable_ufo_fold()
  require("ufo").openFoldsExceptKinds()
end

-- Peek/preview a closed fold.
M.peek_folded_lines = function()
  local enter = false
  local include_next_line = false
  require("ufo").peekFoldedLinesUnderCursor(enter, include_next_line)
end

function M.setup_folding_keymaps()
  vim.keymap.set('n', 'zR', M.open_all_folds,  {desc='ufo - open all folds'})
  vim.keymap.set('n', 'zM', M.close_all_folds, {desc='ufo - close all folds'})
  vim.keymap.set('n', 'zr', M.reduce_folding,  {desc='ufo - reduce fold (zr)'})
  vim.keymap.set('n', 'zm', M.more_folding,    {desc='ufo - fold more (zm)'})
  vim.keymap.set('n', 'zp', M.peek_folded_lines, {desc='ufo - peek and preview folded lines'})
end

function M.setup()
  M.setup_ufo()
  M.setup_folding_keymaps()

  -- Workaround for neovim/neovim#20726: Ctrl-C on terminal can make neovim hang
  vim.cmd [[
    augroup terminal_disable_fold
      autocmd!
      autocmd TermOpen * setlocal foldmethod=manual
    augroup END
  ]]
end

-- Resourcing support
if ... == nil then
  M.setup()
end

return M
