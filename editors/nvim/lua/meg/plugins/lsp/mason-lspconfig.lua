return {
  "williamboman/mason-lspconfig.nvim",
  config = function()
    require("mason-lspconfig").setup({
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, {
          "awk_ls",
          "bashls",
          "html",
          "jsonls",
          "marksman",
          "tsserver",
          "yamlls",
          "pyright",
          "clangd",
          "omnisharp",
          "rust_analyzer",
          "lua_ls",
          "vimls",
        })
        vim.list_extend(opts.automatic_installation, true)
      end,
    })

    local opts = {
      on_attach = require("meg.lsp.handlers").on_attach,
      capabilities = require("meg.lsp.handlers").capabilities,
    }

    require("mason-lspconfig").setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup(opts)
      end,

      ["jdtls"] = function()
      end,

      ["rust_analyzer"] = function()
        local rust_opts = require("meg.lsp.servers.rust")
        require("rust-tools").setup(rust_opts)
      end,

      ["vtsls"] = function()
        local extra_opts = {
          on_attach = {
            client = {
              server_capabilities = {
                documentFormattingProvider = false
              }
            }
          }
        }
        local tsserver_opts_ext = vim.tbl_deep_extend("force", extra_opts, opts)
        require("lspconfig").vtsls.setup(tsserver_opts_ext)
      end,

      ["clangd"] = function()
        local clangd_opts = require("meg.lsp.servers.clangd")
        local clangd_opts_ext = vim.tbl_deep_extend("force", clangd_opts, opts)
        require("lspconfig").clangd.setup(clangd_opts_ext)
      end,

      ["jsonls"] = function()
        local jsonls_opts = require("meg.lsp.servers.jsonls")
        local jsonls_opts_ext = vim.tbl_deep_extend("force", jsonls_opts, opts)
        require("lspconfig").jsonls.setup(jsonls_opts_ext)
      end,

      ["omnisharp"] = function()
        local omnisharp_opts = require("meg.lsp.servers.omnisharp")
        local omnisharp_opts_ext = vim.tbl_deep_extend("force", omnisharp_opts, opts)
        require("lspconfig").omnisharp.setup(omnisharp_opts_ext)
      end,

      ["lua_ls"] = function()
        local lua_ls_opts = require("meg.lsp.servers.lua_ls")
        local lua_ls_opts_ext = vim.tbl_deep_extend("force", lua_ls_opts, opts)
        require("lspconfig").lua_ls.setup(lua_ls_opts_ext)
      end,

      ["bashls"] = function()
        local bash_opts = require("meg.lsp.servers.bash")
        local bash_opts_ext = vim.tbl_deep_extend("force", bash_opts, opts)
        require("lspconfig").bashls.setup(bash_opts_ext)
      end,

      ["perlnavigator"] = function()
        local perlnavigator_opts = require("meg.lsp.servers.perl")
        local perlnavigator_opts_ext = vim.tbl_deep_extend("force", perlnavigator_opts, opts)
        require("lspconfig").perlnavigator.setup(perlnavigator_opts_ext)
      end,

      ["pyright"] = function()
        local pyright_opts = require("meg.lsp.servers.pyright")
        local pyright_opts_ext = vim.tbl_deep_extend("force", pyright_opts, opts)
        require("lspconfig").pyright.setup(pyright_opts_ext)
      end,
    })
  end
}
