local function setup_muren()
  require("muren").setup({
    -- general
    create_commands = true,
    filetype_in_preview = true,
    -- default togglable options
    two_step = false,
    all_on_line = true,
    preview = true,
    -- keymaps
    keys = {
      close = "q",
      toggle_side = "<Tab>",
      toggle_options_focus = "<C-s>",
      toggle_option_under_cursor = "<CR>",
      scroll_preview_up = "<Up>",
      scroll_preview_down = "<Down>",
      do_replace = "<CR>",
    },
    -- ui sizes
    patterns_width = 30,
    patterns_height = 10,
    options_width = 15,
    preview_height = 16,
    -- options order in ui
    order = {
      "buffer",
      "two_step",
      "all_on_line",
      "preview",
    },
    -- highlights used for options ui
    hl = {
      options = {
        on = "@string",
        off = "@variable.builtin",
      },
    },
  })
end
local function setup_antelope()
  local antelope = require("antelope")
  antelope.setup({
    notifications = false,
  })
  local marks = { data = "Z" }
  vim.api.nvim_command("delmarks " .. marks.data)

  local mark_options = {
    filter = function(mark) return mark:match("[a-zA-Z]") end,
    actions = {
      split = "-",
      vertsplit = "/",
      tabsplit = "]",
      delete = "<Space>",
    },
  }

  local buffer_options = {
    handle = "auto", -- 'bufnr' or 'dynamic' or 'auto'
    show_icons = true,
    show_current = false, -- Include current buffer in the list
    show_modified = true, -- Show buffer modified indicator
    modified_icon = "⬤", -- Character to use as modified indicator
    grayout_current = true, -- Wheter to gray out current buffer entry
    force_delete = {}, -- List of filetypes / buftypes to use
    -- 'bdelete!' on, e.g. { 'terminal' }
    filter = nil, -- Function taking bufnr as parameter,
    -- returning true or false
    sort = nil, -- Comparator function (bufnr, bufnr) -> bool
    terminal_char = "\\", -- Character to use for terminal buffer handles
    -- when options.handle is 'dynamic'
    grayout = true, -- Gray out non matching entries

    -- A list of characters to use as handles when options.handle == 'auto'
    auto_handles = require("antelope.buffers.constant").auto_handles,
    auto_exclude_handles = {}, -- A list of characters not to use as handles when
    -- options.handle == 'auto', e.g. { '8', '9', 'j', 'k' }
    previous = {
      enable = true, -- Mark last used buffers with specified chars and colors
      depth = 2, -- Maximum number of buffers to mark
      chars = { "•" }, -- Characters to use as markers,
      -- last one is used when depth > #chars
      groups = { -- Highlight groups for markers,
        "String", -- last one is used when depth > #groups
        "Comment",
      },
    },
    -- A map of action to key that should be used to invoke it
    actions = {
      split = "-",
      vertsplit = "|",
      tabsplit = "]",
      delete = "<Space>",
      priority = "=",
    },
  }

  local tab_options = {
    show_icons = true,
    show_current = false,
    actions = {
      delete = "<Space>",
    },
  }

  antelope.tabpages(tab_options)
  antelope.marks(mark_options)
  antelope.buffers(buffer_options)
end

local function setup_todocomments()
  require("todo-comments").setup({
    signs = true, -- show icons in the signs column
    sign_priority = 8, -- sign priority
    -- keywords recognized as todo comments
    keywords = {
      FIX = {
        icon = " ", -- icon used for the sign, and in search results
        color = "error", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    gui_style = {
      fg = "NONE", -- The gui style to use for the fg highlight group.
      bg = "BOLD", -- The gui style to use for the bg highlight group.
    },
    merge_keywords = true, -- when true, custom keywords will be merged with the defaults
    -- highlighting of the line containing the todo comment
    -- * before: highlights before the keyword (typically comment characters)
    -- * keyword: highlights of the keyword
    -- * after: highlights after the keyword (todo text)
    highlight = {
      multiline = true, -- enable multine todo comments
      multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
      multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
      before = "", -- "fg" or "bg" or empty
      keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
      after = "fg", -- "fg" or "bg" or empty
      pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
      comments_only = true, -- uses treesitter to match keywords in comments only
      max_line_len = 400, -- ignore lines longer than this
      exclude = {}, -- list of file types to exclude highlighting
    },
    -- list of named colors where we try to extract the guifg from the
    -- list of highlight groups or use the hex color if hl not found as a fallback
    colors = {
      error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
      warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
      info = { "DiagnosticInfo", "#2563EB" },
      hint = { "DiagnosticHint", "#10B981" },
      default = { "Identifier", "#7C3AED" },
      test = { "Identifier", "#FF00FF" },
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      -- regex that will be used to match keywords.
      -- don't replace the (KEYWORDS) placeholder
      pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
    },
  })
end

local function setup_nvimtree()
  local keymaps = require("meg.nvim.keymaps")

  local function on_attach(bufnr)
    keymaps.register_with_keymap(
      "n",
      require("meg.mappings").explorer,
      { buffer = bufnr, noremap = true, silent = true, nowait = true }
    )
  end

  require("nvim-tree").setup({
    on_attach = on_attach,
    renderer = {
      indent_markers = {
        enable = true,
      },
    },
    update_focused_file = {
      enable = true,
    },
  })
end

local function setup_oil()
  local mappings = require("meg.mappings")

  require("oil").setup({
    use_default_keymaps = false,
    keymaps = mappings.oil,
  })
end

local function setup_trouble()
  local mappings = require("meg.mappings")

  vim.cmd([[autocmd WinEnter * if winnr('$') == 1 && &ft == 'Trouble' | q | endif]])

  require("trouble").setup({
    action_keys = mappings.diagnostics,
  })
end

local function setup_telescope()
  local actions = require("telescope.actions")
  local mapping = require("meg.mappings")
  require("telescope").setup({
    defaults = {
      extensions = {
        fzy_native = {
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
      mappings = {
        i = mapping.search(actions),
        n = mapping.search(actions),
      },
      layout_strategy = "flex",
    },
  })

  require("telescope").load_extension("dap")
  require("telescope").load_extension("fzy_native")
  require("telescope").load_extension("ui-select")
end

return {
  {
    "Pheon-Dev/antelope",
    event = "BufReadPre",
    config = function() setup_antelope() end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function() setup_nvimtree() end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "stevearc/oil.nvim",
    config = function() setup_oil() end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "folke/trouble.nvim",
    config = function() setup_trouble() end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "folke/todo-comments.nvim",
    config = function() setup_todocomments() end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    config = function() setup_telescope() end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
  },
  {
    "AckslD/muren.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function() setup_muren() end,
  },
  { "nvim-telescope/telescope-fzy-native.nvim", build = "make" },
}
