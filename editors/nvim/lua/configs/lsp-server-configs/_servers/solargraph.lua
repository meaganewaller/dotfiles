local function solargraph_cmd()
  local ret_code = nil
  local jid = vim.fn.jobstart("grep -rl solargraph --include Gemfile --include Gemfile.lock --include *.gemspec .", {
    on_exit = function(_, data) ret_code = data end,
  })
  vim.fn.jobwait({ jid }, 5000)
  if ret_code == 0 then return { "bundle", "exec", "solargraph", "stdio" } end
  return { "solargraph", "stdio" }
end

return {
  cmd = solargraph_cmd(),
  filetypes = { "ruby", "rakefile" },
  init_options = {
    formatting = false,
  },
  root_dir = require("lspconfig/util").root_pattern("Gemfile", ".git"),
  settings = {
    solargraph = {
      completion = true,
      hover = true,
      symbols = true,
      definitions = true,
      rename = true,
      references = true,
      autoformat = false,
      diagnostics = true,
      formatting = false,
      folding = true,
      highlights = true,
      logLevel = 'warn'
    },
  },
}
