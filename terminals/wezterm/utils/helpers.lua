local wezterm = require("wezterm")
-- local act = wezterm.action
local M = {}

function M.get_tab_index(window)
	local mux_window = window:mux_window()
	if mux_window == nil then
		return -1
	end
	local tab_list = mux_window:tabs_with_info()
	for _, item in ipairs(tab_list) do
		if item.is_active then
			return item.index
		end
	end
end

function M.get_active_pane_info(pane)
	local tab = pane:tab()
	if tab == nil then
		return {}
	end
	local pane_list = tab:panes_with_info()
	for _, item in ipairs(pane_list) do
		if item.is_active then
			return item
		end
	end
end

function M.file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

return M
