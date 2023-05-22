-- https://github.com/jose-elias-alvarez/null-ls.nvim

local null_ls = require("null-ls")
local fmt = null_ls.builtins.formatting
-- local diag = null_ls.builtins.diagnostics
-- local ca = null_ls.builtins.code_actions
-- local cmp = null_ls.builtins.completion.spell,

null_ls.setup({
	debug = false,
	sources = {
		fmt.prettierd.with({
			filetypes = { "markdown", "json", "jsonc", "typescript", "yaml" },
			extra_args = { "--use-tabs", "--printWidth: 120", "--semi", "--single-quote" },
			disable = { "vue" },
		}),
		fmt.rustfmt,
		fmt.stylua,
		fmt.yapf,
	},
})
-- <== }
