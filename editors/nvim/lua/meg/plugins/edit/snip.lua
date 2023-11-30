return {
  { "rafamadriz/friendly-snippets", event = "VeryLazy" },
  {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    config = function()
      local snip = require "luasnip"
      snip.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
      })
      local vsc = require("luasnip.loaders.from_vscode")

      snip.filetype_extend("javascript", { "html" })
      snip.filetype_extend("javascriptreact", { "html" })
      snip.filetype_extend("typescript", { "html" })
      snip.filetype_extend("typescriptreact", { "html" })

      vsc.lazy_load()

      local map = require("meg.utils").map

      map({ "i", "s" }, "<c-n>", function()
        if snip.expand_or_jumpable() then
          snip.expand_or_jump()
        end
      end, "Expand current snippet or jump to next", { silent = true })

      map({ "i", "s" }, "<c-p>", function()
        if snip.jumpable(-1) then
          snip.jump(-1)
        end
      end, "Jump to previous snippet", { silent = true })

      map("i", "<c-l>", function()
        if snip.choice_active() then
          snip.change_choice(1)
        end
      end, "Show list of options")

      require("luasnip.loaders.from_lua").lazy_load {
        paths = vim.fn.stdpath "config" .. "/lua/snippets",
      }
    end,
  },
}
