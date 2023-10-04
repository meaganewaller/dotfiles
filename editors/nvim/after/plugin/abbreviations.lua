local M = {}

function M.iabbrev(lhs, rhs, ft)
	ft = ft or nil

	if ft then
	else
		vim.cmd.iabbrev(string.format([[%s %s]], lhs, rhs))
	end
end

vim.cmd.cabbrev('options', 'vert options')

return M
