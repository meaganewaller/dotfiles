local keymaps = require("meg.nvim.keymaps")
local mappings = require("meg.mappings")

---@diagnostic disable-next-line: unused-local
local function on_attach(client, bufnr)
  client.server_capabilities.documentRangeFormattingProvider = false
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  require("lsp_signature").on_attach({
    bind = true,
    handler_opts = {
      border = "single",
    },
    hint_enable = false,
  })

  keymaps.register_bufnr(bufnr, "n", mappings.editor_on_text)
end

local m = {}
m.setup = function()
  local capabilities
  local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if not ok then
    capabilities = vim.lsp.protocol.make_client_capabilities()
  else
    capabilities = cmp_nvim_lsp.default_capabilities()
  end

  capabilities.textDocument.completion.completionItem.snippetSupport = true

  require("meg.language.lsp").setup(capabilities, on_attach)
end

return m
