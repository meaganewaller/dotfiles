return {
  'ibhagwan/fzf-lua',
  event = "VeryLazy",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local fzf = require('fzf-lua')
    fzf.setup({
      keymap = {
        fzf = {
          ['CTRL-Q'] = 'select-all+accept',
        },
      },
    })
    fzf.register_ui_select()

    local map = require("meg.utils").map

    map("n", "<Leader>/c", function() require("fzf-lua").commands() end, "Search commands")
    map("n", "<Leader>/C", function() require("fzf-lua").command_history() end, "Search command history")
    map("n", "<Leader>/f", function() require("fzf-lua").files() end, "Find files")
    map("n", "<Leader>/o", function() require("fzf-lua").oldfiles() end, "Find recent files")
    map("n", "<Leader>/h", function() require("fzf-lua").highlights() end, "Search highlights")
    map("n", "<Leader>/M", function() require("fzf-lua").marks() end, "Search marks")
    map("n", "<Leader>/k", function() require("fzf-lua").keymaps() end, "Search keymaps")
    map("n", "<Leader>/t", function() require("fzf-lua").treesitter() end, "Search treesitter")
    map("n", "<Leader>/gf", function() require("fzf-lua").git_files() end, "Find git files")
    map("n", "<Leader>/gb", function() require("fzf-lua").git_branches() end, "Search git branches")
    map("n", "<Leader>/gc", function() require("fzf-lua").git_commits() end, "Search git commits")
    map("n", "<Leader>/gC", function() require("fzf-lua").git_bcommits() end, "Search git buffer commits")
    map("n", "<Leader>bc", function() require("fzf-lua").git_bcommits() end, "Search git buffer commits")
    map("n", "<Leader>//", function() require("fzf-lua").resume() end, "Resume FZF")
  end,
}
