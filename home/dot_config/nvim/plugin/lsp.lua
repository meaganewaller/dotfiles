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
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  },
  gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
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

    map("gd", vim.lsp.buf.definition, "LSP: definition")
    map("gD", vim.lsp.buf.declaration, "LSP: declaration")
    map("gr", vim.lsp.buf.references, "LSP: references")
    map("gi", vim.lsp.buf.implementation, "LSP: implementation")
    map("K", vim.lsp.buf.hover, "LSP: hover")
    map("<Space>lr", vim.lsp.buf.rename, "LSP: rename")
    map("<Space>la", vim.lsp.buf.code_action, "LSP: code action")
    map("<Space>lf", function() vim.lsp.buf.format({ async = true }) end, "LSP: format")
    map("<Space>ld", vim.diagnostic.open_float, "LSP: line diagnostics")
    map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "LSP: prev diagnostic")
    map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "LSP: next diagnostic")
  end,
})
