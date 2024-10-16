return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('fzf-lua').setup({})
  end,
  keys = function()
    require('which-key').add({ '<leader>f', group = 'find' })

    return {
      { "<c-f>", require('fzf-lua').files, desc = "Fzf Files" },
      { "<leader>fr", require('fzf-lua').grep, desc = "by grep" },
      { "<leader>ff", require('fzf-lua').files, desc = "by file" },
      { "<leader>fb", require('fzf-lua').buffers, desc = "by buffer" },
      { "<leader>fl", require('fzf-lua').blines, desc = "by lines" },
      { "<leader>ft", require('fzf-lua').btags, desc = "by tags" },
      { "<leader>fg", require('fzf-lua').git_files, desc = "by git" },
    }
  end,
}
