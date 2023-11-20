local M = {}

M.config = function()
  local server_configs = {
    golangci_lint_ls = {},
    gopls = {},

    eslint = {},
    tsserver = {},
    jsonls = {},
    yamlls = {},
    graphql = {},
    lua_ls = {
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          completion = {
            callSnippet = "Replace",
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
              [vim.fn.expand "$VIMRUNTIME/lua"] = true,
              [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            },
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    },
  }

  local schemastore_ok, schemastore = pcall(require, "schemastore")
  if schemastore_ok then
    server_configs["jsonls"] =
      vim.tbl_deep_extend("force", server_configs["jsonls"], {
        settings = {
          json = {
            schemas = schemastore.json.schemas(),
          },
        },
      })

    server_configs["yamlls"] =
      vim.tbl_deep_extend("force", server_configs["yamlls"], {
        settings = {
          schemas = schemastore.yaml.schemas {
            extra = {
              description = "serverless",
              fileMatch = "serverless.*.yml,serverless.yml,serverless.yaml",
              name = "serverless.yaml",
              url = "https://raw.githubusercontent.com/lalcebo/json-schema/master/serverless/reference.json",
            },
          },
        },
      })
  end

  return server_configs
end

return M
