-- https://github.com/nvim-telescope/telescope.nvim

local function flash(prompt_bufnr)
  require("flash").jump {
    pattern = "^",
    label = { after = { 0, 0 } },
    search = {
      mode = "search",
      exclude = {
        function(win)
          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype
          ~= "TelescopeResults"
        end,
      },
    },
    action = function(match)
      local picker = require("telecsope.actions.state").get_current_picker(prompt_bufnr)
      picker:set_selection(match.pos[1] - 1)
    end,
  }
end

local actions = require("telescope.actions")
local fb_actions = require('telescope').extensions.file_browser.actions
local utils = require("telescope.utils")
local builtin = require("telescope.builtin")

local extensions = {
  fzf = {
    fuzzy = true,
    override_generic_sorter = true,
    override_file_sorter = true,
    case_mode = "smart_case",
  },
  file_browser = {
    hijack_netrw = false,
    mappings = {
      ["i"] = {
        ["<C-p>"] = actions.move_selection_previous,
      },
      ["n"] = {
        ["C"] = fb_actions.create,
        ["R"] = fb_actions.rename,
        ["h"] = fb_actions.goto_parent_dir,
      },
    },
  },
}

if vim.fn.has("maxunix") then
  extensions.dash = {}
end

require("telescope").setup({
  defaults = {
    theme = 'center',
    selection_caret = "➤ ",

    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        width = 0.9,
        preview_width = 0.4,
      },
    },
    layout_strategy = "horizontal",
    history = {
      path = vim.fn.stdpath("data") .. "/database/telescope_history.sqlite3",
    },
    winblend = vim.o.winblend,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    mappings = {
      i = {
        ["<C-n>"] = false,
        ["<C-p>"] = false,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<Up>"] = actions.cycle_history_prev,
        ["<Down>"] = actions.cycle_history_next,
        ["<Esc>"] = actions.close,
        ["<C-s>"] = flash,
      },
      n = { ["q"] = actions.close, ["s"] = flash },
    },
  },
  pickers = {
    find_files = {
      theme = "ivy",
      layout_config = {
        height = 0.4,
      },
    },
  },
  extensions = extensions,
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("notify")
require("telescope").load_extension("possession")
--require("telescope").load_extension("command_palette")
require("telescope").load_extension("projects")
--require("telescope").load_extension("obsidian")
--require("telescope").load_extension("my_find_files")

nx.map({
  {
    ";f",
    function()
      builtin.find_files({
        no_ignore = true, hidden = true
      })
    end,
    desc = "Find files, respecting gitignore"
  },
  {
    ";se",
    function()
      builtin.diagnostics({ bufnr = 0 })
    end,
    desc = "Get file diagnostics"
  },
  {
    ";cd",
    function()
      builtin.find_files({ cwd = utils.buffer_dir })
    end,
    desc = "Search in current buffer directory"
  },
  {
    ";sf",
    builtin.find_files,
    desc = "Search Files"
  },
  {
    ";sg",
    builtin.live_grep,
    desc = "Search by Grep"
  },
  {
    ";gf",
    builtin.git_files,
    desc = "Search Git Files"
  },
  {
    ";sk",
    "<cmd>Telescope keymaps<CR>",
    desc = "Keymaps",
  },
  {
    ";sd",
    builtin.diagnostics,
    desc = "Search Diagnostics"
  },
  {
    ";sw",
    builtin.grep_string,
    desc = "Search current word"
  },
  {
    ";?",
    builtin.oldfiles,
    desc = "Find recently opened files"
  },
  {
    ";y",
    builtin.buffers,
    desc = "Find opened buffers in current neovim instance",
  },
  {
    ";sh",
    builtin.help_tags,
    desc = "Search Help"
  },
  {
    ";sc",
    builtin.colorscheme,
    desc = "Search Colorscheme",
  },
  {
    ";ss",
    builtin.search_history,
    desc = "Get list of searches",
  },
  {
    ";/",
    builtin.current_buffer_fuzzy_find,
    desc = "Fuzzily search in current buffer"
  },
  {
    ";;",
    builtin.resume,
    desc = "Resume",
  },
})
