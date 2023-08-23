local M = {}

function M.setup(capabilities, on_attach)
  require("lspconfig").vuels.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

return M
