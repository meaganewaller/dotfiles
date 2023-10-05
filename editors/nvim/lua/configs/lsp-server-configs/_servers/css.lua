return {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_dir = require("lspconfig").util.root_pattern("package.json", ".git"),
  settings = {
    css = {
      validate = true,
    },
    less = {
      validate = true,
    },
    scss = {
      validate = true,
    },
  },
  on_attach = function(client, server)
    if server == "efm" then
      client.server_capabilities.documentFormattingProvider = true
    else
      client.server_capabilities.documentFormattingProvider = false
    end
  end,
}
