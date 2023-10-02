local options = require("nvim.options")
local option = options.scope.option

local M = {
  themes = {
    catppuccin = {
      style = { "latte", "frappe", "macchiato", "mocha" },
      transparent = false,
      activate = function(style, transparent)
        require("catppuccin").setup({
          flavour = style,
          transparent_background = transparent,
          custom_highlights = function(colors)
            return {
              ColorColumn = { bg = colors.pink },
              -- Blend colours against the "base" background
              CursorLine = { bg = colors.sapphire, blend = 10 },
              StatusLine = { fg = colors.flamingo, bg = colors.flamingo, blend = 10 },

              FloatBorder = { fg = colors.surface0, bg = colors.surface0 },
              NormalFloat = { bg = colors.surface0 },
              FloatTitle = { bg = colors.surface0 },

              TelescopeTitle = { fg = colors.teal, bold = true },
              TelescopePromptNormal = { bg = colors.surface0 },
              TelescopePromptBorder = { fg = colors.surface0, bg = colors.surface0 },
              TelescopeResultsNormal = { fg = colors.text, bg = colors.mantle },
              TelescopeResultsBorder = { fg = colors.mantle, bg = colors.mantle },
              TelescopePreviewNormal = { fg = colors.text, bg = colors.crust },
              TelescopePreviewBorder = { fg = colors.crust, bg = colors.crust },

              NoiceCmdLinePrompt = { fg = colors.sapphire, bold = true },
              NoiceCmdlinePopup = { fg = colors.sapphire, bg = colors.surface0 },
              NoiceCmdlinePopupBorder = { fg = colors.surface0, bg = colors.surface0 },
            }
          end,
        })

        vim.cmd.colorscheme("catppuccin")
      end,
    },
    hardhacker = {
      style = { "dark", "darker" },
      transparent = false,
      activate = function(style, _)
        vim.g.hardhacker_hide_tilde = 1
        vim.g.hardhacker_keyword_italic = 1
        if style == "darker" then
          vim.g.hardhacker_darker = 1
        else
          vim.g.hardhacker_darker = 0
        end

        vim.g.hardhacker_custom_highlights = {
          vim.cmd("hi! link TelescopeMatching HardHacker_Blue"),
          vim.cmd("hi! link TelescopeNormal HardHacker_Selection"),
          vim.cmd("hi! link TelescopePreviewBorder HardHacker_BG_Darker"),
          vim.cmd("hi! link TelescopePromptBorder HardHacker_Selection"),
          vim.cmd("hi! link TelescopePromptNormal HardHacker_FG"),
          vim.cmd("hi! link TelescopePromptPrefix HardHacker_FG"),
          vim.cmd("hi! link TelescopePromptTitle HardHacker_FG"),
          vim.cmd("hi! link TelescopeResultsBorder HardHacker_FG"),
          vim.cmd("hi! link TelescopeResultsNormal HardHacker_Purple"),
          vim.cmd("hi! link TelescopeResultsTitle HardHacker_Cyan"),
          vim.cmd("hi! link TelescopeSelection HardHacker_Green"),
          vim.cmd("hi! link TelescopeSelectionCaret HardHacker_Purple"),
        }

        vim.cmd.colorscheme("hardhacker")
      end,
    },
    nightfox = {
      style = { "nightfox", "dayfox", "dawnfox", "duskfox", "nordfox", "terafox", "carbonfox" },
      transparent = false,
      activate = function(style, transparent)
        require("nightfox").setup({
          options = {
            transparent = transparent,
            terminal_colors = true,
            dim_inactive = false,
          },
          groups = {
            all = {
              ColorColumn = { bg = "palette.bg1" },
              -- Blend colours against the "base" background
              CursorLine = { bg = "bg2" },
              StatusLine = { fg = "pink", bg = "pink", blend = "10" },
              normalfloat = { bg = "bg2" },
              FloatBorder = { fg = "palette.bg2", bg = "palette.bg2" },
              FloatTitle = { bg = "palette.bg2" },
              TelescopeTitle = { fg = "pink", bold = "true" },
              TelescopePromptNormal = { bg = "bg2" },
              TelescopePromptBorder = { fg = "bg2", bg = "bg2" },
              TelescopeResultsNormal = { fg = "white", bg = "bg0" },
              TelescopeResultsBorder = { fg = "bg0", bg = "bg0" },
              TelescopePreviewNormal = { fg = "white", bg = "bg3" },
              TelescopePreviewBorder = { fg = "bg3", bg = "bg3" },
              NoiceCmdLinePrompt = { fg = "orange", bold = "true" },
              NoiceCmdlinePopup = { fg = "palette.magenta", bg = "palette.bg2" },
              NoiceCmdlinePopupBorder = { fg = "palette.bg2", bg = "palette.bg2" },
              NoiceMini = { fg = "orange", bg = "bg2" },
              DiagnosticNormal = { bg = "bg2", fg = "bg2" },
            },
          },
        })

        vim.cmd.colorscheme(style)
      end,
    },
    rosepine = {
      style = { "auto", "main", "moon", "dawn" },
      transparent = false,
      activate = function(style, transparent)
        require("rose-pine").setup({
          variant = style,
          dark_variant = "moon",
          bold_vert_split = false,
          dim_nc_background = false,
          disable_background = false,
          disable_float_background = false,
          disable_italics = false,
          --- @usage string hex value or named color from rosepinetheme.com/palette
          groups = {
            background = "base",
            background_nc = "_experimental_nc",
            panel = "surface",
            panel_nc = "base",
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

          -- Change specific vim highlight groups
          -- https://github.com/rose-pine/neovim/wiki/Recipes
          highlight_groups = {
            ColorColumn = { bg = "rose" },

            -- Blend colours against the "base" background
            CursorLine = { bg = "foam", blend = 10 },
            StatusLine = { fg = "love", bg = "love", blend = 10 },

            FloatBorder = { fg = "surface", bg = "surface" },
            NormalFloat = { bg = "surface" },
            FloatTitle = { bg = "surface" },

            TelescopeTitle = { fg = "love", bold = true },
            TelescopePromptNormal = { bg = "surface" },
            TelescopePromptBorder = { fg = "surface", bg = "surface" },
            TelescopeResultsNormal = { fg = "text", bg = "nc" },
            TelescopeResultsBorder = { fg = "nc", bg = "nc" },
            TelescopePreviewNormal = { fg = "text", bg = "overlay" },
            TelescopePreviewBorder = { fg = "overlay", bg = "overlay" },

            NoiceCmdLinePrompt = { fg = "foam", bold = true },
            NoiceCmdlinePopup = { fg = "iris", bg = "nc" },
            NoiceCmdlinePopupBorder = { fg = "nc", bg = "nc" },

            -- -- TitleString = { fg = "rose", bg = "surface" },
            -- -- TitleIcon = { fg = "surface", bg = "surface" },
            -- DiagnosticBorder = { fg = "surface", bg = "surface" },
            -- DiagnosticNormal = { bg = "surface" },
            -- DiagnosticShowNormal = { fg = "surface", bg = "surface" },
            -- DiagnosticShowBorder = { bg = "surface" },
          },
        })

        vim.cmd("colorscheme rose-pine")
      end
    },
    tokyonight = {
      style = { "storm", "moon", "night", "day" },
      transparent = false,
      activate = function(style, transparent)
        require("tokyonight").setup({
          style = style,
          light_style = "day",
          transparent = transparent,
          terminal_colors = true,
          styles = {
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
            sidebars = "dark",
            floats = "dark",
          },
          sidebars = { "qf", "help" },
          day_brightness = 0.3,
          hide_inactive_statusline = false,
          dim_inactive = false,
          lualine_bold = false,
        })

        vim.cmd.colorscheme("tokyonight")
      end,
    },

  },
}

function M.activate_theme(theme, style, transparent)
  local entry = M.themes[theme]
  entry.activate(style, transparent)

  if transparent then
    options.set(option, "cursorline", false)
  else
    options.set(option, "cursorline", true)
  end
end

return M
