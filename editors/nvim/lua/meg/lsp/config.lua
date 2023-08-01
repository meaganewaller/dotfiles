local M = {}

local capability_settings = {
  completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = {
      valueSet = { 1 },
    },
    resolveSupport = {
      properties = { "documentation", "detail", "additionalTextEdits" },
    },
  },
}

M.setup_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local completionItem = capabilities.textDocument.completion.completionItem
  completionItem = vim.tbl_deep_extend("force", completionItem, capability_settings.completionItem)
  return capabilities
end

M.config_handlers = function()
  local config_diagnostics = function()
    local function lspSymbol(name, icon)
      local hl = "DiagnosticSign" .. name
      vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
    end
    lspSymbol("Error", "")
    lspSymbol("Info", "")
    lspSymbol("Hint", "")
    lspSymbol("Warn", "")
    -- suppress error messages from lang servers
  end
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {})
  config_diagnostics()
end

M.attach = function()
  local function attach(client, bufnr)
    local function buf_set_option(...)
      vim.api.nvim_buf_set_option(bufnr, ...)
    end
    require("meg.plugins.completion.cmp_configs.lspsignature_cmp").setup(bufnr)
    client.server_capabilities.semanticTokensProvider = nil
    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
    require("meg.keymaps").lsp()
  end
  return attach
end

return M

-- local function capabilities()
--   local client_caps = vim.lsp.protocol.make_client_capabilities()
--   client_caps.textDocument.completion.completionItem.snippetSupport = true
--   client_caps.textDocument.foldingRange = {
--     dynamicRegistration = false,
--     lineFoldingOnly = true,
--   }
--   client_caps.textDocument.completion.completionItem.resolveSupport = {
--     properties = {
--       "documentation",
--       "detail",
--       "additionalTextEdits",
--     },
--   }
--
--   -- Use lsp to populate cmp completions
--   -- local loaded, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
--   -- if not loaded then
--   --   mw.loading_error_msg("cmp_nvim_lsp")
--   -- end
--   -- client_caps = cmp_nvim_lsp.default_capabilities(client_caps)
--
--   return client_caps
-- end
--
-- local function on_attach(client, bufnr)
--   local server_caps = client.server_capabilities
--
--   if client.supports_method("textDocument/documentSymbol") then
--     require("meg.lsp.utils.nvim-navic").setup(client, bufnr)
--   end
--
--   -- if server_caps.documentFormattingProvider then
--   --   vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
--   -- end
-- end
--
-- local function setup_language_servers(lspconfig, servers, root_files)
--   for _, name in ipairs(servers) do
--     if name == "bashls" then
--       lspconfig[name].setup({
--         filetypes = { "makefile", "sh", "zsh" },
--         on_attach = on_attach,
--         capabilities = capabilities(),
--       })
--     elseif name == "emmet_ls" then
--       lspconfig[name].setup({
--         filetypes = { "html" },
--         on_attach = on_attach,
--         capabilities = capabilities(),
--       })
--     elseif name == "eslint" then
--       lspconfig[name].setup({
--         root_dir = lspconfig.util.root_pattern(root_files),
--         on_attach = on_attach,
--         capabilities = capabilities(),
--         settings = {
--           codeAction = {
--             disableRuleComment = {
--               enable = true,
--               location = "separateLine",
--             },
--             showDocumentation = {
--               enable = true,
--             },
--           },
--           codeActionOnSave = {
--             enable = false,
--             mode = "all",
--           },
--           experimental = {
--             useFlatConfig = false,
--           },
--           -- format = true,
--           nodePath = "",
--           onIgnoredFiles = "off",
--           packageManager = "npm",
--           problems = {
--             shortenToSingleLine = false,
--           },
--           quiet = false,
--           rulesCustomizations = {},
--           run = "onType",
--           useESLintClass = false,
--           validate = "on",
--           workingDirectory = {
--             mode = "location",
--           },
--         },
--       })
--     elseif name == "lua_ls" then
--       -- Make the server aware of Neovim runtime files when editing Neovim config
--       local library = vim.fn.getcwd() == vim.fn.stdpath("config") and vim.api.nvim_get_runtime_file("", true) or nil
--       lspconfig[name].setup({
--         root_dir = lspconfig.util.root_pattern(root_files),
--         settings = {
--           Lua = {
--             telemetry = {
--               enable = false,
--             },
--             format = {
--               enable = false,
--             },
--             workspace = {
--               library = library,
--             },
--           },
--         },
--         on_attach = on_attach,
--         capabilities = capabilities(),
--       })
--     else
--       lspconfig[name].setup({
--         on_attach = on_attach,
--         capabilities = capabilities(),
--       })
--     end
--   end
-- end
--
-- function M.setup(icons, border, root_files, servers)
--   local loaded, lspconfig = pcall(require, "lspconfig")
--   if not loaded then
--     mw.loading_error_msg("lspconfig")
--     return
--   end
--   -- Set lspinfo window borders
--   require("lspconfig.ui.windows").default_options.border = border
--
--   require("meg.lsp.mason").setup(icons, border)
--   require("meg.lsp.mason.config").setup()
--
--   setup_language_servers(lspconfig, servers, root_files)
--
--   require("meg.lsp.utils.null-ls").setup(border, root_files)
-- end
--
-- return M
