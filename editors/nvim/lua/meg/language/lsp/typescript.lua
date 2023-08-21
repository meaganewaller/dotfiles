local M = {}

function M.setup(_, on_attach)
  require("typescript-tools").setup({
    on_attach = on_attach,
    settings = {
      separate_diagnostic_server = true,
      composite_mode = "separate_diagnostic",
      publish_diagnostic_on = "insert_leave",
      tsserver_logs = "verbose",
      code_lens = "all",
      disable_member_code_lens = true,
    },
  })
end

return M
