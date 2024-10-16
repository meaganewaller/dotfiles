return {
    "akinsho/bufferline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local bufferline = require("bufferline")
        bufferline.setup {
            options = {
                mode = "buffers",
                themable = true,
                numbers = "buffer_id",
                indicator = {
                    icon = "▌",
                    style = "icon",
                },
                show_buffer_close_icons = false,
                show_close_icon = false,
                diagnostics = "nvim_lsp",
            }
        }
        local keymaps = {
            { from = "td",         to = ":bd<CR>" },
            { from = "tl",         to = ":bn<CR>" },
            { from = "th",         to = ":bp<CR>" },
            { from = "<leader>1",  to = function() bufferline.go_to(1) end },
            { from = "<leader>2",  to = function() bufferline.go_to(2) end },
            { from = "<leader>3",  to = function() bufferline.go_to(3) end },
            { from = "<leader>4",  to = function() bufferline.go_to(4) end },
            { from = "<leader>5",  to = function() bufferline.go_to(5) end },
            { from = "<leader>6",  to = function() bufferline.go_to(6) end },
            { from = "<leader>7",  to = function() bufferline.go_to(7) end },
            { from = "<leader>8",  to = function() bufferline.go_to(8) end },
            { from = "<leader>9",  to = function() bufferline.go_to(9) end },
            { from = "<leader>0",  to = function() bufferline.go_to(-1) end },
        }
        for _, item in ipairs(keymaps) do
            vim.keymap.set("n", item.from, item.to, { noremap = true })
        end
    end
}
