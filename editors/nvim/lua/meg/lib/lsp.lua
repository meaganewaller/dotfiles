local M = {}

local augroup_lsp_attach = vim.api.nvim_create_augroup('meg_lsp_attach', {})
---@param on_attach fun(client:lsp.Client, buffer:integer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd('LspAttach', {
    group = augroup_lsp_attach,
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

return M
