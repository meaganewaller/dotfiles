local icons = {
  diagnostics = {
    Error = ' ',
    Warn = ' ',
    Hint = ' ',
    Info = ' ',
  },
  git = {
    Added = ' ',
    Modified = ' ',
    Removed = ' ',
  },
  ui = {
    Package = ' ',
    Hidden = ' ',
    Current = ' ',
    Split = ' ',
  },
}

for name, icon in pairs(icons.diagnostics) do
  name = 'DiagnosticSign' .. name
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
end

return icons
