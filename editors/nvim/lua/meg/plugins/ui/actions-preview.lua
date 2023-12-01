return {
  "aznhe21/actions-preview.nvim",
  event = "VeryLazy",
  config = function()
    require("actions-preview").setup {}

    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "Setup code action preview",
      callback = function(args)
        local bufnr = args.buf
        local map = require("meg.utils").map

        map("n", "<Leader>la", function()
          require('actions-preview').code_actions()
        end, "LSP: Code action")
      end,
    })
  end,
}
