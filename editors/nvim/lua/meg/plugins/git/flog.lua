return {
  "rbong/vim-flog",
  event = "VeryLazy",
  dependencies = {
    "tpope/vim-fugitive",
  },
  cmd = {
    "Flog",
    "G",
    "GBrowse",
    "GDelete",
    "GMove",
    "GRemove",
    "GRename",
    "GUnlink",
    "Gcd",
    "Gclog",
    "Gdiffsplit",
    "Gdrop",
    "Ggrep",
    "Ghdiffsplit",
    "Git",
    "Glcd",
    "Glgrep",
    "Gllog",
    "Gpedit",
    "Gred",
    "Gsplit",
    "Gtabedit",
    "Gvdiffsplit",
    "Gvsplit",
    "Gwq",
    "Gwrite",
  },
  init = function()
    local map = require("meg.utils").map

    map("n", "<Leader>gs", "<cmd>G<CR>", "Git status")
    map("n", "<Leader>gw", "<cmd>Gwrite<CR>", "Git write")
    map("n", "<Leader>gd", "<cmd>Gdiffsplit<CR>", "Git diff split")
  end
}
