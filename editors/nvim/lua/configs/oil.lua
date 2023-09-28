local oil = require("oil")

oil.setup({
  delete_to_trsh = true,
  skip_confirm_for_simple_edits = true,
  restore_win_options = flse,
  prompt_save_on_select_new_entry = false,
  keymaps = {
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
      {
        desc = "Open the debug terminal for ssh connections",
      }
    )
  end,
})
