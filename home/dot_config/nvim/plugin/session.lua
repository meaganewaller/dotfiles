-- Session persistence: closing and reopening a project shouldn't lose the
-- split layout plugin/window.lua just added. Per persistence.nvim's own
-- docs it "will never restore a session automatically" without an autocmd,
-- so this adds one -- gated to a bare `nvim` with no file args, so
-- `nvim somefile.txt` still just opens that file.
vim.pack.add({
  { src = "https://github.com/folke/persistence.nvim" },
})

require("persistence").setup()

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("persistence_restore", { clear = true }),
  nested = true,
  callback = function()
    if vim.fn.argc() == 0 then
      require("persistence").load()
    end
  end,
})

local map = vim.keymap.set
map("n", "<leader>ss", function()
  require("persistence").load()
end, { desc = "Restore session for cwd" })
map("n", "<leader>sS", function()
  require("persistence").select()
end, { desc = "Select session" })
map("n", "<leader>sl", function()
  require("persistence").load({ last = true })
end, { desc = "Restore last session" })
map("n", "<leader>sd", function()
  require("persistence").stop()
end, { desc = "Stop session (don't save on exit)" })
