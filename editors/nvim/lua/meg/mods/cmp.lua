return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          local snippet_path = vim.fn.stdpath("config") .. "/luasnippets/"
          if not vim.tbl_contains(vim.opt.rtp:get(), snippet_path) then
            vim.opt.rtp:append(snippet_path)
          end

          require("luasnip").config.set_config({
            history = true,
            update_events = "TextChanged,TextChangedI",
            delete_check_events = "TextChanged,InsertLeave",
          })
          require("luasnip.loaders.from_lua").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_snipmate").lazy_load()
        end,
      },
      { "lukas-reineke/cmp-under-comparator" },

      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "andersevenrud/cmp-tmux" },
      { "kdheepak/cmp-latex-symbols" },
      { "ray-x/cmp-treesitter" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-emoji" },
      { "f3fora/cmp-spell" },
      { "hrsh7th/cmp-cmdline", event = { "CmdlineEnter" } },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      { "lukas-reineke/cmp-rg" },
      { "davidsierradz/cmp-conventionalcommits" },
      -- { "dmitmel/cmp-cmdline-history"},
      -- { "kristijanhusak/vim-dadbod-completion"},
    },
    init = function()
      vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
    end,
    config = function()
      local cmp = require("cmp")

      local fmt = string.format
      local api = vim.api

      local ok_ls, ls = meg.require("luasnip")
      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      local border = function(hl)
        return {
          { "╭", hl },
          { "─", hl },
          { "╮", hl },
          { "│", hl },
          { "╯", hl },
          { "─", hl },
          { "╰", hl },
          { "│", hl },
        }
      end

      local compare = require("cmp.config.compare")
      compare.lsp_scores = function(entry1, entry2)
        local diff
        if entry1.completion_item.score and entry2.completion_item.score then
          diff = (entry2.completion_item.score * entry2.score) - (entry1.completion_item.score * entry1.score)
        else
          diff = entry2.score - entry1.score
        end
        return (diff < 0)
      end

      cmp.setup({
        window = {
          completion = {
            border = border("Normal"),
            max_width = 80,
            max_height = 20,
          },
          documentation = {
            border = border("CmpDocBorder"),
          },
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            require("copilot_cmp.comparators").prioritize,
            require("copilot_cmp.comparators").score,
            -- require("cmp_tabnine.compare"),
            compare.offset,
            compare.exact,
            compare.lsp_scores,
            require("cmp-under-comparator").under,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
          },
        },
        experimental = { ghost_text = {
          hl_group = "LspCodeLens",
        } },
        matching = {
          disallow_partial_fuzzy_matching = false,
        },
        enabled = function()
          if vim.bo.buftype == "prompt" or vim.g.started_by_firenvim then
            return false
          end

          return true
        end,
        preselect = cmp.PreselectMode.None,
        -- view = { entries = "custom" },
        completion = {
          keyword_length = 1,
          get_trigger_characters = function(trigger_characters)
            return vim.tbl_filter(function(char)
              return char ~= " "
            end, trigger_characters)
          end,
        },
        snippet = {
          expand = function(args)
            ls.lsp_expand(args.body)
          end,
        },
        -- window = {
        --   completion = {
        --     winhighlight = table.concat({
        --       "Normal:NormalFloat",
        --       "FloatBorder:TelescopePromptBorder",
        --       "CursorLine:Visual",
        --       "Search:None",
        --     }, ","),
        --     zindex = 1001,
        --     col_offset = 0,
        --     border = meg.get_border(),
        --     side_padding = 1,
        --   },
        --   documentation = cmp.config.window.bordered(cmp_window),
        -- },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-w>"] = cmp.mapping.close(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require("luasnip").expand_or_locally_jumpable() then
              vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"))
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
              vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        formatting = {
          deprecated = true,
          fields = { "abbr", "kind", "menu" },
          format = function(entry, item)
            if item.kind == "Color" and entry.completion_item.documentation then
              local _, _, r, g, b = string.find(entry.completion_item.documentation, "^rgb%((%d+), (%d+), (%d+)")
              if r then
                local color = string.format("%02x", r) .. string.format("%02x", g) .. string.format("%02x", b)
                local hl_group = "Tw_" .. color
                if vim.fn.hlID(hl_group) < 1 then
                  vim.api.nvim_set_hl(0, hl_group, { fg = "#" .. color })
                end
                item.kind = ""
                item.kind_hl_group = hl_group
              end
            else
              item.kind = fmt("%s %s", meg.icons.lsp.kind[item.kind], item.kind)
            end

            -- local max_length = 20
            local max_length = math.floor(vim.o.columns * 0.5)
            item.abbr = #item.abbr >= max_length and string.sub(item.abbr, 1, max_length) .. meg.icons.misc.ellipsis
              or item.abbr

            if entry.source.name == "nvim_lsp" then
              item.menu = entry.source.source.client.name
            else
              item.menu = ({
                nvim_lsp = "[lsp]",
                luasnip = "[lsnip]",
                nvim_lua = "[nlua]",
                nvim_lsp_signature_help = "[sig]",
                path = "[path]",
                -- rg = "[rg]",
                buffer = "[buf]",
                spell = "[spl]",
                neorg = "[neorg]",
                cmdline = "[cmd]",
                cmdline_history = "[cmdhist]",
                emoji = "[emo]",
              })[entry.source.name] or entry.source.name
            end

            return item
          end,
        },
        sources = cmp.config.sources({
          -- { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          {
            name = "treesitter",
            entry_filter = function(entry)
              local ignore_list = {
                "Error",
                "Comment",
              }
              local kind = entry:get_completion_item().cmp.kind_text
              return not vim.tbl_contains(ignore_list, kind)
            end,
          },
          { name = "spell" },
          { name = "tmux" },
          { name = "orgmode" },
          { name = "buffer" },
          { name = "latex_symbols" },
          { name = "copilot" },
          { name = "path", option = { trailing_slash = true } },
        }, {
          {
            name = "buffer",
            keyword_length = 4,
            max_item_count = 5, -- only show up to 5 items.
            options = {
              get_bufnrs = function()
                return vim.tbl_map(vim.api.nvim_win_get_buf, vim.api.nvim_list_wins())
              end,
            },
          },
          { name = "spell" },
        }),
      })

      cmp.setup.cmdline({ "/", "?" }, {
        -- view = {
        --   entries = { name = "custom", direction = "bottom_up" },
        -- },
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          sources = cmp.config.sources({ { name = "nvim_lsp_document_symbol" } }, { { name = "buffer" } }),
        },
      })

      cmp.setup.cmdline(":", {
        sources = cmp.config.sources({
          { name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=] },
          { name = "path" },
          -- { name = "cmdline_history", priority = 10, max_item_count = 3 },
        }),
      })

      cmp.setup.filetype({ "gitcommit", "NeogitCommitMessage" }, {
        sources = {
          { name = "conventionalcommits" },
          { name = "path" },
        },
        { name = "buffer" },
      })

      -- cmp.setup.filetype({"lua"}, {
      --   sources = {
      --     { name = "luasnip" },
      --     { name = "nvim_lua" },
      --     { name = "nvim_lsp" },
      --     { name = "path" },
      --   },
      --   { name = "buffer" },
      -- })

      -- cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
      --   sources = {
      --     { name = "vim-dadbod-completion" },
      --   },
      -- })

      cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
        sources = {
          { name = "dap" },
        },
      })

      require("cmp.entry").get_documentation = function(self)
        local item = self:get_completion_item()
        if item.documentation then
          return require("meg.utils").format_markdown(item.documentation)
        end
        return {}
      end
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    lazy = true,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      vim.defer_fn(function()
        require("copilot").setup({
          cmp = {
            enabled = true,
            method = "getCompletionsCycling",
          },
          panel = {
            -- if true, it can interfere with completions in copilot-cmp
            enabled = false,
          },
          suggestion = {
            -- if true, it can interfere with completions in copilot-cmp
            enabled = false,
          },
          filetypes = {
            ["dap-repl"] = false,
            ["big_file_disabled_ft"] = false,
          },
        })
      end, 100)
    end,
    dependencies = {
      "zbirenbaum/copilot-cmp",
      config = function()
        require("completion.copilot-cmp")
      end,
    },
  },
}
