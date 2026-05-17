-- mini.nvim — a small set of well-scoped modules pulled from the same
-- meta-repo via vim.pack. Each module is loaded behind a pcall so a
-- partial clone (or future module rename) never bricks startup.

vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.nvim" },
})

local function setup(module, opts)
  local ok, mod = pcall(require, module)
  if ok then mod.setup(opts or {}) end
  return ok
end

setup("mini.bufremove")
setup("mini.pairs")
setup("mini.surround")
setup("mini.comment")
setup("mini.ai")
setup("mini.statusline", { use_icons = false })

-- Buffer management bindings paired with mini.bufremove so closing a
-- buffer doesn't kill the window layout.
local ok_bufremove, bufremove = pcall(require, "mini.bufremove")
if ok_bufremove then
  vim.keymap.set("n", "<Space>bd", function() bufremove.delete(0, false) end, { desc = "Buffer: delete" })
  vim.keymap.set("n", "<Space>bD", function() bufremove.delete(0, true) end, { desc = "Buffer: delete (force)" })
end

vim.keymap.set("n", "<Space>bn", "<cmd>bnext<CR>", { desc = "Buffer: next" })
vim.keymap.set("n", "<Space>bp", "<cmd>bprevious<CR>", { desc = "Buffer: previous" })
vim.keymap.set("n", "<Space>bb", "<cmd>buffer #<CR>", { desc = "Buffer: alternate" })
