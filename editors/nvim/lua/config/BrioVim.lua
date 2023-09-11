local icons = require('utils.icons')

BrioVim = {
  theme = {
    name = "hardhacker",
    style = "darker",
    transparent = false,
  },
  ui = {
    float = {
      border = "rounded",
    },
  },
  plugins = {
    ai = {
      chatgpt = {
        enabled = true,
      },
      codeium = {
        enabled = false,
      },
      copilot = {
        enabled = true,
      },
      tabnine = {
        enabled = false,
      },
    },
    completion = {
      select_first_on_enter = false,
    },
    experimental_noice = {
      enabled = true,
    },
    jump_by_subwords = {
      enabled = false,
    },
    rooter = {
      patterns = { ".git", "package.json", ".svn", "Makefile" },
    },
    zen = {
      alacritty_enabled = false,
      kitty_enabled = true,
      wezterm_enabled = false,
      enabled = true,
    },
  },
  icons = icons,
  statusline = {
    path_enabled = false,
    path = "relative",
  },
  lsp = {
    virtual_text = true,
  },
}
