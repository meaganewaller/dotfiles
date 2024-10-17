return {
  'toppair/peek.nvim',
  event = { 'VeryLazy' },
  build = 'deno task --quiet build:fast',
  config = function()
    require('peek').setup()
    require('which-key').add({ "<Leader>mp", group = 'markdown preview' })

    vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
    vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
  end,
  keys = {
    { "<Leader>mpo", "<cmd>PeekOpen<cr>", desc = "Open markdown preview" },
    { "<Leader>mpc", "<cmd>PeekClose<cr>", desc = "Close markdown preview" },
  }
}
