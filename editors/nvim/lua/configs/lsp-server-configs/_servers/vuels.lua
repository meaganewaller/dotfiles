return {
  cmd = { "vls" },
  filetypes = { "vue" },
  root_dir = require("lspconfig.util").root_pattern("package.json", "vue.config.js", ".git"),
  init_options = {
    config = {
      css = {},
      emmet = {},
      html = {
        suggest = {}
      },
      javascript = {
        format = {}
      },
      stylusSupremacy = {},
      typescript = {
        format = {}
      },
      vetur = {
        completion = {
          autoImport = true,
          tagCasing = "kebab"
        },
        format = {
          defaultFormatter = {
            js = "none",
            ts = "none"
          },
          defaultFormatterOptions = {},
          scriptInitialIndent = false,
          styleInitialIndent = false
        },
        useWorkspaceDiagnostics = false,
        validation = {
          script = true,
          style = true,
          template = true
        }
      }
    }
  }
}
