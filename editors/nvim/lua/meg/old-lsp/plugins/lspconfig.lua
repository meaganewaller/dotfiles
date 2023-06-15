require("lspconfig.ui.windows").default_options.border = nx.opts.float_win_border

nx.map({
  { "<Leader>lI", "<cmd>LspInfo<CR>",    desc = "Info" },
  { "<Leader>lR", "<cmd>LspRestart<CR>", desc = "Restart" }
})
