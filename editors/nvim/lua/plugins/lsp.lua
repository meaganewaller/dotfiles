local lspconfig = {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lspconfig = require("lspconfig")
        -- language server config
        require("lsp.lua").setup(lspconfig)
        require("lsp.clangd").setup(lspconfig)
        require("lsp.shell").setup(lspconfig)
        require("lsp.python").setup(lspconfig)
        require("lsp.json").setup(lspconfig)
        require("lsp.cmake").setup(lspconfig)
        require("lsp.html").setup(lspconfig)
        require("lsp.css").setup(lspconfig)
        require("lsp.js").setup(lspconfig)
        require("lsp.meson").setup(lspconfig)
        -- mapping
        vim.keymap.set("n", "g[", vim.diagnostic.goto_prev)
        vim.keymap.set("n", "g]", vim.diagnostic.goto_next)
    end
}

local lspsaga = {
    "nvimdev/lspsaga.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("lspsaga").setup({
            definition = {
                keys = {
                    edit = { "o", "O", "<CR>" },
                    quit = { "q", "Q", "<ESC>" },
                    vsplit = { "sj" },
                    split = { "sl" },
                }
            },
            finder = {
                max_height = 0.6,
                keys = {
                    toggle_or_open = { "o", "O", "<CR>" },
                    quit = { "q", "Q", "<ESC>" },
                    vsplit = { "sj" },
                    split = { "sl" },
                }
            },
            rename = {
                keys = {
                    quit = { "<ESC>" },
                }
            },
            diagnostic = {
                diagnostic_only_current = true,
            },
        })
        vim.diagnostic.config({
            virtual_text = false
        })
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'gd', "<cmd>Lspsaga peek_definition<CR>", opts)
                vim.keymap.set('n', 'gi', "<cmd>Lspsaga finder imp<CR>", opts)
                vim.keymap.set('n', 'gr', "<cmd>Lspsaga finder ref+imp<CR>", opts)
                vim.keymap.set('n', 'K', "<cmd>Lspsaga hover_doc<CR>", opts)
                -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                -- vim.keymap.set('n', '<space>wl', function()
                --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                -- end, opts)
                -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', '<space>rn', "<cmd>Lspsaga rename<CR>", opts)
                -- vim.keymap.set({ 'n', 'v' }, '<space>ca', "<cmd>Lspsaga code_action<CR>", opts)
                -- vim.keymap.set('n', '<space>t', function()
                --     vim.lsp.buf.format { async = true }
                -- end, opts)
                if ("clangd" == vim.lsp.get_client_by_id(ev.data.client_id).name)
                then
                    vim.keymap.set("n", "gh", "<cmd>ClangdSwitchSourceHeader<CR>")
                end
            end,
        })
    end,
}

return {
    lspconfig,
    lspsaga,
}
