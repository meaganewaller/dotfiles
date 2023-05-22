return {
  -- measure startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  {
    "tenxsoydev/nx.nvim",
    lazy = false,
    priority = 120,
    config = function()
      _G.nx = require "nx"
    end
  },

  {
    "AckslD/messages.nvim",
    event = "VeryLazy",
    config = function()
      require("messages").setup({
        command_name = "Messages",
        prepare_buffer = function(opts)
          local buf = vim.api.nvim_create_buf(false, true)
          nx.map({
            { { "q", "<C-c>", "<C-h>", "<C-j>", "<C-k>", "<C-l>" }, "<Cmd>close<CR>" },
            }, { buffer = buf, silent = true })
          return vim.api.nvim_open_win(buf, true, opts)
        end,
      })
    end,
  },

  {
    "vigoux/notifier.nvim",
    event = "VeryLazy",
    config = function()
      require("notifier").setup({
        components = {
          "nvim", -- Nvim notifications (vim.notify and such)
          -- "lsp"  -- LSP status updates
        },
        notify = {
          clear_time = 5000, -- Time in milliseconds before removing a vim.notify notification, 0 to make them sticky
        },
        zindex = 100,
      })
    end,
  },

  {
    "folke/noice.nvim",
    config = function()
      if vim.g.multigrid then return end
      require("noice").setup({
        lsp = {
          signature = {
            enabled = false,
          },
          progress = {
            enabled = false, -- using fidget instead as it feel less intrusive
          },
        },
        cmdline = {
          enabled = true,
          view = "cmdline",
        },
        messages = {
          view = "mini",
          view_search = false,
        },
        notify = {
          enabled = false,
        },
        presets = {
          bottom_search = true,
          lsp_doc_border = true,
        },
        views = {
          mini = {
            win_options = {
              winblend = vim.o.winblend, -- mainly necessary to fix coloring issue in alacritty
            },
          },
        },
      })
      nx.hl({ { "NoiceCmdlinePopupBorder", "NoiceCmdlineIconCmdLine" }, link = "Operator" })
      nx.map({
        { "<C-j>", "<Tab>", "c", desc = "Next Entry" },
        { "<C-k>", "<S-Tab>", "c", desc = "Previous Entry" },
      })
    end,
  },

  -- session management
  {
    'olimorris/persisted.nvim',
    event = 'VimEnter',
    priority = 1000,
    opts = {
      autoload = true,
      follow_cwd = false,
      ignored_dirs = { '/usr', '/opt', '~/.cache', vim.env.TMPDIR or '/tmp' },
      should_autosave = function()
        -- Do not autosave if git commit/rebase session.
        return vim.env.GIT_EXEC_PATH == nil
      end,
    },
    config = function(_, opts)
      if vim.g.in_pager_mode or vim.env.GIT_EXEC_PATH ~= nil then
        -- Do not autoload if stdin has been provided, or git commit session.
        opts.autoload = false
      end
      require('persisted').setup(opts)
    end,
    init = function()
      -- Detect if stdin has been provided.
      vim.g.in_pager_mode = false
      vim.api.nvim_create_autocmd('StdinReadPre', {
        group = vim.api.nvim_create_augroup('meg_persisted', {}),
        callback = function()
          vim.g.in_pager_mode = true
        end
      })
      -- Close all floats before loading a session. (e.g. Lazy.nvim)
      vim.api.nvim_create_autocmd('User', {
        group = 'meg_persisted',
        pattern = 'PersistedLoadPre',
        callback = function()
          for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(win).zindex then
              vim.api.nvim_win_close(win, false)
            end
          end
        end
      })
      -- Close all plugin owned buffers before saving a session.
      vim.api.nvim_create_autocmd('User', {
        pattern = 'PersistedSavePre',
        group = 'meg_persisted',
        callback = function()
          -- Detect if window is owned by plugin by checking buftype.
          local current_buffer = vim.api.nvim_get_current_buf()
          for _, win in ipairs(vim.fn.getwininfo()) do
            local buftype = vim.api.nvim_buf_get_option(win.bufnr, 'buftype')
            if buftype ~= '' and buftype ~= 'help' then
              -- Delete plugin owned window buffers.
              if win.bufnr == current_buffer then
                -- Jump to previous window if current window is not a real file
                vim.cmd.wincmd('p')
              end
              vim.api.nvim_buf_delete(win.bufnr, {})
            end
          end
        end,
      })
      -- When switching to a different session using Telescope, save and stop
      -- current session to avoid previous session to be overwritten.
      vim.api.nvim_create_autocmd('User', {
        pattern = 'PersistedTelescopeLoadPre',
        group = 'meg_persisted',
        callback = function()
          require('persisted').save()
          require('persisted').stop()
        end
      })
      -- When switching to a different session using Telescope, after new
      -- session has been loaded, start it - so it will be auto-saved.
      vim.api.nvim_create_autocmd('User', {
        pattern = 'PersistedTelescopeLoadPost',
        group = 'meg_persisted',
        callback = function(session)
          require('persisted').start()
          print('Started session ' .. session.data.name)
        end
      })
    end,
  },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },

  -- keep track of coding metrics
  { "wakatime/vim-wakatime", lazy = false },


}
