return
  {
    {"tpope/vim-fugitive",
  lazy = true,
  cmd = { "Git", "G" },
},

    {
      "ibhagwan/smartyank.nvim",
  lazy = true,
  event = "BufReadPost",
  config = function()
    require("smartyank").setup({
      highlight = {
        enabled = false, -- highlight yanked text
        higroup = "IncSearch", -- highlight group of yanked text
        timeout = 2000, -- timeout for clearing the highlight
      },
      clipboard = {
        enabled = true,
      },
      tmux = {
        enabled = true,
        -- remove `-w` to disable copy to host client's clipboard
        cmd = { "tmux", "set-buffer", "-w" },
      },
      osc52 = {
        enabled = true,
        escseq = "tmux", -- use tmux escape sequence, only enable if you're using remote tmux and have issues (see #4)
        ssh_only = true, -- false to OSC52 yank also in local sessions
        silent = false, -- true to disable the "n chars copied" echo
        echo_hl = "Directory", -- highlight group of the OSC52 echo message
      },
    })
  end,
},
    {"michaelb/sniprun",
  lazy = true,
  -- You need to cd to `~/.local/share/nvim/site/lazy/sniprun/` and execute `bash ./install.sh`,
  -- if you encountered error about no executable sniprun found.
  build = "bash ./install.sh",
  cmd = { "SnipRun" },
  config = function()
    require("sniprun").setup({
      selected_interpreters = {}, -- " use those instead of the default for the current filetype
      repl_enable = {}, -- " enable REPL-like behavior for the given interpreters
      repl_disable = {}, -- " disable REPL-like behavior for the given interpreters
      interpreter_options = {}, -- " intepreter-specific options, consult docs / :SnipInfo <name>
      -- " you can combo different display modes as desired
      display = {
        "TempFloatingWindowOk", -- display ok results in the floating window
        "NvimNotifyErr", -- display err results with the nvim-notify plugin
        -- "Classic", -- display results in the command line"
        -- "VirtualText", -- display results in virtual text"
        -- "LongTempFloatingWindow", -- display results in the long floating window
        -- "Terminal" -- display results in a vertical split
        -- "TerminalWithCode" -- display results and code history in a vertical split
      },
      display_options = {
        terminal_width = 45,
        notification_timeout = 5000,
      },
      -- " miscellaneous compatibility/adjustement settings
      inline_messages = 0, -- " inline_message (0/1) is a one-line way to display messages
      -- " to workaround sniprun not being able to display anything
      borders = "single", -- " display borders around floating windows
      -- " possible values are 'none', 'single', 'double', or 'shadow'
    })
  end,
},
      {"akinsho/toggleterm.nvim",
  lazy = true,
  cmd = {
    "ToggleTerm",
    "ToggleTermSetName",
    "ToggleTermToggleAll",
    "ToggleTermSendVisualLines",
    "ToggleTermSendCurrentLine",
    "ToggleTermSendVisualSelection",
  },
  config = function()
    local colors = require("meg.utils.plugins").get_palette()
    local floatborder_hl = require("meg.utils.plugins").hl_to_rgb("FloatBorder", false, colors.blue)

    require("toggleterm").setup({
      -- size can be a number or function which is passed the current terminal
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.40
        end
      end,
      on_open = function()
        -- Prevent infinite calls from freezing neovim.
        -- Only set these options specific to this terminal buffer.
        vim.api.nvim_set_option_value("foldmethod", "manual", { scope = "local" })
        vim.api.nvim_set_option_value("foldexpr", "0", { scope = "local" })
      end,
      highlights = {
        FloatBorder = {
          guifg = floatborder_hl,
        },
      },
      open_mapping = false, -- [[<c-\>]],
      hide_numbers = true, -- hide the number column in toggleterm buffers
      shade_filetypes = {},
      shade_terminals = false,
      shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
      start_in_insert = true,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true, -- close the terminal window when the process exits
      shell = vim.o.shell, -- change the default shell
    })
  end,
},

  {"folke/trouble.nvim",
  lazy = true,
  cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
  config = function()
    local icons = meg.icons

    require("trouble").setup({
      position = "bottom", -- position of the list can be: bottom, top, left, right
      height = 10, -- height of the trouble list when position is top or bottom
      width = 50, -- width of the list when position is left or right
      icons = true, -- use devicons for filenames
      mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
      fold_open = icons.ui.fold_open, -- icon used for open folds
      fold_closed = icons.ui.fold_close, -- icon used for closed folds
      group = true, -- group results by file
      padding = true, -- add an extra new line on top of the list
      action_keys = {
        -- key mappings for actions in the trouble list
        -- map to {} to remove a mapping, for example:
        -- close = {},
        close = "q", -- close the list
        cancel = "<ESC>", -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r", -- manually refresh
        jump = { "<CR>", "<TAB>" }, -- jump to the diagnostic or open / close folds
        open_split = { "<C-x>" }, -- open buffer in new split
        open_vsplit = { "<C-v>" }, -- open buffer in new vsplit
        open_tab = { "<C-t>" }, -- open buffer in new tab
        jump_close = { "o" }, -- jump to the diagnostic and close the list
        toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = "P", -- toggle auto_preview
        hover = "K", -- opens a small popup with the full multiline message
        preview = "p", -- preview the diagnostic location
        close_folds = { "zM", "zm" }, -- close all folds
        open_folds = { "zR", "zr" }, -- open all folds
        toggle_fold = { "zA", "za" }, -- toggle fold of current file
        previous = "k", -- preview item
        next = "j", -- next item
      },
      indent_lines = true, -- add an indent guide below the fold icons
      auto_open = false, -- automatically open the list when you have diagnostics
      auto_close = false, -- automatically close the list when you have no diagnostics
      auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
      auto_fold = false, -- automatically fold a file trouble list at creation
      auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
      signs = {
        -- icons / text used for a diagnostic
        error = icons.lsp.error,
        warning = icons.lsp.warn,
        hint = icons.lsp.hint,
        information = icons.lsp.info,
        other = icons.misc.note,
      },
      use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
    })
  end,
},
  {"folke/which-key.nvim",
  lazy = true,
  event = { "CursorHold", "CursorHoldI" },
  config = function()
    local icons = meg.icons

    require("which-key").setup({
      plugins = {
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = false,
          nav = false,
          z = true,
          g = true,
        },
      },

      icons = {
        breadcrumb = icons.misc.chevron_right,
        separator = icons.sep,
        group = icons.misc.bookmark,
      },

      window = {
        border = "shadow",
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 1, 1, 1, 1 },
        winblend = 0,
      },
      layout = {
        align = "center",
      },
    })
  end,
},
  {"gelguy/wilder.nvim",
  lazy = true,
  event = "CmdlineEnter",
  config = function()
    local wilder = require("wilder")
    local colors = require("meg.utils.plugins").get_palette()
    local icons = meg.icons

    wilder.setup({ modes = { ":", "/", "?" } })
    wilder.set_option("use_python_remote_plugin", 0)
    wilder.set_option("pipeline", {
      wilder.branch(
        wilder.cmdline_pipeline({ use_python = 0, fuzzy = 1, fuzzy_filter = wilder.lua_fzy_filter() }),
        wilder.vim_search_pipeline(),
        {
          wilder.check(function(_, x)
            return x == ""
          end),
          wilder.history(),
          wilder.result({
            draw = {
              function(_, x)
                return icons.misc.calendar .. " " .. x
              end,
            },
          }),
        }
      ),
    })

    local match_hl = require("meg.utils.plugins").hl_to_rgb("String", false, colors.green)

    local popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
      border = "rounded",
      highlights = {
        border = "Title", -- highlight to use for the border
        accent = wilder.make_hl("WilderAccent", "Pmenu", { { a = 0 }, { a = 0 }, { foreground = match_hl } }),
      },
      empty_message = wilder.popupmenu_empty_message_with_spinner(),
      highlighter = wilder.lua_fzy_highlighter(),
      left = {
        " ",
        wilder.popupmenu_devicons(),
        wilder.popupmenu_buffer_flags({
          flags = " a + ",
          icons = { ["+"] = icons.misc.pencil, a = icons.sep, h = icons.codicons.File },
        }),
      },
      right = {
        " ",
        wilder.popupmenu_scrollbar(),
      },
    }))
    local wildmenu_renderer = wilder.wildmenu_renderer({
      highlighter = wilder.lua_fzy_highlighter(),
      apply_incsearch_fix = true,
      separator = " | ",
      left = { " ", wilder.wildmenu_spinner(), " " },
      right = { " ", wilder.wildmenu_index() },
    })
    wilder.set_option(
      "renderer",
      wilder.renderer_mux({
        [":"] = popupmenu_renderer,
        ["/"] = wildmenu_renderer,
        substitute = wildmenu_renderer,
      })
    )
  end,
  dependencies = { "romgrk/fzy-lua-native" },
},

----------------------------------------------------------------------
--                        Telescope Plugins                         --
----------------------------------------------------------------------
  {"nvim-telescope/telescope.nvim",
  lazy = true,
  cmd = "Telescope",
  config = function()
    local icons = meg.icons
    local lga_actions = require("telescope-live-grep-args.actions")

    require("telescope").setup({
      defaults = {
        initial_mode = "insert",
        prompt_prefix = " " .. icons.misc.telescope .. " ",
        selection_caret = icons.misc.chevron_right,
        scroll_strategy = "limit",
        results_title = false,
        layout_strategy = "horizontal",
        path_display = { "absolute" },
        file_ignore_patterns = { ".git/", ".cache", "%.class", "%.pdf", "%.mkv", "%.mp4", "%.zip" },
        layout_config = {
          horizontal = {
            preview_width = 0.5,
          },
        },
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      },
      pickers = {
        keymaps = {
          theme = "dropdown",
        },
      },
      extensions = {
        fzf = {
          fuzzy = false,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        frecency = {
          show_scores = true,
          show_unindexed = true,
          ignore_patterns = { "*.git/*", "*/tmp/*" },
        },
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = { -- extend mappings
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
            },
          },
        },
        undo = {
          side_by_side = true,
          mappings = { -- this whole table is the default
            i = {
              -- IMPORTANT: Note that telescope-undo must be available when telescope is configured if
              -- you want to use the following actions. This means installing as a dependency of
              -- telescope in it's `requirements` and loading this extension from there instead of
              -- having the separate plugin definition as outlined above. See issue #6.
              ["<cr>"] = require("telescope-undo.actions").yank_additions,
              ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
              ["<C-cr>"] = require("telescope-undo.actions").restore,
            },
          },
        },
      },
    })

    require("telescope").load_extension("frecency")
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("live_grep_args")
    require("telescope").load_extension("notify")
    require("telescope").load_extension("projects")
    require("telescope").load_extension("undo")
    require("telescope").load_extension("zoxide")
  end,
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-lua/plenary.nvim" },
    { "debugloop/telescope-undo.nvim" },
    {
      "ahmedkhalf/project.nvim",
      event = "BufReadPost",
      config = function()
        require("project_nvim").setup({
		manual_mode = false,
		detection_methods = { "lsp", "pattern" },
		patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
		ignore_lsp = { "null-ls", "copilot" },
		exclude_dirs = {},
		show_hidden = false,
		silent_chdir = true,
		scope_chdir = "global",
		datapath = vim.fn.stdpath("data"),
	})
      end,
    },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-frecency.nvim", dependencies = {
      { "kkharji/sqlite.lua" },
    } },
    { "jvgrootveld/telescope-zoxide" },
    { "nvim-telescope/telescope-live-grep-args.nvim" },
  },
}
}

----------------------------------------------------------------------
--                           DAP Plugins                            --
----------------------------------------------------------------------
-- tool["mfussenegger/nvim-dap"] = {
--   lazy = true,
--   cmd = {
--     "DapSetLogLevel",
--     "DapShowLog",
--     "DapContinue",
--     "DapToggleBreakpoint",
--     "DapToggleRepl",
--     "DapStepOver",
--     "DapStepInto",
--     "DapStepOut",
--     "DapTerminate",
--   },
--   config = require("tool.dap"),
--   dependencies = {
--     {
--       "rcarriga/nvim-dap-ui",
--       config = require("tool.dap.dapui"),
--     },
--   },
-- }

