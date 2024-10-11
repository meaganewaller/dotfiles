local function augroup(name)
	return vim.api.nvim_create_augroup('custom_' .. name, { clear = true })
end

-- Clear command line immediately
vim.api.nvim_create_autocmd('CmdlineLeave', {
  group = augroup('clear_cmdline'),
  callback = function()
    vim.defer_fn(function()
      vim.cmd([[ echon ' ' ]])
    end, 0)
  end,
})

-- Persist folds.
vim.api.nvim_create_autocmd('BufWinLeave', {
  group = augroup('persist_folds_save'),
  pattern = '?*.*',
  command = 'mkview',
})
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = augroup('persist_folds_load'),
  pattern = '?*.*',
  command = 'silent! loadview',
})

-- Delete [No Name] buffers on leave.
vim.api.nvim_create_autocmd('BufLeave', {
  group = augroup('clear_no_name'),
  pattern = '{}', -- No file name.
  callback = function()
    if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' then
      vim.bo.buftype = 'nofile'
      vim.bo.bufhidden = 'wipe'
    end
  end,
})

-- Makes sure that any opened buffer which is contained in a git repo will be tracked.
vim.api.nvim_create_autocmd('BufEnter', {
  group = augroup('track_repos'),
  command = ':lua require("lazygit.utils").project_root_dir()',
})

-- Check if any buffers were changed outside of Vim.
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime'),
  command = 'checktime',
})

-- Highlight on yank.
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highlight_yank'),
  callback = function()
    vim.highlight.on_yank({
      timeout = 200,
    })
  end,
})

-- Resize splits if window got resized.
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = augroup('resize_splits'),
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- Close some filetypes with <q>.
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('close_with_q'),
  pattern = {
    'checkhealth',
    'gitsigns.blame',
    'grug-far',
    'help',
    'lspinfo',
    'man',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'qf',
    'spectre_panel',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- Create intermediate directory if it does not exist when saving a file.
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = augroup('auto_create_dir'),
  callback = function(event)
    if event.match:match('^%w%w+://') then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})
