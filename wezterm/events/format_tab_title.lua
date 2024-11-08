local wezterm = require("wezterm")
local nf = wezterm.nerdfonts

local function number_to_icon(number)
	if number == 0 then
		return nf.md_numeric_0
	elseif number == 1 then
		return nf.md_numeric_1
	elseif number == 2 then
		return nf.md_numeric_2
	elseif number == 3 then
		return nf.md_numeric_3
	elseif number == 4 then
		return nf.md_numeric_4
	elseif number == 5 then
		return nf.md_numeric_5
	elseif number == 6 then
		return nf.md_numeric_6
	elseif number == 7 then
		return nf.md_numeric_7
	elseif number == 8 then
		return nf.md_numeric_8
	elseif number == 9 then
		return nf.md_numeric_9
	else
		return nf.md_numeric_9_plus
	end
end

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, conf, hover, max_width)
	local title = tab_title(tab)
	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = nf.md_magnify .. " "
	end
	return " " .. number_to_icon(tab.tab_index + 1) .. " " .. zoomed .. title .. " "
end)
