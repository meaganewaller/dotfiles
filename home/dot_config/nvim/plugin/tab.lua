-- Tab page navigation under the <Space>t prefix.

local map = vim.keymap.set

map("n", "<Space>tn", "<cmd>tabnew<CR>", { desc = "Tab: new" })
map("n", "<Space>tc", "<cmd>tabclose<CR>", { desc = "Tab: close" })
map("n", "<Space>to", "<cmd>tabonly<CR>", { desc = "Tab: close others" })
map("n", "<Space>tl", "<cmd>tabnext<CR>", { desc = "Tab: next" })
map("n", "<Space>th", "<cmd>tabprevious<CR>", { desc = "Tab: previous" })
map("n", "<Space>tL", "<cmd>+tabmove<CR>", { desc = "Tab: move right" })
map("n", "<Space>tH", "<cmd>-tabmove<CR>", { desc = "Tab: move left" })

-- Quick numeric jumps: <Space>1..9 -> tab N.
for i = 1, 9 do
  map("n", "<Space>" .. i, i .. "gt", { desc = "Tab: go to " .. i })
end
