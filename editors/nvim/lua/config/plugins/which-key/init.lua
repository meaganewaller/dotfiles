return {
  "folke/which-key.nvim",
  event = 'BufEnter',
  cond = not vim.g.vscode,
  config = function()
    local wk = require('which-key')

    wk.setup({
      plugins = {
        marks = false,
        registers = false,
      },
      presets = {
        operators = false,
        motions = false,
        windows = false,
        nav = false,
        z = false,
        g = false,
      },
      operators = { gc = 'Comments' },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      window = {
        border = 'rounded',
        position = 'bottom',
        margin = { 1, 0, 1, 0 },
        padding = { 2, 2, 2, 2 },
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 20 },
        spacing = 3,
        align = "center",
      },
      ignore_missing = false,
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
      show_help = true, -- show help message on the command line when the popup is visible
      -- triggers = "auto", -- automatically setup triggers
      triggers = { "<Leader>", "<LocalLeader>" },
      triggers_blacklist = {
        i = { "j", "k" },
        v = { "j", "k" },
      },
    })

    local opts = {
      mode = 'n',
      prefix = '<Leader>',
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = false,
    }

    local visual_opts = {
      mode = 'v',
      prefix = '<Leader>',
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = false,
    }

    local normal_mode_mappings = {
      ['1'] = 'which_key_ignore',
      ['2'] = 'which_key_ignore',
      ['3'] = 'which_key_ignore',
      ['4'] = 'which_key_ignore',
      ['5'] = 'which_key_ignore',
      ['6'] = 'which_key_ignore',
      ['7'] = 'which_key_ignore',
      ['8'] = 'which_key_ignore',
      ['9'] = 'which_key_ignore',

      -- single
      ['='] = { '<cmd>vertical resize +5<CR>',                      'resize +5' },
      ['-'] = { '<cmd>vertical resize -5<CR>',                      'resize +5' },
      ['v'] = { '<C-W>v',                                           'split right' },
      ['V'] = { '<C-W>s',                                           'split below' },
      ['q'] = { 'quicklist' },

      ['<Leader>'] = {
        name = 'NeoVim',
        ['/'] = { '<cmd>Alpha<CR>', 'open dashbord' },
        c =  { '<cmd>e $MYVIMRC<CR>', 'open config' },
        i = { '<cmd>Lazy<CR>', 'manage plugins' },
        u = { '<cmd>Lazy update<CR>', 'update plugins' },
        s = {
          name = 'Session',
        },
      },

      a = {
        name = 'Actions',
        n = { '<cmd>set nonumber!<CR>', 'line numbers' },
        r = { '<cmd>set norelativenumber!<CR>', 'relative numbers' },
      },

      b = {
        name = 'Buffer',
      }
    }

    wk.register({
      ["<leader>"] = {
        d = { '<cmd>bdelete!<cr>', 'Delete buffer' },
        -- FZF
        F = { ':FzfLua git_files<CR>', 'Git files' },
        f = { ':FzfLua files<CR>', 'Files' },
        b = { ':FzfLua buffers<CR>',           'Buffers' },
        q = { ':FzfLua quickfix<CR>',          'Quickfix' },
        G = { ':FzfLua live_grep<CR>',         'Live Grep' },
        r = { ':lua vim.lsp.buf.rename()<CR>', 'Rename' },

        c = {
          name = 'Code (LSP)',
          a = { ':FzfLua lsp_code_actions<CR>', 'Code actions' },
          f = { ':lua vim.lsp.buf.format()<CR>',         'Autoformat' },
          s = { ':lua vim.lsp.buf.signature_help()<CR>', 'Signature' },
          S = { ':FzfLua lsp_document_symbols<CR>',      'Symbols' },
          d = { ':lua vim.diagnostic.open_float() <CR>', 'Line diagnostics' },
        },

        g = {
          name = 'Git',
          b = { ':lua require"gitsigns".blame_line()<CR>',      'Git Blame line' },
          s = { ':lua require"gitsigns".stage_hunk()<CR>',      'Stage hunk' },
          u = { ':lua require"gitsigns".undo_stage_hunk()<CR>', 'Undo stage hunk' },
          r = { ':lua require"gitsigns".reset_hunk()<CR>',      'Reset hunk' },
          R = { ':lua require"gitsigns".reset_buffer()<CR>',    'Reset buffer' },
          p = { ':lua require"gitsigns".preview_hunk()<CR>',    'Preview hunk' },
        },
        ["1"] = { ':BufferLineGoToBuffer 1<CR>', "Go to buffer 1" },
        ["2"] = { ':BufferLineGoToBuffer 2<CR>', "Go to buffer 2" },
        ["3"] = { ':BufferLineGoToBuffer 3<CR>', "Go to buffer 3" },
        ["4"] = { ':BufferLineGoToBuffer 4<CR>', "Go to buffer 4" },
        ["5"] = { ':BufferLineGoToBuffer 5<CR>', "Go to buffer 5" },
        ["6"] = { ':BufferLineGoToBuffer 6<CR>', "Go to buffer 6" },
        ["7"] = { ':BufferLineGoToBuffer 7<CR>', "Go to buffer 7" },
        ["8"] = { ':BufferLineGoToBuffer 8<CR>', "Go to buffer 8" },
        ["9"] = { ':BufferLineGoToBuffer 9<CR>', "Go to buffer 9" },
      },

      g = {
        name = 'Goto',
        b = { '<cmd>BufferLinePick<CR>', 'Buffer Picker' },
        d = { ':lua vim.lsp.buf.definition()<CR>',       'Definition'},
        t = { ':lua vim.lsp.buf.type_definition()<CR>',  'Type Definition'},
        D = { ':lua vim.lsp.buf.declaration()<CR>',      'Declaration'},
        r = { ':FzfLua lsp_references<CR>',              'References'},
        i = { ':lua vim.lsp.buf.implementation()<CR>',   'Implementation'},
        j = { ':lua vim.lsp.diagnostic.goto_next()<CR>', 'Next diagnostic' },
        k = { ':lua vim.lsp.diagnostic.goto_prev()<CR>', 'Previuous diagnostic' },
      },

      -- Cycle buffers
      ['<C-n>'] = { ':bnext<CR>', 'Next buffer'},
      ['<C-p>'] = { ':bprev<CR>', 'Previous buffer'},

      -- Remap the arrow keys to nothing
      ['<left>']  = { '<nop>', 'Nothing'},
      ['<right>'] = { '<nop>', 'Nothing'},
      ['<up>']    = { '<nop>', 'Nothing'},
      ['<down>']  = { '<nop>', 'Nothing'},

      -- Use Q for playing q macro
      Q = { '@q', 'Play q macro' },
    })

    for i=1,9 do
      wk.register({
        [tostring(i)] = 'which_key_ignore',
      }, { prefix = '<Leader>' })
    end

    wk.register({
      [';'] = { ':', 'Switch ; and :' },
      [':'] = { ';', 'Switch ; and :' },
    }, { mode = 'n', silent = false })

    wk.register({
      -- Switch ; and :
      [';'] = { ':', 'Switch ; and :'},
      [':'] = { ';', 'Switch ; and :'},

      -- Indent lines and reselect visual group
      ['<'] = { '<gv', 'Reselect on indenting lines'},
      ['>'] = { '>gv', 'Reselect on indenting lines'},

      -- Move lines up and down
      ['<C-k>'] = { ":m-2<CR>gv", 'Move line up'},
      ['<C-j>'] = { ":m '>+<CR>gv", 'Move line down'},

      ['<C-a>'] = { "g<C-a>", 'Visual increment numbers'},
      ['<C-x>'] = { "g<C-x>", 'Visual decrement numbers'},
      ['g<C-a>'] = { "<C-a>", 'Increment numbers'},
      ['g<C-x>'] = { "<C-x>", 'Decrement numbers'},

      -- vnoremap <C-a> g<C-a>
      -- vnoremap <C-x> g<C-x>
      -- vnoremap g<C-a> <C-a>
      -- vnoremap g<C-x> <C-x>
    }, { mode = 'v', silent = false })
  end
}
