return {
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    -- config = function() require("configs.nvim-cmp") end,
    dependencies = {
      "LuaSnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(_, item)
            local icons = require("settings").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
  },

  {
    "hrsh7th/cmp-calc",
    event = "InsertEnter",
    dependencies = "nvim-cmp",
  },

  {
    "hrsh7th/cmp-cmdline",
    event = "CmdlineEnter",
    dependencies = "nvim-cmp",
  },

  {
    "hrsh7th/cmp-nvim-lsp",
    event = "InsertEnter",
    dependencies = { "nvim-cmp", "nvim-lspconfig" },
  },

  {
    "hrsh7th/cmp-nvim-lsp-signature-help",
    event = "InsertEnter",
    dependencies = { "nvim-cmp", "nvim-lspconfig" },
  },

  {
    "hrsh7th/cmp-path",
    event = { "CmdlineEnter", "InsertEnter" },
    dependencies = "nvim-cmp",
  },

  {
    "hrsh7th/cmp-buffer",
    event = { "CmdlineEnter", "InsertEnter" },
    dependencies = "nvim-cmp",
  },

  {
    "rcarriga/cmp-dap",
    lazy = true,
    dependencies = { "nvim-dap", "nvim-cmp" },
  },

  {
    "saadparwaiz1/cmp_luasnip",
    event = "InsertEnter",
    dependencies = { "nvim-cmp", "LuaSnip" },
  },

  {
    "zbirenbaum/copilot-cmp",
    dependencies = "copilot.lua",
    opts = {},
    config = function(_, opts)
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    -- config = function() require("configs.LuaSnip") end,
    dependencies = {
      {"rafamadriz/friendly-snippets", config = function() require("luasnip.loaders.from_vscode").lazy_load() end },
      "fivethree-team/vscode-svelte-snippets",
      {
        "dsznajder/vscode-es7-javascript-react-snippets",
        build = "yarn install --frozen-lockfile && yarn compile",
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    keys = {
      {
        "<Tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<Tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<S-Tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
}
