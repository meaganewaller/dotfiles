require('CopilotChat').setup({
  debug = true,
})

require('avante').setup({
  hints = { enabled = false }
})

require('render-markdown').setup({
  file_types = { "markdown", "Avante" },
})

require("claudecode").setup()
vim.keymap.set('n', '<Leader>ac', '<Cmd>ClaudeCode<cr>', { desc = 'Toggle Claude' })
vim.keymap.set('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Focus Claude' })
vim.keymap.set('n', '<leader>ar', '<cmd>ClaudeCode --resume<cr>', { desc = 'Resume Claude' })
vim.keymap.set('n', '<leader>aC', '<cmd>ClaudeCode --continue<cr>', { desc = 'Continue Claude' })
vim.keymap.set('n', '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', { desc = 'Select Claude model' })
vim.keymap.set('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'Add current buffer' })
vim.keymap.set('v', '<leader>as', '<cmd>ClaudeCodeSend<cr>', { desc = 'Send to Claude' })
vim.keymap.set('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Accept diff' })
vim.keymap.set('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Deny diff' })

vim.g.opencode_opts = {}
vim.o.autoread = true
vim.keymap.set({ 'n', 'x' }, '<leader>oa', function() require('opencode').ask('@this: ', { submit = true }) end, { desc = 'Ask opencode' })
vim.keymap.set({ 'n', 'x' }, '<leader>os', function() require('opencode').select() end, { desc = 'Select opencode action' })
vim.keymap.set({ 'n', 't' }, '<leader>ot', function() require('opencode').toggle() end, { desc = 'Toggle opencode' })
vim.keymap.set({ 'n', 'x' }, '<leader>oo', function() return require('opencode').operator('@this ') end, { desc = 'Add range to opencode', expr = true })
vim.keymap.set('n', '<leader>ol', function() return require('opencode').operator('@this ') .. '_' end, { desc = 'Add line to opencode', expr = true })
vim.keymap.set('n', '<leader>ou', function() require('opencode').command('session.half.page.up') end, { desc = 'Scroll opencode up' })
vim.keymap.set('n', '<leader>od', function() require('opencode').command('session.half.page.down') end, { desc = 'Scroll opencode down' })

