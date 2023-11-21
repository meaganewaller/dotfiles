local typescript = require("typescript-tools")
local opts = {
  root_dir = function(fname)
    local util = require("lspconfig.util")
    if not string.match(fname, ".tsx?$") and util.root_pattern(".flowconfig")(fname) then return nil end
    local ts_root = util.root_pattern("tsconfig.json")(fname)
      or util.root_pattern("package.json", "jsconfig.json", ".git")(fname)
    if ts_root then return ts_root end
    if vim.g.started_by_firenvim then return util.path.dirname(fname) end
    return nil
  end,
  settings = {
    separate_diagnostic_server = false,
    tsserver_max_memory = 8 * 1024,
  },
}

typescript.setup(opts)
