local cmdify = require('helpers').cmdify
local themed_telescope = require('helpers').themed_telescope
return {
  g = {
    name = "Go to...",
    D = { cmdify('lua vim.lsp.buf.declaration()'), "Declaration" },
    d = { cmdify('lua vim.lsp.buf.definition()'), "Definition" },
    h = { cmdify('lua vim.lsp.buf.hover()'), "Hover" },
    i = { cmdify('lua vim.lsp.buf.implementation()'), "Implementation" },
    y = { themed_telescope(require('telescope.builtin').lsp_type_definitions), "Type definition" },
    r = { themed_telescope(require('telescope.builtin').lsp_references), "References" },
  },
  ["<space>"] = {
    c = {
      name = "Code...",
      a = { cmdify('lua vim.lsp.buf.code_action()'), "LSP code action" },
      f = { cmdify('lua vim.lsp.buf.format({timeout_ms = 10000})'), "LSP Format" },
      r = {
        name = "Refactor...",
        r = { cmdify('lua vim.lsp.buf.rename()'), "Rename symbol" },
      },
    },
    d = {
      name = "Diagnostics...",
      d = { cmdify('lua vim.diagnostic.open_float()'), "Line diagnostics" },
      n = { cmdify('lua vim.diagnostic.goto_next()'), "Next" },
      p = { cmdify('lua vim.diagnostic.goto_prev()'), "Previous" },
      l = { cmdify("Trouble document_diagnostics"), "Diagnostics in file" },
    },
    s = {
      name = "Search...",
      s = { themed_telescope(require('telescope.builtin').lsp_dynamic_workspace_symbols), "Symbol in workspace" },
      n = { cmdify("Navbuddy"), "Open Navbuddy" },
    }
  },
}
