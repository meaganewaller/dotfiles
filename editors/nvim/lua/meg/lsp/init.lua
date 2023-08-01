local M = {}

local function default_lsp_config(attach, capabilities)
  local default_config = {
    on_attach = attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }
  return default_config
end

function M.setup_lsp()
  local lsp_setup = require("meg.lsp.config")
  lsp_setup.config_handlers()
  local attach = lsp_setup.attach()
  local capabilities = lsp_setup.capabilities()
  local lspconfig = require("lspconfig")
  local default_servers = { "solargraph" }
  local custom_servers = {
    "graphql",
    "eslint",
    "lua_ls",
    "bashls",
    "pylance",
    "clangd",
    "html",
  }
  local has_plugin, _ = pcall(require, "typescript")
  if has_plugin then
    require("typescript").setup({ server = { on_attach = attach } })
  end

  -- table.insert(custom_servers, package_installed('vue') and 'volar' or 'tsserver')
  local default_config = default_lsp_config(attach, capabilities)
  for _, lsp in ipairs(custom_servers) do
    local present, config = pcall(require, "meg.lsp.settings." .. lsp)
    if present then
      lspconfig[lsp].setup(config.config_table(attach, capabilities))
    else
      lspconfig[lsp].setup(default_config)
    end
  end
  for _, lsp in ipairs(default_servers) do
    lspconfig[lsp].setup(default_config)
  end
end

return M
