local gopher = require("gopher")
local mason = require("meg.lsp.mason")

mason.ensure_tools({
  { name = "gomodifytags" },
  { name = "impl" },
  { name = "iferr" },
})

gopher.setup({
  commands = {
    gomodifytags = mason.get_path("gomodifytags"),
    impl = mason.get_path("impl"),
    iferr  = mason.get_path("iferr"),
  }
})

nx.map("n", "<LocalLeader>ie", ":GoIfErr<CR>", desc = "GoIfErr")
nx.map("n", "<LocalLeader>ii", ":GoImpl ", desc = "GoImpl" )
nx.map("n", "<LocalLeader>ta", ":GoTagAdd ", desc = "Add Go Tag")
