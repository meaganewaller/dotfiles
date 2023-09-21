local M = {}
local memoDir = ""
function M.eslint(dir)
  vim.cmd([[compiler eslint]])

  local files = "*.{ts,js,jsx,tsx,svelte}"
  if memoDir ~= "" then
    dir = memoDir
  end
  if dir ~= "" then
    memoDir = dir
    dir = dir .. "/**/"
  end
  vim.cmd("make " .. dir .. files)
  vim.cmd([[Trouble quickfix]])
end

vim.api.nvim_create_user_command("Lint", function(opts)
  M.eslint(opts.args)
end, { nargs = "?", desc = "Use ESLint in the given directory and launch quickfix in Trouble" })

vim.api.nvim_create_user_command("DiagnosticToggle", function()
	if vim.diagnostic.is_disabled() then
		vim.diagnostic.enable()
	else
		vim.diagnostic.disable()
	end
end, { desc = "Toggle diagnostics" })

return M
