return {
  {
    "windwp/nvim-spectre",
    keys = {
      { "<Leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },
}
