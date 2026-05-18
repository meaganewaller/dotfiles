-- mini.nvim — a small set of well-scoped modules pulled from the same
-- meta-repo via vim.pack. Each module is loaded behind a pcall so a
-- partial clone (or future module rename) never bricks startup.

vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.nvim" },
})

local function setup(module, opts)
  local ok, mod = pcall(require, module)
  if ok then
    mod.setup(opts or {})
  end
  return ok
end

setup("mini.bufremove")
setup("mini.pairs")
setup("mini.surround")
setup("mini.comment")
setup("mini.ai")
setup("mini.files")
setup("mini.completion")
setup("mini.statusline", { use_icons = false })

-- Buffer management bindings paired with mini.bufremove so closing a
-- buffer doesn't kill the window layout.
local ok_bufremove, bufremove = pcall(require, "mini.bufremove")
if ok_bufremove then
  vim.keymap.set("n", "<Space>bd", function()
    bufremove.delete(0, false)
  end, { desc = "Buffer: delete" })
  vim.keymap.set("n", "<Space>bD", function()
    bufremove.delete(0, true)
  end, { desc = "Buffer: delete (force)" })
end

vim.keymap.set("n", "<Space>bn", "<cmd>bnext<CR>", { desc = "Buffer: next" })
vim.keymap.set("n", "<Space>bp", "<cmd>bprevious<CR>", { desc = "Buffer: previous" })
vim.keymap.set("n", "<Space>bb", "<cmd>buffer #<CR>", { desc = "Buffer: alternate" })

-- mini.files explorer; opens at the current buffer's path so navigation
-- starts where you already are. Toggles closed if already open.
local ok_files, files = pcall(require, "mini.files")
if ok_files then
  vim.keymap.set("n", "<Space>e", function()
    if not files.close() then
      files.open(vim.api.nvim_buf_get_name(0))
    end
  end, { desc = "Files: toggle explorer at current buffer" })
end

-- mini.clue — keymap hint popup after a prefix is pressed. Triggers list
-- only the prefixes we actually use (custom + the common vim built-ins);
-- gen_clues fills in descriptions for the built-in ones automatically.
local ok_clue, clue = pcall(require, "mini.clue")
if ok_clue then
  clue.setup({
    triggers = {
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },
      { mode = "n", keys = "<C-w>" },
    },
    clues = {
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.windows(),
      clue.gen_clues.z(),
      { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
      { mode = "n", keys = "<Leader>l", desc = "+LSP" },
    },
    window = { delay = 200 },
  })
end
