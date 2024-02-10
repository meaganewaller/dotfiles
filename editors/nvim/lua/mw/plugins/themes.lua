return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "dawn",
      })
    end,
  },
  {
    "szorfein/ombre.vim",
    name = "ombre",
    lazy = false,
    priority = 1000,
  },
}
