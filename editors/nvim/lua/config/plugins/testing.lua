return {
  {
    "nvim-neotest/neotest",
    cond = not vim.g.vscode,
    ft = { 'ruby', 'js', 'ts', 'go' },
    dependencies = {
      'olimorris/neotest-rspec',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },

    opts = function()
      return {
        adapters = {
          require("neotest-rspec")({
            rspec_cmd = function()
              local local_rspec = "./bin/rspec"
              if vim.fn.executable(local_rspec) == 1 then
                return local_rspec
              end

              return vim.tbl_flatten({ "bundle", "exec", "rspec" })
            end
          })
        }
      }
    end,

    config = function(_, opts)
      local neotest = require("neotest")
      neotest.setup(opts)

      require("which-key").register({
        ["<space>"] = {
          t = {
            name = "Tests...",
            a = { function() neotest.run.attach() end, "Show output of running test" },
            f = { function() neotest.run.run(vim.fn.expand("%")) end, "Run all in file" },
            l = { function() neotest.run.run_last() end, "Run last" },
            o = { function() neotest.output.open() end, "Test Output in floating window" },
            p = { function() neotest.output_panel.toggle() end, "Test Output in panel" },
            s = { function() neotest.summary.toggle() end, "Test Summary panel" },
            t = { function() neotest.run.run() end, "Run nearest" },
          }
        }
      })
    end
  }
}
