local wezterm = require("wezterm") --[[@as wezterm.WezTerm]]

local utils = {}

function utils.load_json_file(filename)
	local file = io.open(filename, "r")
	if not file then
		wezterm.log_error("Failed to open file: " .. filename)
		return
	end
	local content = file:read("*a")
	file:close()
	local data = wezterm.serde.json_decode(content)
	if not data then
		wezterm.log_error("Failed parse JSON data from file: " .. filename)
	end
	return data
end

---save value to filename
---@param value table|any
---@param filename string
function utils.save_json_file(value, filename)
	local content = wezterm.serde.json_encode_pretty(value)

	local file = io.open(filename, "w")
	if not file then
		wezterm.log_error("Failed to open file: " .. filename)
		return
	end
	file:write(content)
	file:close()
end

---@generic T
---@generic R
---@param func fun(value: T): R Function
---@param t T[]
---@return R[] rettab Table of transformed values
function utils.map(func, t)
	local rettab = {}
	for k, v in ipairs(t) do
		rettab[k] = func(v)
	end
	return rettab
end

--- Same with vim.tbl_values
---@generic T
---@param t table<any, T> (table) Table
---@return T[] : List of values
function utils.tbl_values(t)
	local values = {}
	for _, v in
		pairs(t --[[@as table<any,any>]])
	do
		table.insert(values, v)
	end
	return values
end

return utils
