-- https://github.com/hrsh7th/nvim-cmp

local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load({
  paths = { "~/.config/nvim/snippets" }
})

-- { == Configuration ==> ====================================================

local function formatForTailwindCSS(entry, vim_item)
  if vim_item.kind == 'Color' and entry.completion_item.documentation then
    local _, _, r, g, b = string.find(entry.completion_item.documentation, '^rgb%((%d+), (%d+), (%d+)')
    if r then
      local color = string.format('%02x', r) .. string.format('%02x', g) .. string.format('%02x', b)
      local group = 'Tw_' .. color
      if vim.fn.hlID(group) < 1 then
        vim.api.nvim_set_hl(0, group, {fg = '#' .. color})
      end
      vim_item.kind = '●'
      vim_item.kind_hl_group = group
      return vim_item
    end
  end
  vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
  return vim_item
end

local i_cr_action = function(fallback)
  if not cmp.visible() then
    fallback()
    return
  end

  -- test the first entry is rime_ls or not
  local entry = cmp.get_selected_entry()

  if entry == nil then
    entry = cmp.core.view:get_first_entry()
  end

  if entry == nil then
    -- entry still nil, fallback
    fallback()
    return
  end

  if
    entry.source ~= nil
    and entry.source.name == "nvim_lsp"
    and entry.source.source ~= nil
    and entry.source.source.client ~= nil
    and entry.source.source.client.name == "rime_ls"
  then
    -- if the first entry is from rime_ls, do not confirm, <CR> now is a simple
    -- new line marker
    cmp.abort()
    return
  end

  -- otherwise, confirm the selected entry
  entry = cmp.get_selected_entry()
  if entry == nil then
    fallback()
    return
  end

  local is_insert_mode = function()
    return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
  end

  local confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  }

  if is_insert_mode() then
    confirm_opts.behavior = cmp.ConfirmBehavior.Insert
  end

  if not cmp.confirm(confirm_opts) then
    fallback()
  end
end

local function in_latex_scope()
  local context = require("cmp.config.context")
  local ft = vim.api.nvim_get_option_value("filetype", {
    buf = 0,
  })
  if ft ~= "markdown" and ft ~= "latex" then
    return false
  end
  return context.in_treesitter_capture("text.math")
end

cmp.setup({
  matching = {
    disallow_fuzzy_matching = false,
    disallow_fullfuzzy_matching = true,
    disallow_partial_fuzzy_matching = false,
    disallow_partial_matching = false,
  },
  preselect = cmp.PreselectMode.Item,
  experimental = { ghost_text = false },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = {
      border = "solid",
      focusable = false,
      col_offset = 0,
    },
    documentation = {
      border = "single",
      winhighlight = "FloatBorder:FloatBorder",
      focusable = false,
    },
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp", group_index = 1, max_item_count = 100 },
    { name = 'luasnip' },
    {
      name = "latex_symbols",
      filetype = { "tex", "latex", "markdown" },
      group_index = 1,
      option = {
        cache = true,
        strategy = 2, -- latex only
      },
      entry_filter = function(_, ctx)
        if ctx.in_latex_scope == nil then
          ctx.in_latex_scope = in_latex_scope()
        end
        return ctx.in_latex_scope
      end,
    },
    { name = 'copilot' },
    { name = "async_path", group_index = 4 },
    { name = "calc", group_index = 5 },
    {
      name = "buffer",
      group_index = 5,
      option = {
        get_bufnrs = function()
          local buf = vim.api.nvim_get_current_buf()
          local byte_size =
          vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
          if byte_size > 1024 * 1024 then -- 1 Megabyte max
            return {}
          end
          return { buf }
        end,
      },
      max_item_count = 10,
    },
  }, { name = 'buffer' }, { name = 'emoji' }, { name = 'calc' }, { name = 'path' }),
  completion = { completeopt = "menu,menuone,noselect,noinsert,preview" },
  mapping = {
    ["<CR>"] = cmp.mapping(i_cr_action, { "i", "c" }),
    ["<Space>"] = cmp.mapping(function(fallback)
      if not cmp.visible() then
        fallback()
        return
      end
      local entry = cmp.get_selected_entry()
      if entry == nil then
        entry = cmp.core.view:get_first_entry()
      end
      if entry == nil then
        fallback()
        return
      end
      if
        entry ~= nil
        and vim.g.global_rime_enabled
        and entry.source.name == "nvim_lsp"
        and entry.source.source.client.name == "rime_ls"
      then
        -- cmp enabled
        cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true }
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-p>"] = cmp.mapping.select_prev_item {},
    ["<C-n>"] = cmp.mapping.select_next_item {},
    ["<C-k>"] = cmp.mapping.select_prev_item {},
    ["<C-j>"] = cmp.mapping.select_next_item {},
    ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i" }),
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i" }),
    ["<C-e>"] = cmp.mapping.abort(),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),
  },
  formatting = {
    fields = { "menu", "abbr", "kind" },
    format = lspkind.cmp_format({
      maxwidth = 200,
      ellipsis_char = "...",
      before = function(e, item)
        local menu_icon = {
          nvim_lsp = 'λ',
          buffer = 'Ω',
          cmdline = '⋗',
          luasnip = '✎',
          path = 'Ψ',
          emoji = '🤌',
          nvim_lua = 'Π',
          calc = 'Σ',
          ultisnips = "[Snip]",
          orgmode = "[Org]",
          dap = "[DAP]",
          latex_symbols = "[LaTeX]",
          cmdline_history = "[History]",
          copilot = "[Copilot]",
        }

        item = formatForTailwindCSS(e, item)
        item.menu = menu_icon[e.source.name] or e.source.name
        if e.source.name == "latex_symbols" then
          item.kind = "Math"
        end
        return item
      end
    })
  },
  enabled = function()
    local context = require('cmp.config.context')

    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      return not context.in_treesitter_capture('comment') and not context.in_syntax_group('Comment')
    end
  end,
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp.config.compare.locality,
      cmp.config.compare.exact,
      cmp.config.compare.recently_used,
      --require("clangd_extensions.cmp_scores"),
      cmp.config.compare.score,
      cmp.config.compare.offset,
      cmp.config.compare.order,
      -- cmp.config.compare.kind,
      -- cmp.config.compare.sort_text,
      -- cmp.config.compare.length,
    },
  },
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
      { name = 'cmdline' }
    })
})

vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*',
  callback = function()
    if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
      and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require('luasnip').session.jump_active
    then
      require('luasnip').unlink_current()
    end
  end
})
