return {
  { "windwp/nvim-ts-autotag", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "JoosepAlviste/nvim-ts-context-commentstring", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "HiPhish/nvim-ts-rainbow2", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "nvim-treesitter/playground", dependencies = "nvim-treesitter/nvim-treesitter" },
  {
    "mizlan/iswap.nvim",
    event = "VeryLazy",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("iswap").setup()
      nx.map({ { "<F3>", "<cmd>ISwap<CR>", desc = "Swap Function Arguments" }})
    end,
  },
  {
    "aarondiel/spread.nvim",
    event = "VeryLazy",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      local spread = require("spread")
      nx.map({
        { "<F5>", spread.out, silent = true, desc = "Spread Out" },
        { { "<S-F5>", "<F17>" }, spread.combine, silent = true, desc = "Spread Combine" },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- PERF: no need to load the plugin, if we only need its queries for mini.ai
          local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
          local opts = require("lazy.core.plugin").values(plugin, "opts", false)
          local enabled = false
          if opts.textobjects then
            for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
              if opts.textobjects[mod] and opts.textobjects[mod].enable then
                enabled = true
                break
              end
            end
          end
          if not enabled then
            require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          end
        end,
      },
    },
    keys = {
      { "<C-Space>", desc = "Increment selection" },
      { "<BS>", desc = "Decrement selection", mode = "x" },
    },
    ---@type TSConfig
    opts = {
      highlight = {
        enable = true,
        disable = { "css", "html", "help" },
        additional_vim_regex_highlighting = false,
      },
      autopairs = {
        enable = true,
      },
      indent = {
        enable = true,
        disable = { "yaml", "python", "css" }
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      autotag = {
        enable = true,
        disable = { "xml" },
      },
      rainbow = {
        enable = true,
        query = 'rainbow-parens',
      },
      disable = { "html" },
      playground = {
        enable = true,
      },
      matchup = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {},
      },
      ensure_installed = {
        "bash",
        "c",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "ruby",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      local ts_configs = require("nvim-treesitter.configs")

      opts.incremental_selection.keymaps = {
        init_selection = "<CR>",
        scope_incremental = "<C-CR>",
        node_incremental = "<CR>",
        node_decremental = "<BS>",
      }

      nx.map({
        { "<leader>Th", "<Cmd>TSHighlightCapturesUnderCursor<CR>", desc = "Highlight" },
        { "<leader>Tp", "<Cmd>TSPlaygroundToggle<CR>", desc = "Playground" },
        -- stylua: ignore
        { "<F8>", "<Cmd>TSHighlightCapturesUnderCursor<CR>", desc = "Show TS Highlight Information for Element Under Cursor" },
        { { "<S-F8>", "<F20>" }, "<Cmd>TSPlaygroundToggle<CR>", desc = "Toggle Treesitter Playground" },
      })
      ts_configs.setup(opts)
    end,
  },
}
