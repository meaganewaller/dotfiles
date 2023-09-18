local plugin = { 'hrsh7th/nvim-cmp' }
local user = { autocomplete = true }

plugin.dependencies = {
  {
    'zbirenbaum/copilot.lua',
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = {
        enabled = false
      },
      suggestion = {
        enabled = false,
      }
    }
  },
  { 'zbirenbaum/cmp-copilot',   lazy = true },
  { 'hrsh7th/cmp-buffer',       lazy = true },
  { 'hrsh7th/cmp-nvim-lsp',     lazy = true },
  { 'hrsh7th/cmp-path',         lazy = true },
  { 'lukas-reineke/cmp-rg',     lazy = true },
  { 'saadparwaiz1/cmp_luasnip', lazy = true },
  { 'hrsh7th/cmp-nvim-lua',     lazy = true },
  { 'L3MON4D3/LuaSnip' },
}

plugin.event = 'InsertEnter'

function plugin.config()
  user.augroup = vim.api.nvim_create_augroup('compe_cmds', { clear = true })
  vim.api.nvim_create_user_command('UserCmpEnable', user.enable_cmd, {})

  local cmp = require('cmp')
  local luasnip = require('luasnip')

  local select_opts = { behavior = cmp.SelectBehavior.Select }
  local cmp_enable = cmp.get_config().enabled

  user.config = {
    enabled = function()
      if user.autocomplete then
        return cmp_enable()
      end

      return false
    end,
    completion = {
      completeopt = 'menu,menuone'
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = {
      { name = 'path' },
      { name = 'copilot' },
      { name = 'nvim_lsp', keyword_length = 3 },
      { name = 'buffer',   keyword_length = 3 },
      { name = 'luasnip',  keyword_length = 2 },
    },
    window = {
      documentation = {
        border = 'rounded',
        max_height = 15,
        max_width = 50,
        zindex = 50,
      },
    },
    formatting = {
      fields = { 'menu', 'abbr', 'kind' },
      format = require('lspkind').cmp_format({
        mode = 'symbol',
        maxwidth = 50,
        ellipsis_char = '...'
      })
    },
    mapping = {
      ['<C-k>'] = cmp.mapping.scroll_docs(-5),
      ['<C-j>'] = cmp.mapping.scroll_docs(5),

      ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
      ['<Down>'] = cmp.mapping.select_next_item(select_opts),

      ['<M-k>'] = cmp.mapping.select_prev_item(select_opts),
      ['<M-j>'] = cmp.mapping.select_next_item(select_opts),

      ['<C-a>'] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<C-d>'] = cmp.mapping(function(fallback)
        if luasnip.jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<M-u>'] = cmp.mapping(function()
        if cmp.visible() then
          user.set_autocomplete(false)
          cmp.abort()
        else
          user.set_autocomplete(true)
          cmp.complete()
        end
      end),

      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true })
        elseif luasnip.jumpable(1) then
          luasnip.jump(1)
        elseif user.check_back_space() then
          fallback()
        else
          user.set_autocomplete(true)
          cmp.complete()
        end
      end, { 'i', 's' }),

      ['<S-Tab>'] = cmp.mapping(function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          user.insert_tab()
        end
      end, { 'i', 's' }),
    }
  }

  cmp.setup(user.config)
end

function user.set_autocomplete(new_value)
  local old_value = user.autocomplete

  if new_value == old_value then
    return
  end

  if new_value == false then
    -- restore autocomplete in the next word
    vim.api.nvim_buf_set_keymap(
      0,
      'i',
      '<space>',
      '<cmd>UserCmpEnable<cr><space>',
      { noremap = true }
    )

    -- restore when leaving insert mode
    vim.api.nvim_create_autocmd('InsertLeave', {
      group = user.augroup,
      command = 'UserCmpEnable',
      once = true,
    })
  end

  user.autocomplete = new_value
end

function user.check_back_space()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

function user.enable_cmd()
  if user.autocomplete then
    return
  end

  pcall(vim.api.nvim_buf_del_keymap, 0, 'i', '<Space>')
  user.set_autocomplete(true)
end

function user.insert_tab()
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('<Tab>', true, true, true),
    'n',
    true
  )
end

return plugin
-- return {
--   {
--     'zbirenbaum/copilot.lua',
--     cmd = "Copilot",
--     event = "InsertEnter",
--     opts = {
--       panel = {
--         enabled = false
--       },
--       suggestion = {
--         enabled = true,
--         auto_trigger = true,
--         keymap = {
--           accept = '<M-Space>',
--           accept_line = '<M-l>',
--           next = '<M-n>',
--           prev = '<M-p>',
--         }
--       }
--     }
--   },
--   {
--     'hrsh7th/nvim-cmp',
--     dependencies = {
--       { 'hrsh7th/cmp-buffer', lazy = true },
--       { 'hrsh7th/cmp-nvim-lsp', lazy = true },
--       { 'hrsh7th/cmp-path', lazy = true },
--       { 'hrsh7th/cmp-vsnip', lazy = true },
--       { 'lukas-reineke/cmp-rg', lazy = true },
--     },
--     config = function()
--       local cmp = require('cmp')
--
--       vim.opt.pumheight = 15
--       vim.opt.completeopt = 'menuone,noselect'
--
--       cmp.setup({
--         snippet = {
--           expand = function(args)
--             require('luasnip').lsp_expand(args.body)
--           end,
--         },
--         window = {
--           documentation = cmp.config.window.bordered()
--         },
--         preselect = cmp.PreselectMode.None,
--         completion = {
--           completeopt = 'menu,menuone,noinsert,noselect',
--         },
--         mapping = {
--           ['<CR>'] = cmp.mapping.confirm({ select = false }),
--           ['<C-k>'] = cmp.mapping.select_prev_item(select_opts),
--
--         },
--         sources = {
--           { name = 'nvim_lsp' },
--           { name = 'luasnip' },
--           { name = 'path' },
--           { name = 'buffer' },
--         },
--         formatting = {
--           fields = { 'menu', 'abbr', 'kind' },
--           format = require('lspkind').cmp_format({
--             mode = 'symbol',
--             maxwidth = 50,
--             ellipsis_char = '...'
--           })
--         }
--       })
--     end
--   },
-- }
