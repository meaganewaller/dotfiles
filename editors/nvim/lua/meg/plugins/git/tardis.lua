return {
  "fredeeb/tardis.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    keymap = {
      ["next"] = "<C-j>",
      ["prev"] = "<C-k>",
      ["quit"] = "q",
      ['revision_message'] = 'm',
    },
    initial_revisions = 10,
    max_revisions = 256,
  },
}
