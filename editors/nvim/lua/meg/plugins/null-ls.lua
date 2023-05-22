local nls = require("null-ls")
local helpers = require("null-ls.helpers")
local methods = require("null-ls.methods")

nls.register({
	nls.builtins.formatting.black,
	nls.builtins.diagnostics.fish,
	nls.builtins.formatting.fish_indent,
	nls.builtins.formatting.stylua,
	nls.builtins.diagnostics.proselint,
})

nls.setup({
	on_attach = function(_, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
			if vim.lsp.buf.format then
				vim.lsp.buf.format()
			elseif vim.lsp.buf.formatting then
				vim.lsp.buf.formatting()
			end
		end, { desc = "Format current buffer with LSP" })
		nx.map({ "<LocalLeader>f", ":Format<CR>", { desc = "Format current buffer with LSP", buffer = bufnr } })
	end,
})
