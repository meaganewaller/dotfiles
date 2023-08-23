local M = {}
function M.setup(_, _)
  require("lspconfig").tailwindcss.setup({
    on_attach = function(client, bufnr)
      require("tailwind-highlight").setup(client, bufnr, {
        single_column = false,
        mode = "background",
        debounce = 200,
      })
    end,
  })
end

return M
