local function setup(cmp, borders, kinds)
  local loaded_luasnip, luasnip = pcall(require, "luasnip")
  if not loaded_luasnip then
    mw.loading_error_msg("LuaSnip")
    return
  end

  local has_copilot, copilot_cmp = pcall(require, "copilot_cmp.comparators")

  local function has_words_before()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
  end

  local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  vim.opt.completeopt = "menuone,noselect"
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    style = {
      winhighlight = "NornalFloat:NormalFloat,FloatBorder:FloatBorder",
    },
    formatting = {
      format = function(entry, vim_item)
        vim_item.kind = string.format("  %s %s ", kinds[vim_item.kind], vim_item.kind)
        vim_item.menu = ({
          copilot = "[AI]",
          nvim_lsp = "[LSP]",
          buffer = "[BFR]",
          nvim_lua = "[LUA]",
          luasnip = "[SNP]",
          path = "[PTH]",
          spell = "[ABC]",
        })[entry.source.name]
        return vim_item
      end,
    },
    window = {
      completion = {
        border = {
          borders.tl,
          borders.t,
          borders.tr,
          borders.r,
          borders.br,
          borders.b,
          borders.bl,
          borders.l,
        },
        scrollbar = "║",
        winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:None",
      },
      documentation = cmp.config.window.bordered({
        border = {
          borders.tl,
          borders.t,
          borders.tr,
          borders.r,
          borders.br,
          borders.b,
          borders.bl,
          borders.l,
        },
        scrollbar = "║",
        winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:None",
      }),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-s>"] = cmp.mapping.complete({
        config = {
          sources = {
            { name = 'copilot' },
          }
        }
      }),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        -- select = false,
      }),
      ["<Tab>"] = function (fallback)
        if cmp.visible() and has_words_before() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end,
      ["<S-Tab>"] = vim.schedule_wrap(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end),
    }),
    sources = cmp.config.sources({
      { name = "copilot", group_index = 1 },
      { name = "nvim_lsp", group_index = 1 },
      { name = "buffer", group_index = 5 },
      { name = "nvim_lua", group_index = 2 },
      { name = "luasnip", group_index = 2 },
      { name = "path", group_index = 1 },
      { name = "spell", group_index = 3 },
    }),
    sorting = {
      priority_weight = 1,
      comparators = {
        -- order matters here
        cmp.config.compare.exact,
        cmp.config.compare.offset,
        -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        has_copilot and copilot_cmp.prioritize or nil,
        has_copilot and copilot_cmp.score or nil,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
        -- personal settings:
        -- cmp.config.compare.recently_used,
        -- cmp.config.compare.offset,
        -- cmp.config.compare.score,
        -- cmp.config.compare.sort_text,
        -- cmp.config.compare.length,
        -- cmp.config.compare.order,
      },
    },
    preselect = cmp.PreselectMode.Item,
    experimental = {
      native_menu = false,
      ghost_text = {
        hl_group = "CmpGhostText",
      },
    },
  })

  -- Use buffer source for `/`.
  cmp.setup.cmdline("/", {
    completion = { autocomplete = false },
    sources = cmp.config.sources({
      { name = "buffer" },
    }),
  })

  -- Use cmdline & path source for ':'.
  cmp.setup.cmdline(":", {
    completion = { autocomplete = false },
    sources = cmp.config.sources({
      { name = "path" },
      { name = "cmdline" },
    }),
  })
end

vim.cmd([[ set pumheight=6 ]])

local borders = mw.ui.borders.default
local kinds = mw.ui.icons.lsp.kinds
local loaded_cmp, cmp = pcall(require, "cmp")
if not loaded_cmp then
  mw.loading_error_msg("nvim-cmp")
  return
end
setup(cmp, borders, kinds)
