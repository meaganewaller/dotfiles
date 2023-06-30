-- https://github.com/stevearc/dressing.nvim

local loaded, dressing = pcall(require, "dressing")
if not loaded then
  mw.loading_error_msg("dressing.nvim")
  return
end

local function setup(dressing, borders, winblend)
  dressing.setup({
    input = {
      -- Set to false to disable the vim.ui.input implementation
      enabled = false,

      -- These are passed to nvim_open_win
      anchor = "SW",
      border = {
        borders.default.tl,
        borders.default.t,
        borders.default.tr,
        borders.default.r,
        borders.default.br,
        borders.default.b,
        borders.default.bl,
        borders.default.l,
      },
      -- 'editor' and 'win' will default to being centered
      relative = "cursor",

      -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      prefer_width = 40,
      width = nil,
      -- min_width and max_width can be a list of mixed types.
      -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
      max_width = { 140, 0.9 },
      min_width = { 20, 0.2 },

      -- Window transparency (0-100)
      win_options = {
        winblend = winblend,
      },
    },
    select = {
      -- Set to false to disable the vim.ui.select implementation
      enabled = true,

      -- Priority list of preferred vim.select implementations
      backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

      -- Options for telescope selector
      -- These are passed into the telescope picker directly. Can be used like:
      -- telescope = require('telescope.themes').get_ivy({...})
      telescope = require("telescope.themes").get_dropdown({
        previewer = false,
        results_title = false,
        layout_strategy = "vertical",
        layout_config = {
          prompt_position = "top",
          width = {
            0.6,
            min = 90,
            max = 110,
          },
          height = {
            0.5,
            min = 20,
            max = 40,
          },
        },
        borderchars = {
          prompt = {
            borders.default.t,
            borders.default.r,
            borders.none.b,
            borders.default.l,
            borders.default.tl,
            borders.default.tr,
            borders.default.r,
            borders.default.l,
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
            borders.none.b,
            borders.default.l,
            borders.default.tl,
            borders.default.tr,
            borders.default.r,
            borders.default.l,
          },
        },
      }),
    },
  })
end

local winblend = mw.ui.window.transparency
local borders = mw.ui.borders
setup(dressing, borders, winblend)
--
-- -- { == Configuration ==> =====================================================
--
-- require("dressing").setup({
-- 	input = {
-- 		default_prompt = "➤ ",
-- 		win_options = {
-- 			winblend = vim.o.winblend,
-- 		},
-- 	},
-- 	select = {
-- 		get_config = function(opts)
-- 			if opts.kind == "codeaction" then
-- 				return {
-- 					backend = "nui",
-- 					nui = {
-- 						border = { style = "rounded" },
-- 						max_width = 40,
-- 					},
-- 				}
-- 			end
-- 		end,
-- 		telescope = require("telescope.themes").get_dropdown({
-- 			previewer = false,
-- 			border = nx.opts.float_win_border ~= "none" and true or false,
-- 		}),
-- 		builtin = {
-- 			win_options = {
-- 				winblend = vim.o.winblend,
-- 			},
-- 			border = nx.opts.float_win_border,
-- 		},
-- 		nui = {
-- 			win_options = {
-- 				winblend = vim.o.winblend,
-- 			},
-- 			border = nx.opts.float_win_border,
-- 		},
-- 	},
-- })
-- -- <== }
--
-- -- { == Highlights ==> ========================================================
--
-- nx.map({
-- 	{ "<Esc>", "<Esc>", "i" },
-- 	{ "<C-c>", "<Cmd>close<CR>", { "i", "x" } },
-- 	{ "q", "<Cmd>close<CR>", "x" },
-- }, { buffer = 0, ft = "DressingInput" })
-- -- <== }
