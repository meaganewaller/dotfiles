local oil = require("oil")

local config = {
  default_file_explorer = false,
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, bufnr)
      return vim.startswith(name, '.DS_Store')
    end,
  },
  float = {
    padding = 4
  },
}

oil.setup(config)

nx.map({
  { "-", require('oil').open_float, desc = 'Open parent directory' }
})
