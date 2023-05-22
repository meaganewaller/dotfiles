return {
	cmd = { "grammarly-languageserver-unofficial", "--stdio" },
  -- TODO: move this to secrets
	init_options = { clientId = vim.os.getenv("GRAMMARLY_CLIENT_ID") },
}
