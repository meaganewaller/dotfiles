require("silicon").setup({
  font = "FiraCode Nerd Font=34;Noto Emoji",
  theme = "Nord",
  background = "#00000000",
  pad_horiz = 10,
  pad_vert = 10,
  no_round_corner = false,
  no_window_controls = false,
  no_line_numbers = false,
  line_offset = function(args) return args.line1 end,
  output = function()
    return "./" .. os.date("!%Y-%m-%dT%H-%M-%S") . "_code.png"
  end,
  line_pad = 2,
  tab_width = 2,
  language = function() return vim.bo.filetype end,
  shadow_blur_radius = 0,
  gobble = true,
  to_clipboard = true,
  command = "silicon",
})
--local _, _ = pcall(silicon.setup, {
--
--  theme = "Nord",
--  line_number = true,
--  pad_vert = 10,
--  pad_horiz = 10,
--  watermark = {
--    text = " @meaganewaller",
--    color = "#000000",
--    style = "italic",
--  },
--  window_title = function() return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ":~:.") end,
--})
