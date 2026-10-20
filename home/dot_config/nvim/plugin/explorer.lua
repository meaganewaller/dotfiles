vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },
  -- `nvim foo.lua:12:5` (as pasted from a stack trace or grep hit) opens
  -- foo.lua at that line/column instead of a new file named "foo.lua:12:5".
  -- No setup: its plugin/ file registers a BufNewFile autocmd, so it loads
  -- eagerly to be in place before the argv files open.
  { src = "https://github.com/lewis6991/fileline.nvim" },
})

require("oil").setup()

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Oil" })
