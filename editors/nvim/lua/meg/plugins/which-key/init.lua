local function setup(which_key, icons, borders)
  which_key.setup({
    plugins = {
      marks = true,
      registers = false,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    key_labels = {
      -- ["<Leader>"] = "<LDR>",
      -- ["<LocalLeader>"] = "<LLDR>",
    },
    icons = {
      breadcrumb = icons.arrow.hollow.r,
      separator = icons.arrow.hollow.r,
      group = icons.key[1] .. " ",
    },
    popup_mappings = {
      scroll_down = "<C-d>",
      scroll_up = "<C-u>",
    },
    window = {
      border = {
        borders.tl,
        borders.t,
        borders.tr,
        borders.r,
        borders.br,
        borders.b,
        borders.bl,
        borders.l,
      }, -- none, single, double, shadow
      position = "bottom", -- bottom, top
      margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
      padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      winblend = mw.ui.window.transparency,
    },
    layout = {
      height = { min = 5, max = 25 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 4, -- spacing between columns
      align = "center", -- align columns left, center or right
    },
    ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = false, -- show help message on the command line when the popup is visible
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>", "<localleader>"}, -- or specify a list manually
    triggers_blacklist = {
      -- list of mode / prefixes that should never be hooked by WhichKey
      -- this is mostly relevant for key maps that start with a native binding
      -- most people should not need to change this
      n = { ";", "y" },
      i = { "j", "k", "<lt>" },
      v = { "j", "k" },
    },
  })

  -- require("meg.plugins.which-key.utils").register_mappings(which_key, mw.mappings)
end

local loaded, which_key = pcall(require, "which-key")
if not loaded then
  mw.loading_error_msg("which-key.nvim")
  return
end

local icons = mw.ui.icons
local borders = mw.ui.borders.default
setup(which_key, icons, borders)

which_key.register({
  ["/"] = { name = "Search" },
  [","] = { name = "Config" },
  ["`"] = { name = "Terminal", ["`"] = "Toggle" },
  b = { name = "+ Buffers" },
  d = { name = "+ Diagnostics" },
  f = { name = "+ File" },
  g = {
    name = "+ Git",
    y = "Link",
    G = { name = "Gist" },
  },
  c = { name = "+ TODO Comments" },
  h = { name = "+ History" },
  l = { name = "+ LSP" },
  m = { name = "+ Bookmarks" },
  R = { name = "+ SnipRun" },
  s = { name = "+ Sessions" },
  t = { name = "+ Toggle", d = { name = "Diagnostics" } },
  T = { name = "Treesitter" },
}, { prefix = "<Leader>" })

which_key.register({
  d = "Delete fold at cursor",
  D = "Delete fold at cursor recursively",
  E = "Eliminate all folds in window",
  ["%"] = "which_key_ignore",
}, { prefix = "z" })

which_key.register({
  ["/"] = { name = "Search Marks" },
  h = { name = "Harpoon" },
  x = { name = "Delete Marks" },
  ["0"] = "which_key_ignore",
}, { prefix = "m" })

which_key.register({
	["<C-/>"] = "which_key_ignore",
	["<C-_>"] = "which_key_ignore",
	["`"] = "which_key_ignore",
	j = "which_key_ignore",
	k = "which_key_ignore",
	g = { name = "Git" },
	R = { name = "SnipRun" },
}, { prefix = "<leader>", mode = "v" })

which_key.register({
  ["t"] = "+ Neotest",
}, { prefix = "<LocalLeader>" })

which_key.register({
	t = { name = "Tabs" },
}, { prefix = "<C-w>" })

which_key.register({
	c = "which_key_ignore",
	b = "which_key_ignore",
}, { prefix = "g", mode = { "n", "v" } })
