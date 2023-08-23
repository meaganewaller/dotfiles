local keymaps = require("meg.nvim.keymaps")
local mappings = require("meg.mappings")

---@diagnostic disable-next-line: unused-local
local function on_attach(client, bufnr)
  -- client.server_capabilities.documentRangeFormattingProvider = false
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  if client.name == "yamlls" then
    client.server_capabilities.document_formatting = true
  end

  local has_illuminate, illuminate = pcall(require, 'illuminate')
  if has_illuminate then
    illuminate.on_attach(client)
  end

  require("lsp_signature").on_attach({
    bind = true,
    doc_lines = 10,
    hint_enable = true,
    hint_prefix = "🐼 ", -- Panda for parameter
    hint_scheme = "String",
    handler_opts = {
      border = "shadow",
    },
    decorator = { "`", "`" }, -- or decorator = {"***", "***"}  decorator = {"**", "**"} see markdown help
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

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true }),
    pattern = { "*.go", "*.rs", "*.lua", "*.py", "*.rb", "*.rake", "*.{yaml,yml}" },
    callback = function(opts)
      opts = opts or {}
      opts.id = nil
      vim.lsp.buf.format(opts)
    end
  })
end

return m
