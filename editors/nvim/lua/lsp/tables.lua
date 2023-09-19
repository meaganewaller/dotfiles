-- TODO: Unified table for mason-managed and manual servers. Some can be installed through mason, some need shadowenv/other stuff/are provided through project config
-- Something like
-- local servers = {
--   lspconfig_name = {
--     auto_install = [nil | false | true | mason_package_name]
--     config = {}
--   }
-- }
local m = {}

-- lspconfig names of servers you want to auto-install with mason. Make sure these also show up in the server_settings table below or they won't be configured
m.auto_install_with_mason = {
  'bashls',
  'cssls',
  'emmet_ls',
  'diagnosticls',
  'html',
  'lua_ls',
  'pyright',
  'rust_analyzer',
  'tsserver',
  'vuels',
  'tailwindcss',
  'marksman',
  'jsonls',
  'efm',
  'solargraph',
}

local prettier_fmt = {
  formatCommand = 'prettierd "${INTPUT}"',
  formatStdin = true,
  env = {
    string.format('PRETTIERD_DEFAULT_CONFIG=%s', vim.fn.expand('~/.prettierrc')),
  },
}

local erb_fmt = {
  formatCommand = 'htmlbeautifier',
  lintDebounce = '2s',
  lintCommand = 'erb -x -T - | ruby -c',
  lintStdin = true,
  lintOffset = 1,
  formatStdin = true
}

local efm_languages = {
  markdown = { prettier_fmt },
  json = { prettier_fmt },
  eruby = { erb_fmt },
  scss = { prettier_fmt },
}

-- Server configs. Assumes these servers are present. Either through Mason (see above) or otherwise
m.server_settings = {
  bashls = {},
  cssls = {},
  diagnosticls = {
    init_options = {
      linters = {
        slimlint = {
          command = "slim-lint",
          rootPatterns = { ".git/" },
          debounce = 100,
          args = { "--reporter", "json", "--stdin-file-path", "%filepath" },
          sourceName = "slim-lint",
          parseJson = {
            errorsRoot = "files[0].offenses",
            line = "location.line",
            message = "${message}",
            security = "severity",
          },
          securities = {
            error = "error",
            warning = "warning",
          },
        },
      },
      filetypes = {
        slim = "slimlint",
      },
    },
  },
  efm = {
    init_options = {
      documentFormatting = true,
    },
    filetypes = vim.tbl_keys(efm_languages),
    settings = {
      rootMarkers = { ".git/" },
      languages = efm_languages
    },
  },
  emmet_ls = {},
  gopls = {},
  html = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
          keywordSnippet = "Replace",
        },
        workspace = {
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      }
    }
  },
  pyright = {},
  rubocop = {},
  rust_analyzer = {},
  solargraph = {
    settings = {
      solargraph = {
        diagnostics = false -- Rubocop does this better
      }
    },
    init_options = {
      formatting = false -- Rubocop does this better
    }
  },
  tsserver = {},
  lemminx = {},
  tailwindCSS = {
    filetypes = { 'css', 'sass', 'scss', 'tsx' }
  },
  vuels = {},
}

m.table_merge = function(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
end

return m
