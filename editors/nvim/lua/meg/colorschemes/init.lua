local default_colorscheme = "rose-pine"

pcall(require("meg.colorschemes." .. default_colorscheme))

vim.cmd("colorscheme " .. default_colorscheme)

---Set kitty colorscheme based on neovim colorscheme.
---@param colors string @kitty colorscheme file
local function kitty_colors(colors)
	if not vim.fn.executable("kitty") then return end
	local cmd = "kitty @ --to %s set-colors -a %s"
	local socket = vim.fn.expand("$KITTY_LISTEN_ON")
	vim.fn.system(cmd:format(socket, "~/.config/kitty/" .. colors .. ".conf"))
	vim.cmd("redraw")
end

-- Cutomization - after applying colorscheme
local function set_hl()
	nx.hl({
		{ "Comment", fg = "Comment:fg", italic = true, bold = nx.opts.second_font },
		{ { "Winbar", "FoldColumn" }, link = "LineNr" },
	})

	if vim.g.colors_name == "rose-pine" then
		kitty_colors("dracula")
		require("meg.colorschemes.rose-pine").set_hl()
	elseif vim.g.colors_name == "tokyonight" then
		kitty_colors("tokyonight_storm")
		require("meg.colorschemes.tokyonight").set_hl()
	end

--	require("meg.lsp.plugins.lspsaga").set_hl()
end

nx.au({ { "UIEnter", "Colorscheme" }, callback = set_hl })
