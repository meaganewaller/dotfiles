local ok, qa = pcall(require, "quick_action")

if not ok then return end

qa.set_keymap("n", "<CR>", "menu")
qa.add("menu", {
  name = "Show diagnostics",
  condition = function()
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    return not vim.tbl_isempty(vim.diagnostic.get(0, { lnum = lnum }))
  end,
  action = function() vim.diagnostic.open_flot(0, { scope = "line", border = "rounded" }) end,
})
