return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      prompt_prefix = " ",
      selection_caret = "  ",
      color_devicons = true,
      path_display = { "truncate" },
      dynamic_preview_title = true,
      sorting_strategy = "descending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          preview_width = 0.58,
        },
      },
      vertical = {
        prompt_position = "top",
      },
      extensions = {
        fzy_native = {
          override_generic_sorter = true,
          override_file_sorter = true,
        },
        live_grep_args = {
          auto_quoting = true,
          mappings = {},
          theme = "ivy",
          border = "rounded",
        },
        media_files = {
          filetypes = { "png", "webp", "jpg", "jpeg" },
          find_cmd = "fd",
        },
        persisted = {
          sorting_strategy = "ascending",
          layout_strategy = "center",
          layout_config = {
            width = 80,
            height = 15,
            prompt_position = "top",
          },
          border = true,
          results_title = false,
          borderchars = {
            prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
            preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local lga_actions = require("telescope-live-grep-args.actions")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")

      opts.mappings = {
        i = {
          ["<C-c>"] = actions.close,

          ["<CR>"] = actions.select_default,
          ["<kEnter>"] = actions.select_default,
          ["<C-s>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,

          ["<C-y>"] = actions.results_scrolling_up,
          ["<C-e>"] = actions.results_scrolling_down,
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,

          -- ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          -- ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["<C-l>"] = actions.complete_tag,
          ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>

          ["<Del>"] = require("telescope.actions").delete_buffer,
        },

        n = {
          ["<Esc>"] = actions.close,
          ["<C-c>"] = actions.close,

          ["<kEnter>"] = actions.select_default,
          ["<CR>"] = actions.select_default,
          ["<C-x>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,

          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["H"] = actions.move_to_top,
          ["M"] = actions.move_to_middle,
          ["L"] = actions.move_to_bottom,

          ["<Down>"] = actions.move_selection_next,
          ["<Up>"] = actions.move_selection_previous,
          ["gg"] = actions.move_to_top,
          ["G"] = actions.move_to_bottom,

          ["<C-y>"] = actions.results_scrolling_up,
          ["<C-e>"] = actions.results_scrolling_down,
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,

          ["?"] = actions.which_key,
          ["<Del>"] = require("telescope.actions").delete_buffer,
        },
      }

      opts.extensions.live_grep_args.mappings = {
        i = {
          ["<C-S-'>"] = lga_actions.quote_prompt(),
          ['<C-">'] = lga_actions.quote_prompt(),
        },
      }

      local border = "rounded"
      local borderchars =  { "═", "║", "═", "║", "╔", "╗", "╝", "╚" }

      ---Search MegVim config files
      ---@param prompt_title string
      ---@param search_dirs table?
      ---@param search_file string?
      local function find_config(prompt_title, search_dirs, search_file)
        builtin.find_files({
          cwd = vim.fn.stdpath("config") .. "/lua/meg",
          search_dirs = search_dirs,
          search_file = search_file,
          prompt_title = "MegVim " .. prompt_title,
        })
      end

      nx.map({
        -- Quick Pickers
        {
          "<C-p>",
          function()
            builtin.find_files(require("telescope.themes").get_dropdown({
              previewer = false,
              border = border,
              borderchars = borderchars,
            }))
          end,
          desc = "Go to File",
        },
        {
          "<A-p>",
          function()
            builtin.buffers(require("telescope.themes").get_dropdown({
              previewer = false,
              border = border,
              borderchars = borderchars,
            }))
          end,
          desc = "Go to Open Buffer",
        },
        -- Files
        { "<leader>f/", "<Cmd>Telescope find_files<CR>", desc = "Search Files" },
        { "<leader>fr", telescope.extensions.recent_files.pick, desc = "Recent Files" },
        { "<leader>fR", "<Cmd>Telescope frecency<CR>", desc = "Frequent Files" },
        -- Git
        { "<leader>gb", "<Cmd>Telescope git_branches<CR>", desc = "Branches" },
        { "<leader>gc", "<Cmd>Telescope git_commits<CR>", desc = "Commits" },
        { "<leader>gf", "<Cmd>Telescope git_status<CR>", desc = "Changed Files" },
        -- History
        { "<leader>hq", "<Cmd>Telescope quickfixhistory<CR>", desc = "Quickfixes" },
        { "<leader>h:", "<Cmd>Telescope command_history<CR>", desc = "Commands" },
        { "<leader>h/", "<Cmd>Telescope search_history<CR>", desc = "Searches" },
        -- Config
        {
          "<leader>,k",
          "<Cmd>Telescope grep_string cwd=~/.config/nvim/lua/nxvim/ search=nx.map prompt_title=MegVim\\ Keymaps<CR>",
          desc = "Search Key Mappings",
        },
        { "<leader>,l", function() find_config("LSP", { "lsp" }) end, desc = "Search LSP Files" },
        {
          "<leader>,p",
          function() find_config("Plugins", { "plugins", "lsp/plugins" }) end,
          desc = "Search Plugin Files",
        },
        {
          "<leader>,c",
          function() find_config("Colorschemes", { "colorschemes" }) end,
          desc = "Search Colorscheme Files",
        },
        { "<leader>tC", "<Cmd>Telescope colorscheme<CR>", desc = "Toggle Colorscheme", wk_label = "Colorscheme" },
      })
      -- Search
      nx.map({
        { "<leader>//", "<Cmd>Telescope resume<CR>", desc = "Last Search" },
        { '<leader>/"', "<Cmd>Telescope registers<CR>", desc = "Search Registers" },
        { "<leader>/:", "<Cmd>Telescope commands<CR>", desc = "Search Commands" },
        { "<leader>/f", "<Cmd>Telescope find_files<CR>", desc = "Search Files" },
        { "<leader>/g", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", desc = "Live Grep" },
        { "<leader>/G", ":Telescope grep_string theme=ivy search=", desc = "Grep String" },
        { "<leader>/h", "<Cmd>Telescope highlights<CR>", desc = "Search Highlights" },
        { "<leader>/H", "<Cmd>Telescope help_tags<CR>", desc = "Search Help" },
        { "<leader>/i", "<Cmd>Telescope media_files<CR>", desc = "Search Media" },
        { "<leader>/k", "<Cmd>Telescope keymaps<CR>", desc = "Search Keymaps" },
        { "<leader>/M", "<Cmd>Telescope man_pages<CR>", desc = "Search Man Pages" },
        { "<leader>/r", telescope.extensions.recent_files.pick, desc = "Search Recent Files" },
      }, { wk_label = { sub_desc = "Search" } })

      -- { == Highlights ==> ========================================================
      nx.hl({ { "TelescopeBorder", link = "LspFloatWinBorder" } })
      if vim.g.multigrid and vim.g.neovide then
        -- Workaround for layered highlight groups causing a different blend transparency in Telescope dialogs.
        nx.hl({
          { "TelescopeResultsNormal", bg = "Normal:bg", blend = 100 },
          { "TelescopeSelection", bg = "Visual:bg", blend = 0 },
          -- With this solution bg highlights in telescope dialogs are only visible on hover (see `:Telescope highlights`).
          -- It would require to re-set `blend` for every hl color to show the bg when it's not hovered.
          -- Since bg hls are not common in other telescope dialogs, we'll use this workaround it anyway.
          { { "TodoBgFIX", "TodoBgNOTE", "TodoBgTODO" }, blend = 0 },
        })
        if vim.g.neovide then config.defaults.winblend = 30 end
      end

      telescope.setup(config)

      -- Prevent entering buffers in insert mode. Mainly after opening buffers via telescope.
      local original_edit = require("telescope.actions.set").edit
      ---@diagnostic disable-next-line: duplicate-set-field
      require("telescope.actions.set").edit = function(...)
        original_edit(...)
        vim.cmd.stopinsert()
      end

      -- { == Extensions ==> ========================================================
      ---@param extensions string[]
      local function load_extensions(extensions)
        for _, extension in ipairs(extensions) do
          telescope.load_extension(extension)
        end
      end

      -- Lazy load majority of extensions
      vim.schedule(
        function()
          load_extensions({
            "bookmarks",
            "recent_files",
            "frecency",
            "persisted",
            "fzy_native",
            "media_files",
            "projects",
            "live_grep_args",
          })
        end
      )
      nx.au({ "TermEnter", once = true, callback = function() telescope.load_extension("termfinder") end })
    end,
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
    },
  },
  {
    "nvim-telescope/telescope-fzy-native.nvim",
    dependencies = "romgrk/fzy-lua-native",
    lazy = true
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    lazy = true
  },
  {
    "nvim-telescope/telescope-media-files.nvim",
    lazy = true
  },
  {
    "smartpde/telescope-recent-files"
  },
  {
    "tknightz/telescope-termfinder.nvim",
    lazy = true
  },
}
-- local myactions = {}
--
-- function myactions.send_to_qflist(prompt_bufnr)
-- 	require('telescope.actions').send_to_qflist(prompt_bufnr)
-- 	vim.api.nvim_command([[ botright copen ]])
-- end
--
-- function myactions.smart_send_to_qflist(prompt_bufnr)
-- 	require('telescope.actions').smart_send_to_qflist(prompt_bufnr)
-- 	vim.api.nvim_command([[ botright copen ]])
-- end
--
-- --- Scroll the results window up
-- ---@param prompt_bufnr number: The prompt bufnr
-- function myactions.results_scrolling_up(prompt_bufnr)
-- 	myactions.scroll_results(prompt_bufnr, -1)
-- end
--
-- --- Scroll the results window down
-- ---@param prompt_bufnr number: The prompt bufnr
-- function myactions.results_scrolling_down(prompt_bufnr)
-- 	myactions.scroll_results(prompt_bufnr, 1)
-- end
--
-- ---@param prompt_bufnr number: The prompt bufnr
-- ---@param direction number: 1|-1
-- function myactions.scroll_results(prompt_bufnr, direction)
-- 	local status = require('telescope.state').get_status(prompt_bufnr)
-- 	local default_speed = vim.api.nvim_win_get_height(status.results_win) / 2
-- 	local speed = status.picker.layout_config.scroll_speed or default_speed
--
-- 	require('telescope.actions.set')
-- 		.shift_selection(prompt_bufnr, math.floor(speed) * direction)
-- end
--
-- -- Custom pickers
--
-- local plugin_directories = function(opts)
-- 	local actions = require('telescope.actions')
-- 	local utils = require('telescope.utils')
-- 	local dir = vim.fn.stdpath('data') .. '/lazy'
--
-- 	opts = opts or {}
-- 	opts.cmd = vim.F.if_nil(opts.cmd, {
-- 		vim.o.shell,
-- 		'-c',
-- 		'find '..vim.fn.shellescape(dir)..' -mindepth 1 -maxdepth 1 -type d',
-- 	})
--
-- 	local dir_len = dir:len()
-- 	opts.entry_maker = function(line)
-- 		return {
-- 			value = line,
-- 			ordinal = line,
-- 			display = line:sub(dir_len + 2),
-- 		}
-- 	end
--
-- 	require('telescope.pickers').new(opts, {
-- 		layout_config = {
-- 			width = 0.65,
-- 			height = 0.7,
-- 		},
-- 		prompt_title = '[ Plugin directories ]',
-- 		finder = require('telescope.finders').new_table{
-- 			results = utils.get_os_command_output(opts.cmd),
-- 			entry_maker = opts.entry_maker,
-- 		},
-- 		sorter = require('telescope.sorters').get_fuzzy_file(),
-- 		previewer = require('telescope.previewers.term_previewer').cat.new(opts),
-- 		attach_mappings = function(prompt_bufnr)
-- 			actions.select_default:replace(function()
-- 				local entry = require('telescope.actions.state').get_selected_entry()
-- 				actions.close(prompt_bufnr)
-- 				vim.defer_fn(function() vim.cmd.lcd(entry.value) end, 300)
-- 			end)
-- 			return true
-- 		end
-- 	}):find()
-- end
--
-- -- Custom window-sizes
-- ---@param dimensions table
-- ---@param size integer
-- ---@return float
-- local function get_matched_ratio(dimensions, size)
-- 	for min_cols, scale in pairs(dimensions) do
-- 		if min_cols == 'lower' or size >= min_cols then
-- 			return math.floor(size * scale)
-- 		end
-- 	end
-- 	return dimensions.lower
-- end
--
-- local function width_tiny(_, cols, _)
-- 	return get_matched_ratio({ [180] = 0.27, lower = 0.37 }, cols)
-- end
--
-- local function width_small(_, cols, _)
-- 	return get_matched_ratio({ [180] = 0.4, lower = 0.5 }, cols)
-- end
--
-- local function width_medium(_, cols, _)
-- 	return get_matched_ratio({ [180] = 0.5, [110] = 0.6, lower = 0.75 }, cols)
-- end
--
-- local function width_large(_, cols, _)
-- 	return get_matched_ratio({ [180] = 0.7, [110] = 0.8, lower = 0.85 }, cols)
-- end
--
-- -- Enable indent-guides in telescope preview
-- vim.api.nvim_create_autocmd('User', {
-- 	pattern = 'TelescopePreviewerLoaded',
-- 	group = vim.api.nvim_create_augroup('meg_telescope', {}),
-- 	callback = function()
-- 		vim.wo.listchars = vim.wo.listchars .. ',tab:▏\\ '
-- 		vim.wo.conceallevel = 0
-- 		vim.wo.wrap = true
-- 		vim.wo.list = true
-- 		vim.wo.number = true
-- 	end
-- })
--
-- -- Setup Telescope
-- -- See telescope.nvim/lua/telescope/config.lua for defaults.
-- return {
--
-- 	-----------------------------------------------------------------------------
-- 	{
-- 		'nvim-telescope/telescope.nvim',
-- 		cmd = 'Telescope',
-- 		dependencies = {
-- 			'nvim-lua/plenary.nvim',
-- 			'jvgrootveld/telescope-zoxide',
-- 			'folke/todo-comments.nvim',
-- 			'rafi/telescope-thesaurus.nvim',
-- 			{
-- 				'nvim-telescope/telescope-frecency.nvim',
-- 				dependencies = 'kkharji/sqlite.lua'
-- 			},
-- 		},
-- 		config = function(_, opts)
-- 			require('telescope').setup(opts)
-- 			require('telescope').load_extension('persisted')
-- 			require('telescope').load_extension('frecency')
-- 		end,
-- 		keys = {
-- 			-- General pickers
-- 			{ '<localleader>r', '<cmd>Telescope resume initial_mode=normal<CR>', desc = 'Resume last' },
-- 			{ '<localleader>R', '<cmd>Telescope pickers<CR>', desc = 'Pickers' },
-- 			{ '<localleader>f', '<cmd>Telescope find_files<CR>', desc = 'Find files' },
-- 			{ '<localleader>g', '<cmd>Telescope live_grep<CR>', desc = 'Grep' },
-- 			{ '<localleader>b', '<cmd>Telescope buffers show_all_buffers=true<CR>', desc = 'Buffers' },
-- 			{ '<localleader>h', '<cmd>Telescope highlights<CR>', desc = 'Highlights' },
-- 			{ '<localleader>j', '<cmd>Telescope jumplist<CR>', desc = 'Jump list' },
-- 			{ '<localleader>m', '<cmd>Telescope marks<CR>', desc = 'Marks' },
-- 			{ '<localleader>o', '<cmd>Telescope vim_options<CR>', desc = 'Neovim options' },
-- 			{ '<localleader>p', '<cmd>Telescope venom virtualenvs<CR>', desc = 'Virtualenvs' },
-- 			{ '<localleader>t', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', desc = 'Workspace symbols' },
-- 			{ '<localleader>v', '<cmd>Telescope registers<CR>', desc = 'Registers' },
-- 			{ '<localleader>u', '<cmd>Telescope spell_suggest<CR>', desc = 'Spell suggest' },
-- 			{ '<localleader>s', '<cmd>Telescope persisted<CR>', desc = 'Sessions' },
-- 			{ '<localleader>x', '<cmd>Telescope frecency<CR>', desc = 'Frecency' },
-- 			{ '<localleader>;', '<cmd>Telescope command_history<CR>', desc = 'Command history' },
-- 			{ '<localleader>:', '<cmd>Telescope commands<CR>', desc = 'Commands' },
-- 			{ '<localleader>/', '<cmd>Telescope search_history<CR>', desc = 'Search history' },
-- 			{ '<leader>/', '<cmd>Telescope current_buffer_fuzzy_find<CR>', desc = 'Buffer find' },
--
-- 			{ '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<CR>', desc = 'Document diagnostics' },
-- 			{ '<leader>sD', '<cmd>Telescope diagnostics<CR>', desc = 'Workspace diagnostics' },
-- 			{ '<leader>sh', '<cmd>Telescope help_tags<CR>', desc = 'Help Pages' },
-- 			{ '<leader>sk', '<cmd>Telescope keymaps<CR>', desc = 'Key Maps' },
-- 			{ '<leader>sm', '<cmd>Telescope man_pages<CR>', desc = 'Man Pages' },
-- 			{ '<leader>sw', '<cmd>Telescope grep_string<CR>', desc = 'Word' },
-- 			{ '<leader>sc', '<cmd>Telescope colorscheme<CR>', desc = 'Colorscheme' },
-- 			{ '<leader>uC', '<cmd>Telescope colorscheme<CR>', desc = 'Colorscheme' },
--
-- 			-- LSP related
-- 			{ '<localleader>dd', '<cmd>Telescope lsp_definitions<CR>', desc = 'Definitions' },
-- 			{ '<localleader>di', '<cmd>Telescope lsp_implementations<CR>', desc = 'Implementations' },
-- 			{ '<localleader>dr', '<cmd>Telescope lsp_references<CR>', desc = 'References' },
-- 			{ '<localleader>da', '<cmd>Telescope lsp_code_actions<CR>', desc = 'Code actions' },
-- 			{ '<localleader>da', ':Telescope lsp_range_code_actions<CR>', mode = 'x', desc = 'Code actions' },
-- 			{
-- 				'<leader>ss',
-- 				function()
-- 					require('telescope.builtin').lsp_document_symbols({
-- 						symbols = {
-- 							'Class',
-- 							'Function',
-- 							'Method',
-- 							'Constructor',
-- 							'Interface',
-- 							'Module',
-- 							'Struct',
-- 							'Trait',
-- 							'Field',
-- 							'Property',
-- 						},
-- 					})
-- 				end,
-- 				desc = 'Goto Symbol',
-- 			},
-- 			{
-- 				'<leader>sS',
-- 				function()
-- 					require('telescope.builtin').lsp_dynamic_workspace_symbols({
-- 						symbols = {
-- 							'Class',
-- 							'Function',
-- 							'Method',
-- 							'Constructor',
-- 							'Interface',
-- 							'Module',
-- 							'Struct',
-- 							'Trait',
-- 							'Field',
-- 							'Property',
-- 						},
-- 					})
-- 				end,
-- 				desc = 'Goto Symbol (Workspace)',
-- 			},
--
-- 			-- Git
-- 			{ '<leader>gs', '<cmd>Telescope git_status<CR>', desc = 'Git status' },
-- 			{ '<leader>gr', '<cmd>Telescope git_branches<CR>', desc = 'Git branches' },
-- 			{ '<leader>gl', '<cmd>Telescope git_commits<CR>', desc = 'Git commits' },
-- 			{ '<leader>gL', '<cmd>Telescope git_bcommits<CR>', desc = 'Git buffer commits' },
-- 			{ '<leader>gh', '<cmd>Telescope git_stash<CR>', desc = 'Git stashes' },
--
-- 			-- Plugins
-- 			{ '<localleader>n', plugin_directories, desc = 'Plugins' },
-- 			{ '<localleader>k', '<cmd>Telescope thesaurus lookup<CR>', desc = 'Thesaurus' },
-- 			{ '<localleader>w', '<cmd>ZkNotes<CR>', desc = 'Zk notes' },
--
-- 			{
-- 				'<localleader>z',
-- 				function()
-- 					require('telescope').extensions.zoxide.list({
-- 						layout_config = { width = 0.5, height = 0.6 },
-- 					})
-- 				end,
-- 				desc = 'Zoxide (MRU)',
-- 			},
--
-- 			-- Find by...
-- 			{
-- 				'<leader>gt',
-- 				function()
-- 					require('telescope.builtin').lsp_workspace_symbols({
-- 						default_text = vim.fn.expand('<cword>'),
-- 					})
-- 				end,
-- 				desc = 'Find symbol',
-- 			},
-- 			{
-- 				'<leader>gf',
-- 				function()
-- 					require('telescope.builtin').find_files({
-- 						default_text = vim.fn.expand('<cword>'),
-- 					})
-- 				end,
-- 				desc = 'Find file',
-- 			},
-- 			{
-- 				'<leader>gg', function()
-- 					require('telescope.builtin').live_grep({
-- 						default_text = vim.fn.expand('<cword>'),
-- 					})
-- 				end,
-- 				desc = 'Grep cursor word',
-- 			},
-- 			{
-- 				'<leader>gg',
-- 				function()
-- 					require('telescope.builtin').live_grep({
-- 						default_text = require('meg.lib.edit').get_visual_selection(),
-- 					})
-- 				end,
-- 				mode = 'x',
-- 				desc = 'Grep cursor word',
-- 			},
--
-- 		},
-- 		opts = function()
-- 			local transform_mod = require('telescope.actions.mt').transform_mod
-- 			local actions = require('telescope.actions')
--
-- 			-- Transform to Telescope proper actions.
-- 			myactions = transform_mod(myactions)
--
-- 			-- Clone the default Telescope configuration and enable hidden files.
-- 			local has_ripgrep = vim.fn.executable('rg') == 1
-- 			local vimgrep_args = {
-- 				unpack(require('telescope.config').values.vimgrep_arguments)
-- 			}
-- 			table.insert(vimgrep_args, '--hidden')
-- 			table.insert(vimgrep_args, '--follow')
-- 			table.insert(vimgrep_args, '--no-ignore-vcs')
-- 			table.insert(vimgrep_args, '--glob')
-- 			table.insert(vimgrep_args, '!**/.git/*')
--
-- 			local find_args = {
-- 				'rg',
-- 				'--vimgrep',
-- 				'--files',
-- 				'--follow',
-- 				'--hidden',
-- 				'--no-ignore-vcs',
-- 				'--smart-case',
-- 				'--glob',
-- 				'!**/.git/*',
-- 			}
--
-- 			return {
-- 			defaults = {
-- 				sorting_strategy = 'ascending',
-- 				cache_picker = { num_pickers = 3 },
--
-- 				prompt_prefix = '  ',  -- ❯  
-- 				selection_caret = '▍ ',
-- 				multi_icon = ' ',
--
-- 				path_display = { 'truncate' },
-- 				file_ignore_patterns = { 'node_modules' },
-- 				set_env = { COLORTERM = 'truecolor' },
-- 				vimgrep_arguments = has_ripgrep and vimgrep_args or nil,
--
-- 				layout_strategy = 'horizontal',
-- 				layout_config = {
-- 					prompt_position = 'top',
-- 					horizontal = {
-- 						height = 0.85,
-- 					},
-- 				},
--
-- 				mappings = {
--
-- 					i = {
-- 						['jj'] = { '<Esc>', type = 'command' },
--
-- 						['<Tab>'] = actions.move_selection_worse,
-- 						['<S-Tab>'] = actions.move_selection_better,
-- 						['<C-u>'] = actions.results_scrolling_up,
-- 						['<C-d>'] = actions.results_scrolling_down,
--
-- 						['<C-q>'] = myactions.smart_send_to_qflist,
--
-- 						['<C-n>'] = actions.cycle_history_next,
-- 						['<C-p>'] = actions.cycle_history_prev,
--
-- 						['<C-b>'] = actions.preview_scrolling_up,
-- 						['<C-f>'] = actions.preview_scrolling_down,
-- 					},
--
-- 					n = {
-- 						['q']     = actions.close,
-- 						['<Esc>'] = actions.close,
--
-- 						['<Tab>'] = actions.move_selection_worse,
-- 						['<S-Tab>'] = actions.move_selection_better,
-- 						['<C-u>'] = myactions.results_scrolling_up,
-- 						['<C-d>'] = myactions.results_scrolling_down,
--
-- 						['<C-b>'] = actions.preview_scrolling_up,
-- 						['<C-f>'] = actions.preview_scrolling_down,
--
-- 						['<C-n>'] = actions.cycle_history_next,
-- 						['<C-p>'] = actions.cycle_history_prev,
--
-- 						['*'] = actions.toggle_all,
-- 						['u'] = actions.drop_all,
-- 						['J'] = actions.toggle_selection + actions.move_selection_next,
-- 						['K'] = actions.toggle_selection + actions.move_selection_previous,
-- 						[' '] = {
-- 							actions.toggle_selection + actions.move_selection_next,
-- 							type = 'action',
-- 							opts = { nowait = true },
-- 						},
--
-- 						['sv'] = actions.select_horizontal,
-- 						['sg'] = actions.select_vertical,
-- 						['st'] = actions.select_tab,
--
-- 						['w'] = myactions.smart_send_to_qflist,
-- 						['e'] = myactions.send_to_qflist,
--
-- 						['!'] = actions.edit_command_line,
--
-- 						['t'] = function(...)
-- 							return require('trouble.providers.telescope').open_with_trouble(...)
-- 						end,
--
-- 						['p'] = function()
-- 							local entry = require('telescope.actions.state').get_selected_entry()
-- 							require('meg.lib.preview').open(entry.path)
-- 						end,
-- 					},
--
-- 				},
-- 			},
-- 			pickers = {
-- 				buffers = {
-- 					sort_lastused = true,
-- 					sort_mru = true,
-- 					show_all_buffers = true,
-- 					ignore_current_buffer = true,
-- 					layout_config = { width = width_large, height = 0.7 },
-- 					mappings = {
-- 						n = {
-- 							['dd'] = actions.delete_buffer,
-- 						}
-- 					}
-- 				},
-- 				find_files = {
-- 					find_command = has_ripgrep and find_args or nil,
-- 				},
-- 				live_grep = {
-- 					dynamic_preview_title = true,
-- 				},
-- 				colorscheme = {
-- 					enable_preview = true,
-- 					layout_config = { preview_width = 0.7 },
-- 				},
-- 				highlights = {
-- 					layout_config = { preview_width = 0.7 },
-- 				},
-- 				vim_options = {
-- 					theme = 'dropdown',
-- 					layout_config = { width = width_medium, height = 0.7 },
-- 				},
-- 				command_history = {
-- 					theme = 'dropdown',
-- 					layout_config = { width = width_medium, height = 0.7 },
-- 				},
-- 				search_history = {
-- 					theme = 'dropdown',
-- 					layout_config = { width = width_small, height = 0.6 },
-- 				},
-- 				spell_suggest = {
-- 					theme = 'cursor',
-- 					layout_config = { width = width_tiny, height = 0.45 },
-- 				},
-- 				registers = {
-- 					theme = 'cursor',
-- 					layout_config = { width = 0.35, height = 0.4 },
-- 				},
-- 				oldfiles = {
-- 					theme = 'dropdown',
-- 					previewer = false,
-- 					layout_config = { width = width_medium, height = 0.7 },
-- 				},
-- 				lsp_definitions = {
-- 					layout_config = { width = width_large, preview_width = 0.55 },
-- 				},
-- 				lsp_implementations = {
-- 					layout_config = { width = width_large, preview_width = 0.55 },
-- 				},
-- 				lsp_references = {
-- 					layout_config = { width = width_large, preview_width = 0.55 },
-- 				},
-- 				lsp_code_actions = {
-- 					theme = 'cursor',
-- 					previewer = false,
-- 					layout_config = { width = 0.3, height = 0.4 },
-- 				},
-- 				lsp_range_code_actions = {
-- 					theme = 'cursor',
-- 					previewer = false,
-- 					layout_config = { width = 0.3, height = 0.4 },
-- 				},
-- 			},
-- 			extensions = {
-- 				persisted = {
-- 					layout_config = { width = 0.55, height = 0.55 },
-- 				},
-- 				zoxide = {
-- 					prompt_title = '[ Zoxide directories ]',
-- 					mappings = {
-- 						default = {
-- 							action = function(selection)
-- 								vim.defer_fn(function() vim.cmd.lcd(selection.path) end, 300)
-- 							end,
-- 							after_action = function(selection)
-- 								vim.notify(
-- 									"Current working directory set to '".. selection.path .."'",
-- 									vim.log.levels.INFO
-- 								)
-- 							end
-- 						},
-- 					},
-- 				},
-- 			}
-- 		}
-- 		end
-- 	},
--
-- }
