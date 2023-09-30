return {
  {
    "nvim-neotest/neotest",
    branch = "feat/watch-consumer",
    keys = { "<Leader>n" },
    config = function() require("configs.neotest") end,
    dependencies = {
      { "andythigpen/nvim-coverage" },
      { "nvim-neotest/neotest-python" },
      { "nvim-neotest/neotest-plenary" },
      { "rouge8/neotest-rust" },
      { "olimorris/neotest-rspec" },
      {
        "mfussenegger/nvim-dap",
        lazy = true,
        config = function() require("configs.dap") end,
      },
      { "mfussenegger/nvim-dap-python" },
      { "rcarriga/nvim-dap-ui" },
    },
  },
}
