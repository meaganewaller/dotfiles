local M = {}

function M.on_attach(_, bufnr)
	nx.map({
		-- { "K", "<Cmd>Lspsaga hover_doc<CR>", desc = "LSP Hover" },
		{ "gp", "<Cmd>Lspsaga peek_definition<CR>", desc = "Peek Definition" },
		{ "gd", "<cmd>Lspsaga goto_definition<CR>" },
		{ "gr", "<Cmd>Lspsaga lsp_finder<CR>", desc = "Show References" },
		-- { "<leader>gl", "<cmd>Lspsaga show_line_diagnostics<CR>" },
		-- { "<leader>gL", "<cmd>Lspsaga show_cursor_diagnostics<CR>" },
		-- Use default vim.lsp.buf.rename() with dressing for now
		-- { "<F2>", "<Cmd>Lspsaga rename<CR>", { "i", "n" }, desc = "Rename" },
		{ "<F12>", "<Cmd>Lspsaga lsp_finder<CR>", desc = "Show References" },
		{ "<leader>lr", "<Cmd>Lspsaga lsp_finder<CR>", desc = "Show References" },
		{ "<leader>ld", "<Cmd>Lspsaga peek_definition<CR>", desc = "Peek definition" },
		{ "<leader>lo", "<Cmd>Lspsaga outline<CR>", desc = "Toggle Symbols Outline" },
		{ "<leader>to", "<Cmd>Lspsaga outline<CR>", desc = "Toggle Symbols Outline", wk_label = "Outline Symbols" },
		{ "<leader>dj", "<Cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next Diagnostic" },
		{ "<leader>dk", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Previous Diagnostic" },
		{ "<leader>la", "<Cmd>Lspsaga code_action<CR>", desc = "Code Action" },
		-- <C-.> works in kitty and GUIs
		{ { "<C-.>", "<A-.>" }, "<Cmd>Lspsaga code_action<CR>", desc = "Code Action" },
	}, { buffer = bufnr })
end

return M
