-- https://github.com/smjonas/live-command.nvim

-- { == Configuration ==> ==================================================== }
local live_command = require("live_command")

live_command.setup({
  debug = true,
  commands = {
    Norm = { cmd = "norm" },
    G = { cmd = "g" },
    D = { cmd = "d" },
    Reg = {
      cmd = "norm",
      args = function(opts) return (opts.count == -1 and "" or opts.count) .. "@" .. opts.args end,
      range = "",
    },
    LSubvert = { cmd = "Subvert" },
  },
})
-- <== }
