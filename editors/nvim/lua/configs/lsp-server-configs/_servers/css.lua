return {
  cmd = { "css-languageserver", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_dir = require("lspconfig").util.root_pattern("package.json"),
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
