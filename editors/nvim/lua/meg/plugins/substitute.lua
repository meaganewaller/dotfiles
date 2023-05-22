local sub = require("substitute")
local config = {
	on_substitute = nil,
	yank_substituted_text = false,
	highlight_substituted_text = {
		enabled = false,
		timer = 500,
	},
	range = {
		prefix = "gr",
		prompt_current_text = false,
		confirm = false,
		complete_word = false,
		motion1 = false,
		motion2 = false,
		suffix = "",
	},
	exchange = {
		motion = false,
		use_esc_to_cancel = true,
	},
}

nx.map({
	{ "p", require("substitute").visual, { noremap = true }, mode = "x" },
})
