local recorder = require("recorder")

local conf = {
	slots = { "a", "b" },
	mapping = {
		startStopRecording = "q",
		playMacro = "Q",
		switchSlot = "<C-q>",
		editMacro = "cq",
		yankMacro = "yq",
		addBreakPoint = "##",
	},
	clear = false,
	logLevel = vim.log.levels.INFO,
	lessNotifications = true,
	dapSharedKeymaps = false,
}
