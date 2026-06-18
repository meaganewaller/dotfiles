-- Native LSP using vim.lsp.config + vim.lsp.enable (nvim 0.11+).
-- Servers must already be on PATH; install via mise / system package
-- manager instead of bundling an LSP installer plugin.

local servers = {
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", ".git" },
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
        },
        telemetry = { enable = false },
        diagnostics = { globals = { "vim" } },
      },
    },
  },
  rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  },
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  },
  gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.mod", "go.work", ".git" },
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  },
  jsonls = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { ".git" },
    on_attach = function(client, _)
      client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      })
      client.notify("workspace/didChangeConfiguration", { settings = client.settings })
    end,
  },
  elixirls = {
    cmd = { "elixir-ls" },
    filetypes = { "elixir", "eelixir", "heex", "surface" },
    root_markers = { "mix.exs", ".git" },
  },
  solargraph = {
    cmd = { vim.fn.expand("~/.local/share/mise/shims/solargraph"), "stdio" },
    filetypes = { "ruby" },
    root_markers = { "Gemfile", ".git" },
    settings = {
      solargraph = {
        diagnostics = true,
        completion = true,
        formatting = true,
      },
    },
  },
  pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "openFilesOnly",
        },
      },
    },
  },
  clangd = {
    cmd = { "clangd", "--background-index", "--clang-tidy" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" },
  },
}

for name, cfg in pairs(servers) do
  if vim.fn.executable(cfg.cmd[1]) == 1 then
    vim.lsp.config(name, cfg)
    vim.lsp.enable(name)
  end
end

-- Diagnostic presentation.
vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" },
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  float = { border = "rounded", source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN] = "▲",
      [vim.diagnostic.severity.INFO] = "»",
      [vim.diagnostic.severity.HINT] = "•",
    },
  },
})

-- Buffer-local bindings when a server attaches.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
  callback = function(args)
    local buf = args.buf
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
    end

    local opts = { buffer = buf }

    -- Navigation
    map("gd", vim.lsp.buf.definition, "LSP: definition")
    map("gD", vim.lsp.buf.declaration, "LSP: declaration")
    map("gi", vim.lsp.buf.implementation, "LSP: implementation")
    map("gr", vim.lsp.buf.references, "LSP: references")
    map("gy", vim.lsp.buf.type_definition, "LSP: type definition")

    -- Hover and signature
    map("K", vim.lsp.buf.hover, "LSP: hover")
    vim.keymap.set(
      "i",
      "<C-k>",
      vim.lsp.buf.signature_help,
      vim.tbl_extend("force", opts, { desc = "LSP: signature help" })
    )

    -- Actions
    map("<Leader>lr", vim.lsp.buf.rename, "LSP: rename symbol")
    vim.keymap.set(
      { "n", "v" },
      "<leader>la",
      vim.lsp.buf.code_action,
      vim.tbl_extend("force", opts, { desc = "LSP: code action" })
    )
    map("<Leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, "LSP: format")

    -- Diagnostics
    map("<leader>ld", vim.diagnostic.open_float, "LSP: line diagnostics")
    map("[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "LSP: prev diagnostic")
    map("]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "LSP: next diagnostic")
    map("<leader>lq", vim.diagnostic.setloclist, "LSP: diagnostics to loclist")

    -- Workspace
    map("<leader>lwa", vim.lsp.buf.add_workspace_folder, "LSP: add workspace folder")
    map("<leader>lwr", vim.lsp.buf.remove_workspace_folder, "LSP: remove workspace folder")
    map("<leader>lwl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "LSP: list workspace folders")
  end,
})
