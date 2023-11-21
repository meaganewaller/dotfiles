local M = {}

local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not ok then
  vim.notify "Could not load nvim-cmp"
  return
end

M = cmp_nvim_lsp.default_capabilities()

M.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

return M
