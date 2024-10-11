return {
  'kdheepak/lazygit.nvim',
  event = 'VeryLazy',
  keys = function()
    require('which-key').add({ '<leader>g', group = 'git' })

    return {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'gui' },
    }
  end,
}
