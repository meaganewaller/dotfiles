-- https://github.com/lewis6991/gitsigns.nvim
local loaded, gitsigns = pcall(require, "gitsigns")
if not loaded then
  mw.loading_error_msg("gitsigns.nvim")
  return
end

local function setup(gitsigns, icons, borders)
  gitsigns.setup({
    signs = {
      add = { text = icons.signs.add },
      change = { text = icons.signs.change },
      delete = { text = icons.signs.delete },
      topdelete = { text = icons.signs.topdelete },
      changedelete = { text = icons.signs.changedelete },
      untracked = { text = icons.signs.untracked },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    show_deleted = false, -- Toggle with `:Gitsigns toggle_deleted`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    keymaps = {},
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
      delay = 0,
      ignore_whitespace = false,
      virt_text_priority = 0,
    },
    current_line_blame_formatter = "    " .. icons.commit[1] .. " <author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
      -- Options passed to nvim_open_win
      border = {
        borders.tl,
        borders.t,
        borders.tr,
        borders.r,
        borders.br,
        borders.b,
        borders.bl,
        borders.l,
      },
      style = "minimal",
      relative = "cursor",
      row = 1,
      col = 1,
    },
    yadm = {
      enable = false,
    },
  })
end

local icons = mw.ui.icons.git
local borders = mw.ui.borders.default
setup(gitsigns, icons, borders)
--
-- local gitsigns = require("gitsigns")
--
-- -- { == Configuration ==> =====================================================
--
-- local config = {
-- 	signs = {
-- 		add = { text = "│" },
-- 		change = { text = "│" },
-- 		delete = { text = "_" },
-- 		topdelete = { text = "‾" },
-- 		changedelete = { text = "~" },
-- 		untracked = { text = "┆" },
-- 	},
-- 	preview_config = {
-- 		border = "rounded",
-- 	},
-- }
-- -- <== }
--
-- -- { == Keymaps ==> ===========================================================
--
-- config.on_attach = function(bufnr)
-- 	local gs = package.loaded.gitsigns
--
-- 	-- Navigation
-- 	nx.map({
-- 		{
-- 			"<leader>gj",
-- 			function()
-- 				if vim.wo.diff then return "]c" end
-- 				vim.schedule(function() gs.next_hunk() end)
-- 				return "<Ignore>"
-- 			end,
-- 			desc = "Next Hunk",
-- 		},
-- 		{
-- 			"<leader>gk",
-- 			function()
-- 				if vim.wo.diff then return "[c" end
-- 				vim.schedule(function() gs.prev_hunk() end)
-- 				return "<Ignore>"
-- 			end,
-- 			desc = "Previous Hunk",
-- 		},
-- 	}, { expr = true })
-- 	-- Actions
-- 	nx.map({
-- 		{ "<leader>gs", gs.stage_hunk, { "n", "v" }, desc = "Stage Hunk" },
-- 		{ "<leader>gr", gs.reset_hunk, { "n", "v" }, desc = "Reset Hunk" },
-- 		{ "<leader>gp", gs.preview_hunk, desc = "Preview Hunk" },
-- 		{ "<leader>gu", gs.undo_stage_hunk, desc = "Undo Stage Hunk" },
-- 		{ "<leader>gS", gs.stage_buffer, desc = "Stage Buffer" },
-- 		{ "<leader>gR", gs.reset_buffer, desc = "Reset Buffer" },
-- 		{ "<leader>gB", gs.blame_line, desc = "Blame Line" },
-- 		{ "<leader>gD", function() gs.diffthis("~") end, desc = "Toggle Deleted Lines" },
-- 		-- { "<leader>gd", gs.diffthis },
-- 		-- { "<leader>tD", gs.toggle_deleted },
-- 		{ "<leader>tb", gs.toggle_current_line_blame, desc = "Blame", wk_label = "Blame" }, --wk_label not working as it is a buffer local mapping
-- 		{ "<leader>tS", gs.toggle_signs, desc = "GitSings" },
-- 		-- Text object
-- 		{ "ih", ":<C-U>Gitsigns select_hunk<CR>", { "o", "x" }, desc = "Select Hunk" },
-- 	}, { buffer = bufnr })
-- end
-- -- <== }
--
-- -- { == Highlights ==> ========================================================
--
-- nx.hl({ "GitSignsCurrentLineBlame", fg = "Debug:fg", bg = "CursorLine:bg", italic = true })
--
-- -- <== }
--
-- gitsigns.setup(config)
