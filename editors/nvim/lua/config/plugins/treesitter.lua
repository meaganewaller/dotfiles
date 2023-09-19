return {
  {
    'Wansmer/treesj',
    config = true,
    event = 'BufWinEnter',
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Which module to call '#setup(opts)' on
    opts = {
      ensure_installed = {
        'bash', 'c', 'cpp', 'css', 'scss', 'go', 'html', 'json', 'lua', 'luadoc', 'python', 'ruby', 'vim', 'vue', 'javascript',
        'typescript', 'tsx', 'markdown', 'markdown_inline', 'regex', 'comment', 'http', 'query', 'vimdoc',
      },
      sync_install = false, -- Don't install parsers synchronously (only applied to `ensure_installed`)
      highlight = {
        enable = not vim.g.vscode,
        additional_vim_regex_highlighting = { 'ruby' }, -- Needed for non-treesitter indentation to work
      },
      indent = {
        enable = true,
        -- Disabling treesitter-indentation until either of the following tickets is resolved:
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3363
        -- https://github.com/tree-sitter/tree-sitter-ruby/issues/230
        disable = { 'ruby' }
      },
      autotag = {
        enable = true,
      },
      endwise = {
        enable = true,
      },
      matchup = {
        enable = true,
        disable_virtual_text = true,
      },
      context_commentstring = {
        enable = true,
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25,
        persist_queries = false,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ar"] = "@block.outer",
            ["ir"] = "@block.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      }
    },
    auto_install = true,
    sync_install = false,
    ignore_install = {},
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      "RRethy/nvim-treesitter-endwise",
      "windwp/nvim-ts-autotag",
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/playground',
    }
  },
  config = function(opts)
    require('nvim-treesitter.configs').setup(opts)
    vim.o.foldmethod = 'expr'
    vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.o.foldlevel = 99
  end
}
