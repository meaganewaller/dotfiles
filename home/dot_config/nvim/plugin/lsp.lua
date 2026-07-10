-- Native LSP using vim.lsp.config + vim.lsp.enable (nvim 0.11+). Servers are
-- hand-configured here instead of depending on nvim-lspconfig, and must
-- already be on PATH -- install via mise, never Mason or an ad-hoc script.
vim.pack.add({
  { src = "https://github.com/b0o/schemastore.nvim" },
})

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
        analyses = { unusedparams = true },
        staticcheck = true,
      },
    },
  },
  clangd = {
    cmd = { "clangd", "--background-index", "--clang-tidy" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" },
  },
  jsonls = {
    cmd = { "vscode-json-languageserver", "--stdio" },
    filetypes = { "json", "jsonc" },
    init_options = { provideFormatter = true },
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
  yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
    root_markers = { ".git" },
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = { format = { enable = true }, schemas = require("schemastore").yaml.schemas() },
    },
  },
  bashls = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "bash", "sh" },
    root_markers = { ".git" },
  },
  fish_lsp = {
    cmd = { "fish-lsp", "start" },
    filetypes = { "fish" },
    root_markers = { "config.fish", ".git" },
  },
  tailwindcss = {
    cmd = { "tailwindcss-language-server", "--stdio" },
    filetypes = {
      "html",
      "css",
      "scss",
      "less",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
    },
    root_markers = {
      "tailwind.config.js",
      "tailwind.config.cjs",
      "tailwind.config.mjs",
      "tailwind.config.ts",
      "postcss.config.js",
      ".git",
    },
  },
  marksman = {
    cmd = { "marksman", "server" },
    filetypes = { "markdown", "markdown.mdx" },
    root_markers = { ".marksman.toml", ".git" },
  },
  tombi = {
    cmd = { "tombi", "lsp" },
    filetypes = { "toml" },
    root_markers = { "tombi.toml", "pyproject.toml", ".git" },
  },
  terraformls = {
    cmd = { "terraform-ls", "serve" },
    filetypes = { "terraform", "terraform-vars" },
    root_markers = { ".terraform", ".git" },
  },
  texlab = {
    cmd = { "texlab" },
    filetypes = { "tex", "plaintex", "bib" },
    root_markers = { ".git", ".latexmkrc", "latexmkrc", ".texlabroot" },
  },
  dockerls = {
    cmd = { "docker-language-server", "start", "--stdio" },
    filetypes = { "dockerfile" },
    root_markers = { "Dockerfile", ".git" },
  },
  sqls = {
    cmd = { "sqls" },
    filetypes = { "sql", "mysql" },
    root_markers = { ".git" },
  },
  harper_ls = {
    cmd = { "harper-ls", "--stdio" },
    filetypes = { "markdown", "gitcommit", "lua", "python", "ruby", "go", "rust", "javascript", "typescript", "toml" },
    root_markers = { ".git" },
  },
  biome = {
    cmd = { "biome", "lsp-proxy" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc", "css" },
    root_markers = { "biome.json", "biome.jsonc", "package.json", ".git" },
  },
  ruff = {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  },
  ty = {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
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

-- Buffer-local bindings when a server attaches. `gd`/`gD` fill the one real
-- gap in Neovim's built-in LSP defaults (:h lsp-defaults already covers
-- rename/references/code action/hover/signature-help globally).
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
  callback = function(args)
    local buf = args.buf
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
    end

    map("gd", vim.lsp.buf.definition, "LSP: definition")
    map("gD", vim.lsp.buf.declaration, "LSP: declaration")
    map("<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, "LSP: format")
    map("<leader>lq", vim.diagnostic.setloclist, "LSP: diagnostics to loclist")
  end,
})
