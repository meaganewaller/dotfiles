return {
  {
    "kdheepak/lazygit.nvim",
    init = function()
      local map = require("meg.utils").map

      map("n", "<Leader>G", function()
        require("lazygit").lazygit()
      end, "Lazygit")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
  },
}
