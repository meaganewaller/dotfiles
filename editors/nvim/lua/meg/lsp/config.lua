local utils = require "meg.utils"

local M = {
  lsp_formatting_augroup = vim.api.nvim_create_augroup("LspFormatting", {})
}

function M.common_on_attach(client, bufnr)
  local keybindings = require "meg.keybindings"
  local wk = require "which-key"

  local keybinding_definitions = keybindings.on_lsp_attach(client, bufnr)
  for _, definition in ipairs(keybinding_definitions) do
    wk.register(definition.mappings, definition.opts)
  end
end

function M.make_capabilities(customs)
  local cmp_nvim_lsp = require "cmp_nvim_lsp"

  local capabilities = vim.tbl_deep_extend("force", M.default_capabilities, cmp_nvim_lsp.default_capabilities())

  if customs ~= nil then
    for _, custom in ipairs(customs) do
      capabilities = vim.tbl_deep_extend("force", capabilities, custom)
    end
  end

  return capabilities
end

function M.opt_builder()
  return {
    on_attach = M.common_on_attach,
    lsp_flags = { debounce_text_changes = 150 },
    capabilities = M.make_capabilities(),
  }
end

M.default_capabilities = {
  textDocument = {
    completion = {
      completionItem = {
        documentationFormat = { "markdown", "plaintext" },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
          properties = { "documentation", "detail", "additionalTextEdits" },
        },
      },
    },
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    },
  },
}

function M.setup_diagnostics()
  local get_icon = utils.get_icon

  local signs = {
    {
      name = "DiagnosticSignError",
      text = get_icon "DiagnosticError",
      texthl = "DiagnosticSignError",
    },
    {
      name = "DiagnosticSignWarn",
      text = get_icon "DiagnosticWarn",
      texthl = "DiagnosticSignWarn",
    },
    {
      name = "DiagnosticSignHint",
      text = get_icon "DiagnosticHint",
      texthl = "DiagnosticSignHint",
    },
    {
      name = "DiagnosticSignInfo",
      text = get_icon "DiagnosticInfo",
      texthl = "DiagnosticSignInfo",
    },
    {
      name = "DapStopped",
      text = get_icon "DapStopped",
      texthl = "DiagnosticWarn",
    },
    {
      name = "DapBreakpoint",
      text = get_icon "DapBreakpoint",
      texthl = "DiagnosticInfo",
    },
    {
      name = "DapBreakpointRejected",
      text = get_icon "DapBreakpointRejected",
      texthl = "DiagnosticError",
    },
    {
      name = "DapBreakpointCondition",
      text = get_icon "DapBreakpointCondition",
      texthl = "DiagnosticInfo",
    },
    {
      name = "DapLogPoint",
      text = get_icon "DapLogPoint",
      texthl = "DiagnosticInfo",
    },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, sign)
  end

  local diagnostics = {
    virtual_text = true,
    signs = { active = signs },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focused = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(diagnostics)
end

return M
