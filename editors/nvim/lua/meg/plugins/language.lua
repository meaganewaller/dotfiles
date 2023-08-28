local function setup_treesitter()
  local function starts_with(str, start) return str:sub(1, #start) == start end

  local function treesitter_selection_mode(info)
    -- * query_string: eg '@function.inner'
    -- * method: eg 'v' or 'o'
    --print(info['method'])		-- visual, operator-pending
    if starts_with(info["query_string"], "@function.") then return "V" end
    return "v"
  end

  local textobjects = require("meg.plugins.language").textobjects

  require("nvim-treesitter.configs").setup({
    sync_install = false,
    ensure_installed = {
      "bash",
      "go",
      "html",
      "prisma",
      "http",
      "javascript",
      "kdl",
      "json",
      "rasi",
      "yuck",
      "lua",
      "markdown",
      "markdown_inline",
      "norg",
      "org",
      "python",
      "query",
      "regex",
      "ruby",
      "rust",
      "tsx",
      "typescript",
      "vim",
      "vue",
      "hjson",
      "yaml",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    -- matchup = {
    --   enable = true, -- mandatory, false will disable the whole extension
    -- },
    autotag = { enable = true },
    rainbow = {
      enable = false,
      -- disable = { "jsx", "cpp", "tsx", "typescript", "javascript", "vue" }, -- list of languages you want to disable the plugin for
      -- extended_mode = true,                                                 -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      -- max_file_lines = nil,                                                 -- Do not enable for files with more than n lines, int
      -- colors = {}, -- table of hex strings
      -- termcolors = {} -- table of colour name strings
    },
    autopairs = { enable = true },
    indent = { enable = true },
    textobjects = textobjects,
    textsubjects = {
      enable = false,
      prev_selection = ",", -- (Optional) keymap to select the previous selection
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-container-outer",
        ["i;"] = "textsubjects-container-inner",
      },
    },
    refactor = {},
    endwise = {
      enable = false,
    },
    context_commentstring = { enable = true },
  })
end

local function setup_cmp()
  local cmp = require("cmp")
  local handle = require("meg.language.completion")
  local lspkind = require("lspkind")

  local options = require("meg.nvim.options")
  options.set(options.scope.option, "pumheight", 12)

  cmp.setup({
    completion = {
      completeopt = "menu,menuone,noinsert",
    },
    formatting = {
      format = lspkind.cmp_format({
        mode = "symbol_text",
        menu = {
          buffer = "[Buffer]",
          luasnip = "[LuaSnip]",
          nvim_lsp = "[LSP]",
          nvim_lua = "[Lua]",
          copilot = "[Copilot]",
        },
      }),
    },
    -- TODO: Refactor mapping into mappings.lua
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      }),
      ["<Tab>"] = cmp.mapping(handle.jump_next, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(handle.jump_previous, { "i", "s" }),
    },
    snippet = {
      expand = function(args) require("luasnip").lsp_expand(args.body) end,
    },
    sources = {
      { name = "copilot" },
      { name = "luasnip" },
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "path" },
      { name = "buffer" },
    },
  })
end

local function setup_luasnip()
  local luasnip = require("luasnip")

  luasnip.config.set_config({
    history = true,
  })

  require("luasnip/loaders/from_vscode").load()
end

local function setup_copilot()
  vim.defer_fn(function()
    require("copilot").setup()
    require("copilot_cmp").setup()
  end, 100)
end

local M = {
  {
    "nvim-treesitter/nvim-treesitter",
    config = function() setup_treesitter() end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "p00f/nvim-ts-rainbow",
    },
    build = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "hrsh7th/nvim-cmp",
    config = function() setup_cmp() end,
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      {
        "zbirenbaum/copilot-cmp",
        event = "InsertEnter",
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function() setup_copilot() end,
      },
    },
  },
  "saadparwaiz1/cmp_luasnip",
  {
    "L3MON4D3/LuaSnip",
    config = function() setup_luasnip() end,
  },
  "rafamadriz/friendly-snippets",
  "princejoogie/tailwind-highlight.nvim",
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  {
    "chrisgrieser/nvim-various-textobjs",
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      useDefaultKeymaps = true,
    },
    config = function()
      require("various-textobjs").setup({
        lookForwardSmall = 5,
        lookForwardBig = 15,
        useDefaultKeymaps = true,
        -- disabledKeymaps = { "ai", "ii", "aI", "iI" },
        disabledKeymaps = {
          "L",  -- vu
          "r",  -- ri
          "R",  -- rp
          "in", -- ir
          "il",
          "ai",
          "ii",
          -- "aI",
          -- "iI",
          "an", -- deprecated
        },
      })
    end,
  },
  {
    "glts/vim-textobj-comment",
    enabled = true,
    keys = {
      { "ic", mode = { "o", "x" }, desc = "Select comment block" },
      { "ac", mode = { "o", "x" }, desc = "Select comment block" },
    },
    -- https://github.com/kana/vim-textobj-user/wiki
    dependencies = { "kana/vim-textobj-user" },
  },
  {
    "wellle/targets.vim",
    event = { "BufReadPost", "BufNewFile" },
    enabled = true,
  },
}

M.textobjects = {
  select = {
    enable = true,

    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,

    keymaps = {
      -- You can use the capture groups defined in textobjects.scm
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      -- ["al"] = "@class.outer",
      -- ["il"] = { query = "@class.inner", desc = "Select inner part of a class region" }, -- You can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap) which plugins like which-key display
      -- ["ab"] = "@block.outer",
      -- ["ib"] = "@block.inner",
      ["al"] = "@conditional.outer",
      ["il"] = "@conditional.inner",
      ["ao"] = "@loop.outer",
      ["io"] = "@loop.inner",
      ["aa"] = "@parameter.outer",
      ["ia"] = "@parameter.inner",
      ["am"] = "@call.outer",
      ["im"] = "@call.inner",
      ["ir"] = "@number.inner",
      ["ag"] = "@assignment.outer",
      ["ig"] = "@assignment.inner",
      ["i,"] = "@assignment.lhs",
      ["i."] = "@assignment.rhs",
      -- ["ic"] = "@comment.outer",
      -- ["ac"] = "@comment.outer",
      --["afr"] = "@frame.outer",
      --["ifr"] = "@frame.inner",
      --["aat"] = "@attribute.outer",
      --["iat"] = "@attribute.inner",
      --["asc"] = "@scopename.inner",
      --["isc"] = "@scopename.inner",
      ["as"] = { query = "@scope", query_group = "locals" },
      ["is"] = "@statement.outer",
      -- ["ar"] = { query = "@start", query_group = "aerial" },
    },
    -- You can choose the select mode (default is charwise 'v')
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * method: eg 'v' or 'o'
    -- and should return the mode ('v', 'V', or '<c-v>') or a table
    -- mapping query_strings to modes.
    selection_modes = treesitter_selection_mode,
    -- selection_modes = { ["@function.outer"] = "V" },
    -- if you set this to `true` (default is `false`) then any textobject is
    -- extended to include preceding or succeeding whitespace. succeeding
    -- whitespace has priority in order to act similarly to eg the built-in
    -- `ap`.
    --
    -- can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * selection_mode: eg 'v'
    -- and should return true of false
    include_surrounding_whitespace = false,
  },
  swap = {
    enable = true,
    swap_next = {
      [")f"] = "@function.outer",
      [")c"] = "@comment.outer",
      [")a"] = "@parameter.inner",
      [")b"] = "@block.outer",
      [")l"] = "@class.outer",
      [")s"] = "@statement.outer",
    },
    swap_previous = {
      ["(f"] = "@function.outer",
      ["(c"] = "@comment.outer",
      ["(a"] = "@parameter.inner",
      ["(b"] = "@block.outer",
      ["(l"] = "@class.outer",
      ["(s"] = "@statement.outer",
    },
  },
  move = {
    enable = true,
    set_jumps = true, -- whether to set jumps in the jumplist
    goto_next_start = {
      ["]f"] = "@function.outer",
      ["]m"] = "@call.outer",
      ["]l"] = "@conditional.outer",
      ["]o"] = "@loop.outer",
      ["]s"] = "@statement.outer",
      ["]a"] = "@parameter.outer",
      ["]c"] = "@comment.outer",
      ["]b"] = "@block.outer",
      ["]r"] = "@number.inner",
      -- ["]l"] = { query = "@class.outer", desc = "next class start" },
      ["]]f"] = "@function.inner",
      ["]]m"] = "@call.inner",
      ["]]l"] = "@conditional.inner",
      ["]]o"] = "@loop.inner",
      ["]]a"] = "@parameter.inner",
      ["]]b"] = "@block.inner",
      -- ["]]l"] = { query = "@class.inner", desc = "next class start" },
    },
    goto_next_end = {
      ["]F"] = "@function.outer",
      ["]M"] = "@call.outer",
      ["]L"] = "@conditional.outer",
      ["]O"] = "@loop.outer",
      ["]S"] = "@statement.outer",
      ["]A"] = "@parameter.outer",
      ["]C"] = "@comment.outer",
      ["]B"] = "@block.outer",
      -- ["]L"] = "@class.outer",
      ["]R"] = "@number.inner",
      ["]]F"] = "@function.inner",
      ["]]M"] = "@call.inner",
      ["]]L"] = "@conditional.inner",
      ["]]O"] = "@loop.inner",
      ["]]A"] = "@parameter.inner",
      ["]]B"] = "@block.inner",
      -- ["]]L"] = "@class.inner",
    },
    goto_previous_start = {
      ["[f"] = "@function.outer",
      ["[m"] = "@call.outer",
      ["[l"] = "@conditional.outer",
      ["[o"] = "@loop.outer",
      ["[s"] = "@statement.outer",
      ["[a"] = "@parameter.outer",
      ["[c"] = "@comment.outer",
      ["[b"] = "@block.outer",
      -- ["[l"] = "@class.outer",
      ["[r"] = "@number.inner",
      ["[[f"] = "@function.inner",
      ["[[m"] = "@call.inner",
      ["[[l"] = "@conditional.inner",
      ["[[o"] = "@loop.inner",
      ["[[a"] = "@parameter.inner",
      ["[[b"] = "@block.inner",
      -- ["[[l"] = "@class.inner",
    },
    goto_previous_end = {
      ["[F"] = "@function.outer",
      ["[M"] = "@call.outer",
      ["[L"] = "@conditional.outer",
      ["[O"] = "@loop.outer",
      ["[S"] = "@statement.outer",
      ["[A"] = "@parameter.outer",
      ["[C"] = "@comment.outer",
      ["[B"] = "@block.outer",
      -- ["[L"] = "@class.outer",
      ["[R"] = "@number.inner",
      ["[[F"] = "@function.inner",
      ["[[M"] = "@call.inner",
      ["[[L"] = "@conditional.inner",
      ["[[O"] = "@loop.inner",
      ["[[A"] = "@parameter.inner",
      ["[[B"] = "@block.inner",
      -- ["[[L"] = "@class.inner",
    },
  },
  lsp_interop = {
    enable = true,
    floating_preview_opts = { border = "rounded" },
    peek_definition_code = {
      ["<C-t>"] = "@function.outer",
      ["<leader>df"] = "@function.outer",
      ["<leader>dF"] = "@class.outer",
    },
  },
}

return M
