return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      "plenary.nvim",
      "telescope-undo.nvim",
      "telescope-live-grep-args.nvim",
      "telescope-fzf-native.nvim",
    },
    config = function() require("configs.telescope") end,
    keys = {
      { "<Leader>,", "<cmd>Telescope buffers show_all_buffers=true<Cr>", desc = "Switch Buffer" },
      { "<Leader>/", "<cmd>Telescope live_grep<CR>", desc = "Grep (root dir)" },
      { "<Leader>:", "<cmd>Telescope command_history<CR>", desc = "Command History" },
      {
        "<Leader><Leader>",
        "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
        desc = "Find files",
      },

      { '<Leader>f"', "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<Leader>fa", "<cmd>Telescope autocommands<CR>", desc = "Autocmds" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<Leader>fC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fF", "<cmd>Telescope find_files cwd=false<CR>", desc = "Find Files (cwd)" },
      { "<Leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<Leader>fG", "<cmd>GrepAppInput<CR>", desc = "Web Grep" },
      { "<Leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
      { "<Leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<Leader>fl", "<cmd>Telescope resume<cr>", desc = "Last search" },
      { "<Leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Man pages" },
      { "<Leader>fn", "<cmd>Telescope notify<CR>", desc = "Notifications" },
      { "<Leader>fr", "<cmd>Telescope oldfiles theme=dropdown previewer=false<cr>", desc = "Recent files" },
      {
        "<Leader>fR",
        "<cmd>Telescope oldfiles theme=dropdown previewer=false cwd=vim.loop.cwd()<CR>",
        desc = "Recent files (cwd)",
      },
      { "<Leader>fy", "<cmd>Telescope yank_history<cr>", desc = "Yank History" },

      { "<Leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Checkout branch" },
      { "<Leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
      { "<Leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },

      { "<Leader>ld", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Buffer diagnostics" },
      { "<Leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
      { "<Leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Workspace symbols" },
    },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    lazy = true,
    dependencies = { "plenary.nvim", "telescope.nvim" },
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    lazy = true,
    dependencies = { "plenary.nvim", "telescope.nvim" },
  },
  {
    "debugloop/telescope-undo.nvim",
    lazy = true,
    dependencies = { "plenary.nvim", "telescope.nvim" },
  },
  {
    "willothy/flatten.nvim",
    event = "BufReadPre",
    config = function() require("configs.flatten") end,
  },
  {
    "akinsho/toggleterm.nvim",
    -- stylua: ignore start
    keys = {
      {
        "<A-i>",
        "<Cmd>ToggleTerm direction=float<CR>",
        mode = { "n", "t" },
        desc = "terminal: Toggle floating",
      },
      {
        "<A-v>",
        "<Cmd>ToggleTerm direction=vertical<CR>",
        mode = { "n", "t" },
        desc = "terminal: Toggle vertical",
      },
      {
        "<A-h>",
        "<Cmd>ToggleTerm direction=horizontal<CR>",
        mode = { "n", "t" },
        desc = "terminal: Toggle horizontal",
      },
      {
        "<A-g>",
        "<Cmd>Lazygit<CR>",
        mode = { "n", "t" },
        desc = "terminal: Toggle LazyGit",
      },
    },
    -- stylua: ignore end
    cmd = {
      "Lazygit",
      "TermExec",
      "ToggleTerm",
      "ToggleTermSetName",
      "ToggleTermToggleAll",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualLines",
      "ToggleTermSendVisualSelection",
    },
    config = function() require("configs.toggleterm") end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    dependencies = "plenary.nvim",
    keys = {
      { "]g", "<Cmd>Gitsigns next_hunk<CR>", desc = "git: Next hunk" },
      { "[g", "<Cmd>Gitsigns prev_hunk<CR>", desc = "git: Previous hunk" },
      {
        "<Leader>gl",
        "<Cmd>Gitsigns blame_line<CR>",
        desc = "git: View blame",
      },
      {
        "<Leader>gL",
        function() require("gitsigns").blame_line({ full = true }) end,
        desc = "git: View full blame",
      },
      {
        "<Leader>gp",
        "<Cmd>Gitsigns preview_hunk<CR>",
        desc = "git: Preview hunk",
      },
      {
        "<Leader>gs",
        "<Cmd>Gitsigns stage_hunk<CR>",
        desc = "git: Stage hunk",
      },
      {
        "<Leader>gh",
        "<Cmd>Gitsigns reset_hunk<CR>",
        desc = "git: Reset hunk",
      },
      {
        "<Leader>gS",
        "<Cmd>Gitsigns stage_buffer<CR>",
        desc = "git: Stage buffer",
      },
      {
        "<Leader>gr",
        "<Cmd>Gitsigns reset_buffer<CR>",
        desc = "git: Reset buffer",
      },
      {
        "<Leader>gu",
        "<Cmd>Gitsigns undo_stage_hunk<CR>",
        desc = "git: Undo stage hunk",
      },
      { "<Leader>gd", "<Cmd>Gitsigns diffthis<CR>", desc = "git: View diff" },
      {
        "ah",
        ":<C-u>Gitsigns select_hunk<CR>",
        mode = "v",
        desc = "git: Select hunk",
      },
    },
    config = function() require("configs.gitsigns") end,
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoLocList", "TodoQuickFix", "TodoTelescope" },
    event = "VeryLazy",
    dependencies = "plenary.nvim",
    config = function() require("configs.todo-comments") end,
    keys = {
      { "<Leader>ft", "<Cmd>TodoTelescope<CR>", desc = "find: Todos" },
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Gcd",
      "Gclog",
      "Gdiffsplit",
      "Gdrop",
      "Gedit",
      "Ggrep",
      "Git",
      "Glcd",
      "Glgrep",
      "Gllog",
      "Gpedit",
      "Gread",
      "Gsplit",
      "Gtabedit",
      "Gvdiffsplit",
      "Gvsplit",
      "Gwq",
      "Gwrite",
    },
    event = { "BufWritePost", "BufReadPre" },
    config = function() require("configs.vim-fugitive") end,
  },
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    config = function() require("configs.git-conflict") end,
  },
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    commands = { "Oil" },
    config = function() require("configs.oil") end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "Exafunction/codeium.vim",
    init = function()
      vim.keymap.set(
        "i",
        "<c-.>",
        function() return vim.fn["codeium#CycleCompletions"](1) end,
        { expr = true, desc = "Codeium: Go to next completion" }
      )
      vim.keymap.set(
        "i",
        "<c-,>",
        function() return vim.fn["codeium#CycleCompletions"](-1) end,
        { expr = true, desc = "Codeium: Go to previous completion" }
      )
      vim.keymap.set(
        "i",
        "<c-x>",
        function() return vim.fn["codeium#Clear"]() end,
        { expr = true, desc = "Codeium: Clear current completion" }
      )
      vim.keymap.set(
        "i",
        "<c-cr>",
        function() return vim.fn["codeium#Accept"]() end,
        { expr = true, desc = "Codeium: Accept current completion" }
      )
    end,
  },
  {
    "linty-org/key-menu.nvim",
    event = "VeryLazy",
    config = function() require("configs.key-menu") end,
  },
  {
    "toppair/reach.nvim",
    config = function() require("configs.reach") end,
  },
  {
    "stevearc/resession.nvim",
    lazy = true,
    opts = {
      extensions = {
        overseer = {
          status = { "RUNNING" },
        },
      },
    },
  },
  {
    "stevearc/overseer.nvim",
    cmd = {
      "Grep",
      "Make",
      "OverseerDebugParser",
      "OverseerInfo",
      "OverseerOpen",
      "OverseerRun",
      "OverseerRunCmd",
      "OverseerToggle",
    },
    keys = {
      { "<leader>oo", "<cmd>OverseerToggle<CR>", mode = "n", desc = "[overseer] Toggle" },
      { "<leader>or", "<cmd>OverseerRun<CR>", mode = "n", desc = "[overseer] Run" },
      { "<leader>oc", "<cmd>OverseerRunCmd<CR>", mode = "n", desc = "[overseer] Run Command" },
      { "<leader>ol", "<cmd>OverseerLoadBundle<CR>", mode = "n", desc = "[overseer] Load Bundle" },
      { "<leader>ob", "<cmd>OverseerToggle! bottom<CR>", mode = "n", desc = "[overseer] Toggle bottom" },
      { "<leader>od", "<cmd>OverseerQuickAction<CR>", mode = "n", desc = "[overseer] Quick action" },
      { "<leader>os", "<cmd>OverseerTaskAction<CR>", mode = "n", desc = "[overseer] Task action" },
    },
    config = function() require("configs.overseer") end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
    },
    config = true,
  },
  { "rhysd/committia.vim" },
}
