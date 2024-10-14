return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  dependencies = { { "echasnovski/mini.icons", opts = {}}},
  keys = function()
    return {
      { '-', '<cmd>Oil<cr>', desc = 'oil' },
    }
  end,
  config = function()
    local hiddens = { '.DS_Store', '.git', '.gitmodules', 'node_modules' }

    require('oil').setup({
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      cleanup_delay_ms = 1000,
      init = function()
        vim.g.loaded_netrwPlugin = 1
      end,
      keymaps = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = 'actions.select_vsplit',
        ['g<C-s>'] = 'actions.select_split',
        ['K'] = 'actions.preview',
        ['gh'] = 'actions.close',
        ['<C-l>'] = 'actions.refresh',
        ['-'] = 'actions.parent',
        ['+'] = 'actions.open_cwd',
        ['_'] = 'actions.cd',
        ['`'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
        ['g\\'] = 'actions.toggle_trash',
      },
      view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
          return vim.list_contains(hiddens, name)
        end,
      },
      win_options = {
        wrap = true,
      }
    })
  end
}
