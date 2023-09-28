return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope", "FZF" },
    keys = {
      { "<Leader>f", "<Cmd>Telescope builtin<CR>", desc = "find: Finders" },
      { "<Leader>F", "<Cmd>Telescope builtin<CR>", desc = "find: Finder" },
      { "<Leader>ff", "<Cmd>Telescope find_files<CR>", desc = "find: Files" },
      {
        "<Leader>fo",
        "<Cmd>Telescope oldfiles<CR>",
        desc = "find: Recent files",
      },
      { "<Leader>fw", "<Cmd>Telescope live_grep<CR>", desc = "find: Words" },
      { "<Leader>fb", "<Cmd>Telescope buffers<CR>", desc = "find: Buffers" },
      {
        "<Leader>fk",
        "<Cmd>Telescope keymaps<CR>",
        desc = "find: Key-mappings",
      },
      {
        "<Leader>fh",
        "<Cmd>Telescope help_tags<CR>",
        desc = "find: Help pages",
      },
      {
        "<Leader>fc",
        "<Cmd>Telescope colorscheme<CR>",
        desc = "find: Color-Schemes",
      },
      {
        "<Leader>fg",
        "<Cmd>Telescope git_status<CR>",
        desc = "find: Git status",
      },
      {
        "<Leader>fe",
        "<Cmd>Telescope diagnostics<CR>",
        desc = "find: Diagnostics",
      },
      {
        "<Leader>fr",
        "<Cmd>Telescope lsp_references<CR>",
        desc = "find: LSP references",
      },
      {
        "<Leader>fd",
        "<Cmd>Telescope lsp_definitions<CR>",
        desc = "find: LSP definitions",
      },
      {
        "<Leader>fs",
        "<Cmd>Telescope lsp_document_symbols<CR>",
        desc = "find: LSP document symbols",
      },
      { "<Leader>fu", "<Cmd>Telescope undo<CR>", desc = "find: Undoes" },
      {
        "<Leader>fn",
        "<Cmd>Telescope notify<CR>",
        desc = "find: Notifications",
      },
    },
    dependencies = {
      "plenary.nvim",
      "telescope-fzf-native.nvim",
      "telescope-undo.nvim",
    },
    config = function() require("configs.telescope") end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
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
    config = function() require("configs.oil") end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function() vim.keymap.set("n", "-", "<Cmd>Oil<CR>", { desc = "Open parent directory" }) end,
  },
  {
    "ekickx/clipboard-image.nvim",
    ft = "markdown",
    init = function() vim.keymap.set("n", "<Leader>mp", "<cmd>PasteImg<CR>") end,
    config = function() require("configs.clipboard-image") end,
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
}
