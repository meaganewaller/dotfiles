local augend = require("dial.augend")

require("dial.config").augends:register_group({
	default = {
		augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
		augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
		augend.constant.alias.bool, -- boolean value (true <-> false)
	},
})

nx.map({
	{ "<C-a>", require("dial.map").inc_normal(), desc = "Increment with dial", { noremap = true } },
	{ "<C-x>", require("dial.map").dec_normal(), desc = "Decrement with dial", { noremap = true } },
	{ "<C-a>", require("dial.map").inc_visual(), desc = "Increment with dial", { noremap = true }, mode = "v" },
	{ "<C-x>", require("dial.map").dec_visual(), desc = "Decrement with dial", { noremap = true }, mode = "v" },
	{ "g<C-a>", require("dial.map").inc_gvisual(), desc = "Increment with dial", { noremap = true }, mode = "v" },
	{ "g<C-x>", require("dial.map").dec_gvisual(), desc = "Decrement with dial", { noremap = true }, mode = "v" },
})
