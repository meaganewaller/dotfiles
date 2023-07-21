-- https://github.com/nvim-telescope/telescope.nvim

local telescope = require("telescope")
local actions = require("telescope.actions")
local actions_layout = require("telescope.actions.layout")

local config = {
  defaults = {
    multi_icon = "",
    layout_strategy = "flex",
    scroll_strategy = "cycle",
    select_strategy = "reset",
    winblend = 0,
    layout_config = {
      vertical = {
        mirror = true,
      },
      center = {
        mirror = true,
      },
    },
    hl_result_eol = false,
    preview = {
      msg_bg_fillchar = " ",
    },
    history = {
      cycle_wrap = true,
    },
    cache = false,
    mappings = {
      i = {
        ["<C-s>"] = actions.cycle_previewers_next,
        ["<C-a>"] = actions.cycle_previewers_prev,

        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
        ["<C-h>"] = actions_layout.toggle_preview,

        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<a-q>"] = false,
        ["<c-c>"] = function()
          vim.cmd([[stopinsert]])
        end,
        ["<esc>"] = actions.close,
      },
    },
    file_ignore_patterns = { "src/parser.c" },
    dynamic_preview_title = true,
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
    },
    file_browser = {
      theme = "dropdown",
      previewer = false,
    },
    git_files = {
      theme = "dropdown",
      previewer = false,
    },
    buffers = {
      sort_mru = true,
      theme = "dropdown",
      previewer = false,
      mappings = {
        i = { ["<c-d>"] = actions.delete_buffer },
      },
    },
    man_pages = { sections = { "2", "3" } },
    lsp_references = { path_display = { "shorten" } },
    lsp_code_actions = { theme = "dropdown" },
    current_buffer_fuzzy_find = { theme = "dropdown" },
  },
  extensions = {
    frecency = {
      persistent_filter = false,
      show_scores = true,
      show_unindexed = true,
      ignore_patterns = { "*.git/*", "*/tmp/*", "*.foo" },
      workspaces = {},
    },
  },
}

telescope.setup(config)
telescope.load_extension("fzf")

nx.map({
  { "<Leader>//", "<cmd>Telescope resume<CR>", desc = "Last Search" },
  { '<leader>/"', "<Cmd>Telescope registers<CR>", desc = "Search Registers" },
  { "<leader>/:", "<Cmd>Telescope commands<CR>", desc = "Search Commands" },
  { "<leader>/f", "<Cmd>Telescope find_files<CR>", desc = "Search Files" },
  { "<leader>/g", "<Cmd>Telescope live_grep theme=ivy<CR>", desc = "Grep" },
  { "<leader>/G", ":Telescope grep_string theme=ivy search=", desc = "Grep String" },
  { "<leader>/h", "<Cmd>Telescope highlights<CR>", desc = "Search Highlights" },
  { "<leader>/H", "<Cmd>Telescope help_tags<CR>", desc = "Search Help" },
  { "<leader>/i", "<Cmd>Telescope media_files<CR>", desc = "Search Media" },
  { "<leader>/k", "<Cmd>Telescope keymaps<CR>", desc = "Search Keymaps" },
  { "<leader>/M", "<Cmd>Telescope man_pages<CR>", desc = "Search Man Pages" },
  { "<leader>/r", telescope.extensions.recent_files.pick, desc = "Search Recent Files" },
}, { wk_label = { sub_desc = "+ Search" } })
--
--
-- -- Prevent entering buffers in insert mode. Mainly after opening buffers via telescope.
-- local original_edit = require("telescope.actions.set").edit
-- ---@diagnostic disable-next-line: duplicate-set-field
-- require("telescope.actions.set").edit = function(...)
--   original_edit(...)
--   vim.cmd.stopinsert()
-- end
--
-- ---@param extensions string[]
-- local function load_extensions(extensions)
--   for _, extension in ipairs(extensions) do
--     telescope.load_extension(extension)
--   end
-- end
--
-- -- Lazy load majority of extensions
-- vim.schedule(function()
--   load_extensions({
--     "bookmarks",
--     "recent_files",
--     "frecency",
--     "persisted",
--     "fzy_native",
--     "media_files",
--     "projects",
--   })
-- end)
-- nx.au({
--   "TermEnter",
--   once = true,
--   callback = function()
--     telescope.load_extension("termfinder")
--   end,
-- })
