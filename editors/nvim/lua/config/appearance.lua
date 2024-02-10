local M = {}

M.rose_pine = function()
  require("rose-pine").setup({
    variant = "auto",
    dark_variant = "main",
    bold_vert_split = false,
    groups = {
      border = "highlight_med",
      comment = "muted",
      link = "iris",
      punctuation = "subtle",
      error = "love",
      hint = "iris",
      info = "foam",
      warn = "gold",
      headings = {
        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
      },
    },
    highlight_groups = {
      Boolean = { fg = "love" },
      NormalFloat = { bg = "base" },
      MsgArea = { fg = "text" },
      VertSplit = { fg = "highlight_low", bg = "highlight_low" },
      SignColumn = { fg = "text", bg = "none" },
      SignColumnSB = { fg = "text", bg = "none" },
      mkdInlineURL = { fg = "iris" },
      ["@variable"] = { fg = "text" },
      ["@variable.builtin"] = { fg = "love" },
      ["@type"] = { fg = "foam" },
      ["@text"] = { fg = "text" },
      ["@property"] = { fg = "iris" },
      ["@parameter"] = { fg = "iris" },
      ["@constant.builtin"] = { fg = "love" },
      ["@constant"] = { fg = "foam" },
      ["@constructor"] = { fg = "foam" },
      ["@field"] = { fg = "foam" },
      ["@function.builtin"] = { fg = "love" },
      ["@function"] = { fg = "rose" },
      ["@include"] = { fg = "pine" },
      ["@keyword"] = { fg = "pine" },
      ["@keyword.operator"] = { fg = "subtle" },
      ["@label"] = { fg = "foam" },
      ["@punctuation.bracket"] = { fg = "muted" },
      ["@punctuation.delimiter"] = { fg = "muted" },
      ["@punctuation.special"] = { fg = "muted" },
      ["@string.escape"] = { fg = "pine" },
      ["@string.special"] = { fg = "gold" },
      ["@tag"] = { fg = "foam" },
      ["@tag.delimiter"] = { fg = "subtle" },
      ["@text.title"] = { fg = "iris" },
      ["@text.uri"] = { fg = "iris" },
      CmpItemKindText = { fg = "gold" },
      CmpItemKindConstructor = { fg = "foam" },
      CmpItemKindField = { fg = "foam" },
      CmpItemKindValue = { fg = "text" },
      CmpItemKindEvent = { fg = "text" },
      CmpItemKindUnit = { fg = "gold" },
      CmpItemKindConstant = { fg = "gold" },
      CmpItemKindModule = { fg = "iris" },
      CmpItemKindEnum = { fg = "#c5a8e8" },
      CmpItemKindStruct = { fg = "#56949f" },
      CmpItemKindTypeParameter = { fg = "foam" },
      CmpItemKindTypeKeyword = { fg = "pine" },
      CmpItemKindTypeDirectory = { fg = "foam" },
      CmpItemKindReference = { fg = "gold" },
      CmpItemKindOperator = { fg = "subtle" },
      CmpItemKindTypeSnippet = { fg = "pine" },
      XTFill = { bg = "overlay", fg = "iris" },
      XTNumSel = { bg = "overlay", fg = "base", bold = true },
      XTSelect = { bg = "base", fg = "overlay", bold = true },
      XTNum = { bg = "text", fg = "overlay" },
      XTVisible = { bg = "overlay", fg = "love" },

      GitSignsAdd = { fg = "pine", bg = "base" },
      GitSignsChange = { fg = "rose", bg = "base" },
      GitSignsDelete = { fg = "love", bg = "base" },
      GitSignsUntracked = { link = "GitSignsAdd" },
      GitSignsStagedAdd = { fg = "base", bg = "pine" },
      GitSignsStagedChange = { fg = "base", bg = "rose" },
      GitSignsStagedDelete = { fg = "base", bg = "love" },
    }
  })
end

M.catppuccin = function()
  local catppuccin = require "catppuccin"
  local opts = {
    flavour = "mocha",
    background = { light = "latte", dark = "mocha" },
    transparent_background = false,
    term_colors = false,
    styles = {
      comments = {},
      keywords = { "italic" },
    },
    compile = {
      enabled = true, -- NOTE: make sure to run `:CatppuccinCompile`
      path = vim.fn.stdpath "cache" .. "/catppuccin",
    },
    dim_inactive = {
      enabled = true,
      shade = "dark",
      percentage = 0.15,
    },
    integrations = {
      cmp = true,
      fidget = true,
      lsp_trouble = true,
      telescope = true,
      treesitter = true,
      mason = true,
      neotest = true,
      noice = false,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = {},
          warnings = { "italic" },
          information = {},
        },
        underlines = {
          errors = { "undercurl" },
          hints = {},
          warnings = { "undercurl" },
          information = {},
        },
      },
      dap = {
        enabled = true,
        enable_ui = true,
      },
      indent_blankline = {
        enabled = true,
        colored_indent_levels = false,
      },
      gitsigns = true,
      notify = true,
      nvimtree = true,
      neotree = true,
      overseer = true,
      symbols_outline = true,
      which_key = true,
      leap = true,
      hop = true,
    },
    highlight_overrides = {
      mocha = {
        NormalFloat = { fg = "#CDD6F4", bg = "#151521" },
        CmpItemKindEnum = { fg = "#B4BEFE" },
        CmpItemKindEnumMember = { fg = "#F5C2E7" },
        CmpItemMenu = { fg = "#7F849C" },
        CmpItemAbbr = { fg = "#BAC2DE" },
        Cursor = { fg = "#1e1e2e", bg = "#d9e0ee" },
        ["@constant.builtin"] = { fg = "#EBA0AC" },
        TSConstBuiltin = { fg = "#EBA0AC" },
      },
    },
  }
  catppuccin.setup(opts)
end

M.colors = {
  rose_pine_colors = {
    cmp_border = "#191724",
    none = "NONE",
    bg = "#2a273f",
    fg = "#e0def4",
    fg_gutter = "#3b4261",
    black = "#393b44",
    gray = "#2a2e36",
    red = "#eb6f92",
    green = "#97c374",
    yellow = "#ea9d34",
    hlargs = "#c4a7e7",
    blue = "#9ccfd8",
    magenta = "#c4a7e7",
    cyan = "#9ccfd8",
    white = "#dfdfe0",
    orange = "#ea9a97",
    pink = "#D67AD2",
    black_br = "#7f8c98",
    red_br = "#e06c75",
    green_br = "#58cd8b",
    yellow_br = "#FFE37E",
    bg_br = "#393552",
    blue_br = "#84CEE4",
    violet = "#B8A1E3",
    cyan_br = "#59F0FF",
    white_br = "#FDEBC3",
    orange_br = "#F6A878",
    pink_br = "#DF97DB",
    comment = "#526175",
    bg_alt = "#191724",
    git = {
      add = "#84Cee4",
      change = "#c4a7e7",
      delete = "#eb6f92",
      conflict = "#f6c177",
    },
  },
  catppuccin_colors = {
    cmp_border = "#151521",
    rosewater = "#F5E0DC",
    flamingo = "#F2CDCD",
    violet = "#DDB6F2",
    pink = "#F5C2E7",
    red = "#F28FAD",
    maroon = "#E8A2AF",
    orange = "#FAB387",
    yellow = "#F9E2AF",
    hlargs = "#EBA0AC",
    green = "#ABE9B3",
    blue = "#96CDFB",
    cyan = "#89DCEB",
    teal = "#B5E8E0",
    lavender = "#C9CBFF",
    white = "#D9E0EE",
    gray2 = "#C3BAC6",
    gray1 = "#988BA2",
    gray0 = "#6E6C7E",
    black4 = "#575268",
    bg_br = "#302D41",
    bg = "#302D41",
    surface1 = "#302D41",
    bg_alt = "#1E1E2E",
    fg = "#D9E0EE",
    black = "#1A1826",
    git = {
      add = "#ABE9B3",
      change = "#96CDFB",
      delete = "#F28FAD",
      conflict = "#FAE3B0",
    },
  },
}
M.current_colors = function()
  local colors = M.colors.rose_pine_colors
  -- local _time = os.date "*t"
  -- if _time.hour >= 1 and _time.hour < 9 then
  --   colors = M.colors.rose_pine_colors
  --   -- colors = M.colors.catppuccin_colors
  -- elseif _time.hour >= 9 and _time.hour < 17 then
  --   colors = M.colors.tokyonight_colors
  -- elseif _time.hour >= 17 and _time.hour < 21 then
  --   colors = M.colors.catppuccin_colors
  -- elseif (_time.hour >= 21 and _time.hour < 24) or (_time.hour >= 0 and _time.hour < 1) then
  --   colors = M.colors.kanagawa_colors
  -- end
  return colors
end

M.hi_colors = function()
  local colors = {
    bg = "#16161D",
    bg_alt = "#1F1F28",
    fg = "#DCD7BA",
    green = "#76946A",
    red = "#E46876",
  }
  local color_binds = {
    bg = { group = "NormalFloat", property = "background" },
    bg_alt = { group = "Cursor", property = "foreground" },
    fg = { group = "Cursor", property = "background" },
    green = { group = "diffAdded", property = "foreground" },
    red = { group = "diffRemoved", property = "foreground" },
  }
  local function get_hl_by_name(name)
    local ret = vim.api.nvim_get_hl(name.group)
    return string.format("#%06x", ret[name.property])
  end

  for k, v in pairs(color_binds) do
    local found, color = pcall(get_hl_by_name, v)
    if found then
      colors[k] = color
    end
  end
  return colors
end

M.telescope_theme = function(colorset)
  local function link(group, other)
    vim.cmd("highlight! link " .. group .. " " .. other)
  end

  local function set_bg(group, bg)
    vim.cmd("hi " .. group .. " guibg=" .. bg)
  end

  local function set_fg_bg(group, fg, bg)
    vim.cmd("hi " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
  end

  set_fg_bg("SpecialComment", "#9ca0a4", "bold")
  link("FocusedSymbol", "LspHighlight")
  link("LspCodeLens", "SpecialComment")
  link("LspDiagnosticsSignError", "DiagnosticError")
  link("LspDiagnosticsSignHint", "DiagnosticHint")
  link("LspDiagnosticsSignInfo", "DiagnosticInfo")
  link("NeoTreeDirectoryIcon", "NvimTreeFolderIcon")
  link("IndentBlanklineIndent1 ", "@comment")
  if vim.fn.has "nvim-0.9" == 1 then
    link("@lsp.type.decorator", "@function")
    link("@lsp.type.enum", "@type")
    link("@lsp.type.enumMember", "@constant")
    link("@lsp.type.function", "@function")
    link("@lsp.type.interface", "@interface")
    link("@lsp.type.keyword", "@keyword")
    link("@lsp.type.macro", "@macro")
    link("@lsp.type.method", "@method")
    link("@lsp.type.namespace", "@namespace")
    link("@lsp.type.parameter", "@parameter")
    link("@lsp.type.property", "@property")
    link("@lsp.type.struct", "@structure")
    link("@lsp.type.variable", "@variable")
    link("@lsp.type.class", "@type")
    link("@lsp.type.type", "@type")
    link("@lsp.typemod.function.defaultLibrary", "Special")
    link("@lsp.typemod.variable.defaultLibrary", "@variable.builtin")
    -- link("@lsp.typemod.variable.global", "@constant.builtin")
    link("@lsp.typemod.operator", "@operator")
    link("@lsp.typemod.string", "@string")
    link("@lsp.typemod.variable", "@variable")
    link("@lsp.typemod.parameter.label", "@field")
    link("@type.qualifier", "@keyword")
  end

  -- NOTE: these are my personal preferences
  local current_colors = colorset
  if colorset == nil or #colorset == 0 then
    current_colors = M.current_colors()
  end
  set_fg_bg("Hlargs", current_colors.hlargs, "none")
  set_fg_bg("CmpBorder", current_colors.cmp_border, current_colors.cmp_border)
  link("NoiceCmdlinePopupBorder", "CmpBorder")
  link("NoiceCmdlinePopupBorderCmdline", "CmpBorder")
  link("NoiceCmdlinePopupBorderFilter", "CmpBorder")
  link("NoiceCmdlinePopupBorderHelp", "CmpBorder")
  link("NoiceCmdlinePopupBorderIncRename", "CmpBorder")
  link("NoiceCmdlinePopupBorderInput", "CmpBorder")
  link("NoiceCmdlinePopupBorderLua", "CmpBorder")
  link("NoiceCmdlinePopupBorderSearch", "CmpBorder")
  set_fg_bg("diffAdded", current_colors.git.add, "NONE")
  set_fg_bg("diffRemoved", current_colors.git.delete, "NONE")
  set_fg_bg("diffChanged", current_colors.git.change, "NONE")
  set_fg_bg("WinSeparator", current_colors.bg_alt, current_colors.bg_alt)
  set_fg_bg("SignColumn", current_colors.bg, "NONE")
  set_fg_bg("SignColumnSB", current_colors.bg, "NONE")

  local colors = M.hi_colors()
  -- set_fg_bg("WinSeparator", colors.bg, "None")
  set_fg_bg("NormalFloat", colors.fg, colors.bg)
  set_fg_bg("FloatBorder", colors.fg, colors.bg)
  set_fg_bg("TelescopeBorder", colors.bg_alt, colors.bg)
  set_fg_bg("TelescopePromptBorder", colors.bg, colors.bg)
  set_fg_bg("TelescopePromptNormal", colors.fg, colors.bg_alt)
  set_fg_bg("TelescopePromptPrefix", colors.red, colors.bg)
  set_bg("TelescopeNormal", colors.bg)
  set_fg_bg("TelescopePreviewTitle", colors.bg, colors.green)
  set_fg_bg("TelescopePromptTitle", colors.bg, colors.red)
  set_fg_bg("TelescopeResultsTitle", colors.bg, colors.bg)
  set_fg_bg("TelescopeResultsBorder", colors.bg, colors.bg)
  set_bg("TelescopeSelection", colors.bg_alt)

  set_fg_bg("FzfLuaBorder", colors.bg, colors.bg)
  set_bg("FzfLuaNormal", colors.bg)
  set_fg_bg("FzfLuaTitle", colors.bg, colors.red)
  set_fg_bg("FzfLuaPreviewTitle", colors.bg, colors.green)
  set_fg_bg("FzfLuaPreviewBorder", colors.bg, colors.bg)
  set_fg_bg("FzfLuaScrollBorderEmpty", colors.bg, colors.bg)
  set_fg_bg("FzfLuaScrollBorderFull", colors.bg, colors.bg)
  set_fg_bg("FzfLuaHelpNormal", colors.bg_alt, colors.bg)
end

M.toggle_theme = function()
  local theme = "rose-pine"
  local changeTo = nil
  local colorset = require("config.appearance").colors.rose_pine_colors
  if theme == "rose-pine" then
    changeTo = "catppuccin"
    M.catppuccin()
    colorset = require("config.appearance").colors.catppuccin_colors
  else
    M.rose_pine()
    changeTo = "rose-pine"
  end
  if vim.g.toggle_theme_icon == "   " then
    vim.g.toggle_theme_icon = "   "
  else
    vim.g.toggle_theme_icon = "   "
  end
  vim.cmd("colorscheme " .. changeTo)
  require("config.appearance").telescope_theme(colorset)
end

return M
