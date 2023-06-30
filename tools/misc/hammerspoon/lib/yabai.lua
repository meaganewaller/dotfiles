local M = {}

function M.bind_command(mods, key, cmd)
	Hyper:bind(mods, key, function()
		os.execute(cmd)
	end)
end

return M
