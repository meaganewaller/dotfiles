require("treesitter-context").setup({
  enable = true,
  max_lines = 0,
  line_numbers = true,
  multiline_threshold = 20,
  trim_scope = "outer",
  mode = "cursor",
  zindex = 30,
})
