-- https://github.com/nvim-telescope/telescope.nvim

function mw.find_files(...)
  if mw._find_files_impl then
    mw._find_files_impl(...)
  else
    vim.notify("No fuzzy finder installed", vim.log.levels.ERROR)
  end
end

local function find_dotfiles()
  mw.find_files({
    cwd = string.format("%s/.config/nvim/", os.getenv("HOME")),
    follow = true,
    hidden = true,
    previewer = false,
  })
end

local function find_local_files()
  mw.find_files({
    cwd = string.format("%s/.local/share/nvim-local/", os.getenv("HOME")),
    follow = true,
    hidden = true,
    previewer = false,
  })
end

local telescope = require('telescope')
local actions = require("telescope.actions")
local actions_layout = require("telescope.actions.layout")
local fb_actions = require("telescope").extensions.file_browser.actions
local pickers = require("meg.plugins.telescope_pickers").window_size
local icons = mw.ui.icons
local borders = mw.ui.borders

telescope.setup({
  defaults = {
    prompt_prefix = " " .. icons.search[1] .. " ",
    selection_caret = icons.point[1] .. " ",
    multi_icon = " " .. icons.select[1],
    entry_prefix = " ",
    winblend = mw.ui.window.transparency,
    color_devicons = true,
    border = true,
    borderchars = {
      prompt = {
        borders.none.t,
        borders.default.r,
        borders.default.b,
        borders.default.l,
        borders.default.l,
        borders.default.r,
        borders.default.br,
        borders.default.bl,
      },
      results = {
        borders.default.t,
        borders.default.r,
        borders.default.b,
        borders.default.l,
        borders.default.tl,
        borders.default.tr,
        borders.default.br,
        borders.default.bl,
      },
      preview = {
        borders.default.t,
        borders.default.r,
        borders.default.b,
        borders.default.l,
        borders.default.tl,
        borders.default.tr,
        borders.default.br,
        borders.default.bl,
      },
    },
    initial_mode = "insert",
    path_display = {
      truncate = 3,
    },
    dynamic_preview_title = true,
    preview = {
      check_mime_type = true,
      timeout = 3000,
      msg_bg_fillchar = "╱", -- "╱" "╲" "╳"
    },
    vimgrep_arguments = {
      "rg",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim", -- Remove indentation
      "--hidden",
    },
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
        preview_width = 0.6,
        width = pickers.width.large,
        height = pickers.height.large,
      },
      vertical = {
        mirror = false,
        preview_height = 0.4,
        width = pickers.width.medium,
        height = pickers.height.medium,
      },
    },
    selection_strategy = "reset",
    sorting_strategy = "descending",
    file_ignore_patterns = {
      "^.git",
      "^.nvim/",
      "tags",
      "node_modules",
    },
    history = {
      path = vim.fn.stdpath("data") .. "/databases/telescope_history",
      limit = 100,
    },
    file_sorter = require('telescope.sorters').get_fuzzy_file,
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    gflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    mappings = {
      i = {
        ["<C-c>"] = actions.close,
        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
        ["<C-y>"] = actions.select_default,
        ["<CR>"] = actions.select_default,
        ["<C-o>"] = false,
        ["<C-v>"] = false,
        ["<C-t>"] = false,
        ["<M-o>"] = actions.select_horizontal,
        ["<M-v>"] = actions.select_vertical,
        ["<M-t>"] = actions.select_tab,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,
        ["<C-l>"] = actions.complete_tag,
        ["<C-_>"] = actions.which_key,
--        ["<M-q>F"] = trouble.smart_open_with_trouble,
        ["<M-p>"] = actions_layout.toggle_preview,
        ["<C-x>"] = false,
        ["<C-q>"] = false,
        ["<M-q>"] = false,
        ["<C-/>"] = actions.which_key,
        ["<C-w>"] = false,
        ["<C-j>"] = actions.nop,
      },
      n = {
        ["q"] = actions.close,
        ["<esc>"] = actions.close,
        ["<C-c>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["P"] = actions.select_default,
        ["o"] = actions.select_horizontal,
        ["v"] = actions.select_vertical,
        ["t"] = actions.select_tab,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["mf"] = actions.toggle_selection,
        ["<Space>"] = actions.toggle_selection,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,
        ["?"] = actions.which_key,
--        ["qF"] = trouble.smart_open_with_trouble,
        ["p"] = actions_layout.toggle_preview,
        ["<C-x>"] = false,
        ["<C-v>"] = false,
        ["<C-t>"] = false,
        ["<C-q>"] = false,
        ["<M-q>"] = false,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden" },
    },
  },
  extensions = {
    file_browser = {
      grouped = true,
      depth = 1,
      dir_icon = icons.dir[1],
      dir_icon_hl = "Directory",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = false,
      mappings = {
        ["i"] = {
          ["-"] = false,
          ["~"] = false,
          ["<A-c>"] = false,
          ["<A-%>"] = fb_actions.create_from_prompt,
          ["<A-r>"] = false,
          ["<A-m>"] = false,
          ["<A-y>"] = false,
          ["<A-d>"] = false,
          ["<C-o>"] = false,
          ["<C-g>"] = false,
          ["<C-e>"] = false,
          ["<C-w>"] = false,
          ["<C-t>"] = false,
          ["<C-f>"] = false,
          ["<C-h>"] = false,
          ["<C-s>"] = false,
        },
        ["n"] = {
          ["%"] = fb_actions.create,
          ["R"] = fb_actions.rename,
          ["M"] = fb_actions.move,
          ["Y"] = fb_actions.copy,
          ["D"] = fb_actions.remove,
          ["X"] = fb_actions.open,
          ["-"] = fb_actions.goto_parent_dir,
          ["h"] = fb_actions.goto_parent_dir,
          ["~"] = fb_actions.goto_home_dir,
          ["."] = fb_actions.goto_cwd,
          ["cd"] = fb_actions.change_cwd,
          ["a"] = fb_actions.toggle_browser,
          ["gh"] = fb_actions.toggle_hidden,
          ["mu"] = fb_actions.toggle_all,
          ["c"] = false,
          ["r"] = false,
          ["m"] = false,
          ["y"] = false,
          ["d"] = false,
          ["o"] = false,
          ["g"] = false,
          ["e"] = false,
          ["t"] = actions.select_tab,
          ["f"] = false,
          ["s"] = false,
        },
      },
    },
    frecency = {
      db_root = vim.fn.stdpath("data") .. "/databases",
      show_scores = true,
      show_unindexed = true,
      ignore_patterns = { "*.git/*", "*/tmp/*" },
      disable_devicons = false,
      workspaces = {
        ["dots"] = "$HOME/.dotfiles",
        ["workspace"] = "$HOME/workspace",
      },
    },
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "ignore_case",
    },
  },
})

-- Load extensions
local extensions = {
  "dir",
  "file_browser",
  "frecency",
  "fzf",
--  "luasnip",
--  "possession"
}
pcall(function()
  for _, ext in ipairs(extensions) do
    telescope.load_extension(ext)
  end
end)

if not mw._find_files_impl then
  mw._find_files_impl = function(opts)
    opts = vim.tbl_deep_extend("keep", opts or {}, {
      previewer = false,
    })
    require("telescope.builtin").find_files(opts)
  end
end
