vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },
})

require("oil").setup()

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Oil" })
