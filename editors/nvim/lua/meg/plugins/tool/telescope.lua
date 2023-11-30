return {
  "nvim-telescope/telescope.nvim",
  event = 'VeryLazy',
  branch = "0.1.x",
  dependencies = {
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "debugloop/telescope-undo.nvim" },
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "nvim-telescope/telescope-fzy-native.nvim" },
    { "nvim-telescope/telescope-live-grep-args.nvim" },
    { "nvim-telescope/telescope-dap.nvim" },
    { "benfowler/telescope-luasnip.nvim" },
  },
  config = function()
    local telescope = require "telescope"
    local tele_actions = require "telescope.actions"
    local lga_actions = require "telescope-live-grep-args.actions"
    local lga_shortcuts = require "telescope-live-grep-args.shortcuts"
    local undo_actions = require "telescope-undo.actions"

    local noremap = require("meg.utils").noremap

    telescope.setup({
      defaults = {
        layout_config = {
          anchor = "center",
          height = 0.8,
          width = 0.9,
          preview_width = 0.6,
          prompt_position = "bottom",
        },
        borderchars = require("meg.custom").telescope,
        mappings = {
          i = {
            ['<esc>'] = tele_actions.close,
          },
        },
      },
      extensions = {
        undo = {
          use_delta = true,
          side_by_side = true,
          entry_format = "󰣜  #$ID, $STAT, $TIME",
          layout_strategy = "flex",
          mappings = {
            i = {
              ["<cr>"] = undo_actions.yank_additions,
              ["§"] = undo_actions.yank_deletions, -- term mapped to shift+enter
              ["<c-\\>"] = undo_actions.restore,
            },
          },
        },
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ["<C-\\>"] = lga_actions.quote_prompt({ postfix = "--hidden" }),
            },
          },
        },
        file_browser = {
          depth = 1,
          auto_depth = false,
          hidden = { file_browser = true, folder_browser = true },
          hide_parent_dir = false,
          collapse_dirs = false,
          prompt_path = false,
          quiet = false,
          dir_icon = " ",
          dir_icon_hl = "Default",
          display_stat = { date = true, size = true, mode = true },
          git_status = true,
        },
      },
    })
    noremap("n", "<Leader>u", ":Telescope undo<CR>", "Undo tree")
    noremap("n", "\\", function()
      telescope.extensions.live_grep_args.live_grep_args({
        prompt_title = 'grep',
        additional_args = '-i',
      })
    end, "Live grep")
    noremap("n", "<Leader>o", ":Telescope oldfiles<CR>", "Old files")
    noremap("n", "<Leader>gc", function()
      lga_shortcuts.grep_word_under_cursor({ postfix = " --hidden " })
    end, "grep under cursor")
    noremap("n", "<Leader>gC", function()
      lga_shortcuts.grep_word_under_cursor({ postfix = " --hidden --word-regexp " })
    end, "grep under cursor (word)")
    noremap("n", "<Leader>g/", function()
      lga_shortcuts.grep_word_under_cursor({ postfix = " --hidden --regexp " })
    end, "grep under cursor (regexp)")
    noremap("n", "<Leader>g?", function()
      lga_shortcuts.grep_word_under_cursor({ postfix = " --hidden --fixed-strings " })
    end, "grep under cursor (fixed strings)")
    noremap("n", "<Leader>g*", function()
      lga_shortcuts.grep_word_under_cursor({ postfix = " --hidden --fixed-strings --word-regexp " })
    end, "grep under cursor (fixed strings, word)")
    noremap("n", "<Leader>g#", function()
      lga_shortcuts.grep_word_under_cursor({ postfix = " --hidden --fixed-strings --regexp " })
    end, "grep under cursor (fixed strings, regexp)")
    noremap("n", "<Leader>g<space>", function()
      lga_shortcuts.grep_word_under_cursor({ postfix = " --hidden --fixed-strings --word-regexp --regexp " })
    end, "grep under cursor (fixed strings, word, regexp)")
    noremap("n", "<Leader>.", function()
      telescope.extensions.file_browser.file_browser({
        path = vim.fn.stdpath("config")
      })
    end, "nvim dotfiles")
    telescope.load_extension("undo")
    telescope.load_extension("file_browser")
    telescope.load_extension("live_grep_args")
  end,
}
