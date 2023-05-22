local opts = {
	guifont = "FiraCode Nerd Font Mono:h14.5",
}

local function set_hl()
	nx.hl({
		-- { "IlluminatedWordText", sp = "LineNr:fg", underline = true },
		{ "IlluminatedWordText", bg = "Visual:bg" },
		{ "IlluminatedWordRead", link = "IlluminatedWordText" },
		{ "IlluminatedWordWrite", link = "IlluminatedWordText" },
	})
end

nx.au({ { "UIEnter", once = true, callback = set_hl } })

return opts
