local ok, _ = pcall(require, "lspconfig")
if not ok then return end

local lsps = {
  require("meg.language.lsp.bash"),
  require("meg.language.lsp.cssls"),
  require("meg.language.lsp.dockerfile"),
  require("meg.language.lsp.go"),
  require("meg.language.lsp.html"),
  require("meg.language.lsp.null-ls"),
  require("meg.language.lsp.lua"),
  require("meg.language.lsp.nix"),
  require("meg.language.lsp.rust"),
  require("meg.language.lsp.tailwindcss"),
  require("meg.language.lsp.terraform"),
  require("meg.language.lsp.typescript"),
  require("meg.language.lsp.yaml"),
  require("meg.language.lsp.vuels"),
}

local M = {}

function M.setup(capabilities, on_attach)
  vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "󰅚" })
  vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "󰀪" })
  vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = "󰋽" })
  vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "󰌶" })

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      prefix = "󰄮",
    },
  })
  local hl_name = "FloatBorder"
  local border = {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
  -- LSP settings (for overriding per client)
  local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
  }

  for _, server in pairs(lsps) do
    if server ~= nil then server.setup(capabilities, on_attach) end
  end
end

return M
