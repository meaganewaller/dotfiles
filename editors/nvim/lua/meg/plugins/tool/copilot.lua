return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = 'InsertEnter',
    build = ':Copilot auth',
    config = function()
      require('copilot').setup({
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = true,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          go = false,
          rust = false,
          elixir = false,
          ["."] = true,
        },
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-e>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
      })
    end
  },
  {
    "nvim-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        event = "VeryLazy",
        dependencies = { "copilot.lua" },
        opts = {},
        config = function(_, opts)
          local copilot_cmp = require("copilot_cmp")
          copilot_cmp.setup(opts)
          require("meg.utils").on_attach(function(client)
            if client.name == 'copilot' then
          copilot_cmp._on_insert_enter({})
            end
          end)
        end,
      },
    },
    opts = function(_, opts)
      local cmp = require('cmp')
      table.insert(opts, { sources = { name = 'copilot', group_index = 2 } })

      opts.sorting = {
        priority_weight = 2,
        comparators = {
          require('copilot_cmp.comparators').prioritize,
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      }
    end,
  }
}
