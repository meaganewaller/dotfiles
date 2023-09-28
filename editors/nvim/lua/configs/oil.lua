local oil = require("oil")

oil.setup({
  default_file_explorer = true,
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  buf_options = {
    buflisted = false,
    bufhidden = "hide",
  },
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  restore_win_options = false,
  prompt_save_on_select_new_entry = false,
  view_options = {
    show_hidden = true,
  },
  float = {
    padding = 5,
    max_width = 0.8,
    max_height = 0.5,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
    override = function(conf) return conf end,
  },
  -- Configuration for the actions floating preview window
  preview = {
    -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_width and max_width can be a single value or a list of mixed integer/float types.
    -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
    max_width = 0.9,
    -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
    min_width = { 40, 0.4 },
    -- optionally define an integer/float for the exact width of the preview window
    width = nil,
    -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_height and max_height can be a single value or a list of mixed integer/float types.
    -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
    max_height = 0.9,
    -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
    min_height = { 5, 0.1 },
    -- optionally define an integer/float for the exact height of the preview window
    height = nil,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
  },
  -- Configuration for the floating progress window
  progress = {
    max_width = 0.9,
    min_width = { 40, 0.4 },
    width = nil,
    max_height = { 10, 0.9 },
    min_height = { 5, 0.1 },
    height = nil,
    border = "rounded",
    minimized_border = "none",
    win_options = {
      winblend = 0,
    },
  },
  keymaps = {
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-s>"] = "actions.select_split",
    ["`"] = "actions.tcd",
    ["~"] = "<cmd>edit $HOME<CR>",
    ["<leader>t"] = "actions.open_terminal",
    ["gd"] = {
      desc = "Toggle detail view",
      callback = function()
        local config = require("oil.config")
        if #config.columns == 1 then
          oil.set_columns({ "icon", "permissions", "size", "mtime" })
        else
          oil.set_columns({ "icon" })
        end
      end,
    },
  },
})

vim.keymap.set("n", "_", oil.open, { desc = "Open parent directory" })
vim.keymap.set("n", "-", function() oil.open(vim.fn.getcwd()) end, { desc = "Open cwd" })

local function find_files()
  local dir = oil.get_current_dir()
  if vim.api.nvim_win_get_config(0).relative ~= "" then vim.api.nvim_win_close(0, true) end
  require("telescope.builtin").find_files({ cwd = dir, hidden = true })
end

local function livegrep()
  local dir = oil.get_current_dir()
  if vim.api.nvim_win_get_config(0).relative ~= "" then vim.api.nvim_win_close(0, true) end
  require("telescope.builtin").live_grep({ cwd = dir })
end

local ok, ftplugin = pcall(require, "ftplugin")

if not ok then return end

ftplugin.set("oil", {
  keys = {
    { "<Leader>ff", find_files, desc = "[F]ind [F]iles in dir" },
    { "<Leader>fg", livegrep, desc = "[F]ind by [G]rep in dir" },
  },
  opt = {
    conceallevel = 3,
    concealcursor = "n",
    list = false,
    wrap = false,
    signcolumn = "no",
  },
  callback = function(bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "Save", function(params) oil.save({ confirm = not params.bang }) end, {
      desc = "Save oil changes with a preview",
      bang = true,
    })
    vim.api.nvim_buf_create_user_command(bufnr, "EmptyTrash", function(params) oil.empty_trash() end, {
      desc = "Empty the trash directory",
    })
    vim.api.nvim_buf_create_user_command(
      bufnr,
      "OpenTerminal",
      function(params) require("oil.adapters.ssh").open_terminal() end,
      { desc = "Open the debug terminal for ssh connections" }
    )
  end,
})
