return {

	-----------------------------------------------------------------------------
  {
    'lewis6991/gitsigns.nvim',
    event = "VeryLazy",
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      preview_config = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      local gitsigns = require("gitsigns")
      opts.on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        nx.map({
          {
            "<leader>gj",
            function()
              if vim.wo.diff then return "]c" end
              vim.schedule(function() gs.next_hunk() end)
              return "<Ignore>"
            end,
            desc = "Next Hunk",
          },
          {
            "<leader>gk",
            function()
              if vim.wo.diff then return "[c" end
              vim.schedule(function() gs.prev_hunk() end)
              return "<Ignore>"
            end,
            desc = "Previous Hunk",
          },
        }, { expr = true })

        nx.map({
          { "<leader>gs", gs.stage_hunk, { "n", "v" }, desc = "Stage Hunk" },
          { "<leader>gr", gs.reset_hunk, { "n", "v" }, desc = "Reset Hunk" },
          { "<leader>gp", gs.preview_hunk, desc = "Preview Hunk" },
          { "<leader>gu", gs.undo_stage_hunk, desc = "Undo Stage Hunk" },
          { "<leader>gS", gs.stage_buffer, desc = "Stage Buffer" },
          { "<leader>gR", gs.reset_buffer, desc = "Reset Buffer" },
          { "<leader>gB", gs.blame_line, desc = "Blame Line" },
          { "<leader>gD", function() gs.diffthis("~") end, desc = "Toggle Deleted Lines" },
          -- { "<leader>gd", gs.diffthis },
          -- { "<leader>tD", gs.toggle_deleted },
          { "<leader>tb", gs.toggle_current_line_blame, desc = "Blame", wk_label = "Blame" }, --wk_label not working as it is a buffer local mapping
          { "<leader>tS", gs.toggle_signs, desc = "GitSings" },
          -- Text object
          { "ih", ":<C-U>Gitsigns select_hunk<CR>", { "o", "x" }, desc = "Select Hunk" },
          }, { buffer = bufnr })
      end

      nx.hl({ "GitSignsCurrentLineBlame", fg = "Debug:fg", bg = "CursorLine:bg", italic = true })
      gitsigns.setup(opts)
    end,
		event = { 'BufReadPre', 'BufNewFile' },
		-- See: https://github.com/lewis6991/gitsigns.nvim#usage
		opts = {
			signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
			numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			attach_to_untracked = true,
			watch_gitdir = {
				interval = 1000,
				follow_files = true
			},
			preview_config = {
				border = 'rounded',
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				---@return string
				map('n', ']g', function()
					if vim.wo.diff then return ']c' end
					vim.schedule(function() gs.next_hunk() end)
					return '<Ignore>'
				end, { expr = true, desc = 'Git hunk forward'  })

				map('n', '[g', function()
					if vim.wo.diff then return '[c' end
					vim.schedule(function() gs.prev_hunk() end)
					return '<Ignore>'
				end, { expr = true, desc = 'Git hunk last' })

				-- Actions
				--
				map('n', '<leader>hs', gs.stage_hunk, { silent = true, desc = 'Stage hunk' })
				map('n', '<leader>hr', gs.reset_hunk, { silent = true, desc = 'Reset hunk' })
				map('x', '<leader>hs', function() gs.stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end)
				map('x', '<leader>hr', function() gs.reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end)
				map('n', '<leader>hS', gs.stage_buffer, { silent = true, desc = 'Stage buffer' })
				map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo staged hunk' })
				map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
				map('n', 'gs', gs.preview_hunk, { desc = 'Preview hunk' })
				map('n', '<leader>hp', gs.preview_hunk_inline, { desc = 'Preview hunk inline' })
				map('n', '<leader>hb', function() gs.blame_line({ full=true }) end, { desc = 'Show blame commit' })
				map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle Git line blame' })
				-- map('n', '<leader>tw', gs.toggle_word_diff)
				map('n', '<leader>hd', gs.diffthis, { desc = 'Diff against the index' })
				map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = 'Diff against the last commit' })
				map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle Git deleted' })
				map('n', '<leader>hl', function()
					if vim.api.nvim_buf_get_option(0, 'filetype') ~= 'qf' then
						require('gitsigns').setqflist(0, { use_location_list = true })
					end
				end, { desc = 'Send to location list' })

				-- Text object
				map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { silent = true, desc = 'Select hunk'})

			end,
		},
	},

  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    opts = {
      default_mappings = true,
      disable_diagnostics = false,
      highlights = {
        incoming = "DiffText",
        current = "DiffAdd",
      },
    },
  },

  {
    'sindrets/diffview.nvim',
    event = "VeryLazy",
    opts = {
      diff_binaries = false,
      enhanced_diff_hl = false,
      use_icons = true,
      icons = { -- Only applies when use_icons is true.
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
      },
      file_panel = {
        win_config = {
          position = "left", -- One of 'left', 'right', 'top', 'bottom'
          width = 34, -- Only applies when position is 'left' or 'right'
          height = 10, -- Only applies when position is 'top' or 'bottom'
        },
        listing_style = "tree", -- One of 'list' or 'tree'
        tree_options = { -- Only applies when listing_style is 'tree'
          flatten_dirs = true, -- Flatten dirs that only contain one single dir
          folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
        },
      },
      view = {
        merge_tool = {
          -- Config for conflicted files in diff views during a merge or rebase.
          layout = "diff3_mixed",
        },
      },
      file_history_panel = {
        win_config = {
          position = "bottom",
          height = 10,
        },
      },
      default_args = { -- Default args prepended to the arg-list for the listed commands
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      hooks = {
        view_opened = function() vim.g.diffview_open = true end,
        view_closed = function() vim.g.diffview_open = false end,
      },
      key_bindings = {}, -- See Keymap section below
    },
    config = function(_, opts)
      local diffview = require("diffview")
      local actions = require("diffview.actions")

      opts.key_bindings = {
        disable_defaults = false,
        file_panel = {
          { "n", "s", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry." } },
          { "n", "<c-f>", actions.scroll_view(0.382), { desc = "Scroll the view down" } },
          { "n", "<c-b>", actions.scroll_view(-0.382), { desc = "Scroll the view up" } },
        },
      }
      nx.map({
        { "<leader>gd", "<Cmd>DiffviewToggle<CR>", desc = "Toggle Diffview", wk_label = "Diffview" },
        { "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", desc = "Diffview File History", wk_label = "File History" },
      })

      diffview.setup(opts)

      if vim.g.colors_name == "rose-pine" then
        local palette = require("rose-pine.palette")
        nx.hl({
          { "DiffViewFilePanelFileName", fg = palette.iris },
          { "DiffViewFilePanelCounter", fg = palette.foam },
          { "diffChanged", link = "DiffvimDim1" },
        })
      end

      nx.cmd({
        "DiffviewToggle",
        function(e)
          if vim.g.diffview_open then
            vim.cmd("DiffviewClose")
          else
            vim.cmd("DiffviewOpen " .. e.args)
          end
        end,
        nargs = "*",
      })
    end,
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  },

  -----------------------------------------------------------------------------
  {
		'TimUntersberger/neogit',
    event = "VeryLazy",
    opts = {
      disable_signs = false,
      disable_hint = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = false,
      disable_insert_on_commit = true,
      -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
      -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
      auto_refresh = true,
      disable_builtin_notifications = true,
      use_magit_keybindings = false,
      commit_popup = {
        kind = "split",
      },
      -- Change the default way of opening neogit
      kind = "tab",
      -- customize displayed signs
      signs = {
        -- { CLOSED, OPENED }
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
      },
      integrations = {
        -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `sindrets/diffview.nvim`.
        -- The diffview integration enables the diff popup, which is a wrapper around `sindrets/diffview.nvim`.
        --
        -- Requires you to have `sindrets/diffview.nvim` installed.
        -- use {
        --   'TimUntersberger/neogit',
        --   requires = {
        --     'nvim-lua/plenary.nvim',
        --     'sindrets/diffview.nvim'
        --   }
        -- }
        --
        diffview = true,
      },
      -- Setting any section to `false` will make the section not render at all
      sections = {
        untracked = {
          folded = false,
        },
        unstaged = {
          folded = false,
        },
        staged = {
          folded = false,
        },
        stashes = {
          folded = true,
        },
        unpulled = {
          folded = true,
        },
        unmerged = {
          folded = false,
        },
        recent = {
          folded = true,
        },
      },
      mappings = {},
    },
    config = function(_, opts)
      local neogit = require("neogit")
      nx.au({ "FileType", pattern = "NeogitCommitMessage", command = "setlocal spell" })

      opts.mappings = {
        status = {
          ["B"] = "BranchPopup",
          ["<kEnter>"] = "GoToFile",
        },
        commit = {
          send = { ";q", "<leader>e" },
        },
      }

      nx.map({ "<leader>gn", "<Cmd>Neogit<CR>", desc = "Neogit" })
      nx.au({
        { "Filetype", pattern = "NeogitPushPopup", command = "nnoremap <buffer> F <nop>" },
        { "Filetype", pattern = "NeogitCommitMessage", command = "setlocal et ts=2 sw=2" },
      })

      if vim.g.colors_name == "rose-pine" then
        nx.hl({ "NeogitDiffAddHighlight", fg = "DiffAdd:fg", bg = "StatusLineTermNC:bg" })
        nx.hl({ "NeogitDiffDeleteHighlight", fg = "DiffDelete:fg", bg = "StatusLineTermNC:bg" })
      end

      neogit.setup(opts)
    end,
	},

  {
    "mattn/vim-gist",
    event = "VeryLazy",
    config = function()
      vim.g.gist_open_browser_after_post = 1
      nx.map({
        { "<leader>gGa", "<Cmd>Gist -b -a<CR>", desc = "Create Anonymous Gist", wk_label = " Create Anonymous" },
        { "<leader>gGd", "<Cmd>Gist -d<CR>", desc = "Delete Gist", wk_label = "Delete" },
        { "<leader>gGf", "<Cmd>Gist -f<CR>", desc = "Fork Gist", wk_label = "Fork" },
        { "<leader>gGp", "<Cmd>Gist -b<CR>", desc = "Create Gist", wk_label = "Create" },
        { "<leader>gGl", "<Cmd>Gist -l<CR>", desc = "List Gist", wk_label = "List" },
        { "<leader>gGp", "<Cmd>Gist -b -p<CR>", desc = "Create Private Gist", wk_label = "Create Private" },
      })
    end,
  },

  { "mattn/webapi-vim", event = "VeryLazy" },

	-----------------------------------------------------------------------------
	{
		'tpope/vim-fugitive',
		cmd = { 'G', 'Git', 'GBrowse', 'Gfetch', 'Gpush', 'Gclog', 'Gdiffsplit' },
		keys = {
			{ '<leader>gd', '<cmd>Gdiffsplit<CR>', desc = 'Git diff' },
			{ '<leader>gb', '<cmd>Git blame<CR>', desc = 'Git blame' },
		},
		config = function()
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('meg_fugitive', {}),
				pattern = 'fugitiveblame',
				callback = function()
					vim.schedule(function()
						vim.cmd.normal('A')
					end)
				end
			})
		end
	},

	-----------------------------------------------------------------------------
	{
		'junegunn/gv.vim',
		dependencies = { 'tpope/vim-fugitive' },
		cmd = 'GV'
	},

  -----------------------------------------------------------------------------
  {
    'ruifm/gitlinker.nvim',
    event = "VeryLazy",
    config = true
  },

	-----------------------------------------------------------------------------
	{
		'rhysd/committia.vim',
		event = 'BufReadPre COMMIT_EDITMSG',
		init = function()
			-- See: https://github.com/rhysd/committia.vim#variables
			vim.g.committia_min_window_width = 30
			vim.g.committia_edit_window_width = 75
		end,
		config = function()
			vim.g.committia_hooks = {
				edit_open = function()
					vim.cmd.resize(10)
					local opts = {
						buffer = vim.api.nvim_get_current_buf(),
						silent = true,
					}
					local function imap(lhs, rhs)
						vim.keymap.set('i', lhs, rhs, opts)
					end
					imap('<C-d>', '<Plug>(committia-scroll-diff-down-half)')
					imap('<C-u>', '<Plug>(committia-scroll-diff-up-half)')
					imap('<C-f>', '<Plug>(committia-scroll-diff-down-page)')
					imap('<C-b>', '<Plug>(committia-scroll-diff-up-page)')
					imap('<C-j>', '<Plug>(committia-scroll-diff-down)')
					imap('<C-k>', '<Plug>(committia-scroll-diff-up)')
				end,
			}
		end,
	},

}
