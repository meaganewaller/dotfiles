-- Label-based jumps with flash.nvim. Keymaps are the ones its README
-- recommends. `s`/`S` replace the native substitute-char/line commands,
-- which `cl`/`cc` already cover. setup() runs eagerly because flash's char
-- mode also upgrades f/F/t/T/;/, in place.
vim.pack.add({
  { src = "https://github.com/folke/flash.nvim" },
})

local flash = require("flash")
flash.setup()

-- Function rhs rather than `:lua`, which flash warns breaks dot-repeat.
local map = vim.keymap.set
map({ "n", "x", "o" }, "s", function()
  flash.jump()
end, { desc = "Flash" })
map({ "n", "x", "o" }, "S", function()
  flash.treesitter()
end, { desc = "Flash Treesitter" })
map("o", "r", function()
  flash.remote()
end, { desc = "Remote Flash" })
map({ "o", "x" }, "R", function()
  flash.treesitter_search()
end, { desc = "Treesitter Search" })
-- Command-line mode only; the <C-s> save map in plugin/window.lua is n/i/v.
map("c", "<C-s>", function()
  flash.toggle()
end, { desc = "Toggle Flash Search" })
