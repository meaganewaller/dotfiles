return {
  "rcarriga/neotest",
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "olimorris/neotest-rspec",
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require('neotest-rspec')({
          rspec_cmd = function()
            return vim.tbl_flatten({
              "bundle",
              "exec",
              "rspec",
            })
          end,
        })
      },
    })

    local map = require("meg.utils").map

    map("n", "<Leader>tt", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", "Test file")
    map("n", "<Leader>tn", "<cmd>lua require('neotest').run.run()<CR>", "Test nearest")
    map("n", "<Leader>td", "<cmd>lua require('neotest').summary.toggle()<CR>", "Test summary")
    map("n", "<Leader>to", "<cmd>lua require('neotest').output_panel.toggle()<CR>", "Test output")
  end,
}
