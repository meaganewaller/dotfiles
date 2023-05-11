local function linker()
  return require("gitlinker")
end
local function neogit()
  return require("neogit")
end
local function browser_open()
  return { action_callback = require("gitlinker.actions").open_in_browser }
end
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- experimental things -----------
      _extmark_signs = false,
      _inline2 = true,
      _signs_staged_enable = false,
      -- -------------------------------
      signs = {
        add = { hl = "GitSignsAdd", text = "▕", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" }, -- alts: ▕, ▎, ┃, │, ▌, ▎ 🮉
        change = { hl = "GitSignsChange", text = "▕", numhl = "GitSignsChangeNr", linehl = "GitSignsAddLn" }, -- alts: ▎║▎
        delete = {
          hl = "GitSignsDelete",
          text = "┊",
          numhl = "GitSignsDeleteNr",
          linehl = "GitSignsDeleteLn",
        },
        topdelete = {
          hl = "GitSignsDelete",
          text = "‾",
          numhl = "GitSignsDeleteNr",
          linehl = "GitSignsDeleteLn",
        },
        changedelete = {
          hl = "GitSignsChange",
          text = "~",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
        untracked = { hl = "GitSignsAdd", text = "▕" }, -- alts: ┆ ▕
      },
      current_line_blame = not vim.fn.getcwd():match("dotfiles"),
      current_line_blame_opts = { delay = 1000, virtual_text_pos = "eol" },
      current_line_blame_formatter = " <author>, <author_time> · <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      word_diff = false,
      diff_opts = { internal = true },
      preview_config = {
        border = meg.get_border(),
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local bind = require("meg.keymap.bind")

        bind.nvim_load_mapping({
          ["n|]g"] = bind
            .map_callback(function()
              if vim.wo.diff then
                return "]g"
              end
              vim.schedule(function()
                require("gitsigns.actions").next_hunk()
              end)
              return "<Ignore>"
            end)
            :with_buffer(bufnr)
            :with_expr()
            :with_desc("git: Goto next hunk"),
          ["n|[g"] = bind
            .map_callback(function()
              if vim.wo.diff then
                return "[g"
              end
              vim.schedule(function()
                require("gitsigns.actions").prev_hunk()
              end)
              return "<Ignore>"
            end)
            :with_buffer(bufnr)
            :with_expr()
            :with_desc("git: Goto prev hunk"),
          ["n|<leader>hs"] = bind
            .map_callback(function()
              require("gitsigns.actions").stage_hunk()
            end)
            :with_buffer(bufnr)
            :with_desc("git: Stage hunk"),
          ["v|<leader>hs"] = bind
            .map_callback(function()
              require("gitsigns.actions").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end)
            :with_buffer(bufnr)
            :with_desc("git: Stage hunk"),
          ["n|<leader>hu"] = bind
            .map_callback(function()
              require("gitsigns.actions").undo_stage_hunk()
            end)
            :with_buffer(bufnr)
            :with_desc("git: Undo stage hunk"),
          ["n|<leader>hr"] = bind
            .map_callback(function()
              require("gitsigns.actions").reset_hunk()
            end)
            :with_buffer(bufnr)
            :with_desc("git: Reset hunk"),
          ["v|<leader>hr"] = bind
            .map_callback(function()
              require("gitsigns.actions").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end)
            :with_buffer(bufnr)
            :with_desc("git: Reset hunk"),
          ["n|<leader>hR"] = bind
            .map_callback(function()
              require("gitsigns.actions").reset_buffer()
            end)
            :with_buffer(bufnr)
            :with_desc("git: Reset buffer"),
          ["n|<leader>hp"] = bind
            .map_callback(function()
              require("gitsigns.actions").preview_hunk()
            end)
            :with_buffer(bufnr)
            :with_desc("git: Preview hunk"),
          ["n|<leader>hb"] = bind
            .map_callback(function()
              require("gitsigns.actions").blame_line({ full = true })
            end)
            :with_buffer(bufnr)
            :with_desc("git: Blame line"),
          -- Text objects
          ["ox|ih"] = bind
            .map_callback(function()
              require("gitsigns.actions").text_object()
            end)
            :with_buffer(bufnr),
        })

        -- local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end
        -- local function bmap(mode, l, r, opts)
        --   opts = opts or {}
        --   opts.buffer = bufnr
        --   vim.keymap.set(mode, l, r, opts)
        -- end
        --
        -- meg.nmap("<localleader>hu", gs.undo_stage_hunk, { desc = "git(hunk): undo stage" })
        -- meg.nmap("<localleader>hp", gs.preview_hunk_inline, { desc = "git(hunk): preview hunk inline" })
        -- -- meg.nmap("<leader>hp", gs.preview_hunk, { desc = "git: preview hunk" })
        -- meg.nmap("<localleader>hb", gs.toggle_current_line_blame, { desc = "git(hunk): toggle current line blame" })
        -- meg.nmap("<localleader>hd", gs.toggle_deleted, { desc = "git(hunk): show deleted lines" })
        -- meg.nmap("<localleader>hw", gs.toggle_word_diff, { desc = "git(hunk): toggle word diff" })
        -- meg.nmap("<localleader>gw", gs.stage_buffer, { desc = "git: stage entire buffer" })
        -- meg.nmap("<localleader>gre", gs.reset_buffer, { desc = "git: reset entire buffer" })
        -- meg.nmap("<localleader>gbl", gs.blame_line, { desc = "git: blame current line" })
        -- meg.nmap("<leader>gm", function()
        --   gs.setqflist("all")
        -- end, {
        --   desc = "git: list modified in quickfix",
        -- })
        -- meg.nmap("<leader>gd", function()
        --   gs.diffthis()
        -- end, {
        --   desc = "git: diff this",
        -- })
        -- meg.nmap("<leader>gD", function()
        --   gs.diffthis("~")
        -- end, {
        --   desc = "git: diff this against ~",
        -- })
        -- -- Navigation
        -- bmap("n", "[h", function()
        --   if vim.wo.diff then
        --     return "[c"
        --   end
        --   vim.schedule(function()
        --     gs.prev_hunk()
        --   end)
        --   return "<Ignore>"
        -- end, { expr = true, desc = "git: prev hunk" })
        -- bmap("n", "]h", function()
        --   if vim.wo.diff then
        --     return "]c"
        --   end
        --   vim.schedule(function()
        --     gs.next_hunk()
        --   end)
        --   return "<Ignore>"
        -- end, { expr = true, desc = "git: next hunk" })
        --
        -- -- Actions
        -- bmap({ "n", "v" }, "<localleader>hs", ":Gitsigns stage_hunk<CR>", { desc = "git: stage hunk" })
        -- bmap({ "n", "v" }, "<localleader>gs", ":Gitsigns stage_hunk<CR>", { desc = "git: stage hunk" })
        -- bmap({ "n", "v" }, "<localleader>hr", ":Gitsigns reset_hunk<CR>", { desc = "git: reset hunk" })
        -- bmap({ "n", "v" }, "<localleader>gr", ":Gitsigns reset_hunk<CR>", { desc = "git: reset hunk" })
        --
        -- -- Text object
        -- bmap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "git: select hunk" })
        --
        -- meg.nmap("[h", function()
        --   vim.schedule(function() gs.prev_hunk() end)
        --   return "<Ignore>"
        -- end, { expr = true, desc = "go to previous git hunk" })
        -- meg.nmap("]h", function()
        --   vim.schedule(function() gs.next_hunk() end)
        --   return "<Ignore>"
        -- end, { expr = true, desc = "go to next git hunk" })
      end,
      watch_gitdir = { interval = 1000, follow_files = true },
    },
  },
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<localleader>gS",
        function()
          neogit().open()
        end,
        desc = "neogit: open status buffer",
      },
      {
        "<localleader>gc",
        function()
          neogit().open({ "commit" })
        end,
        desc = "neogit: open commit buffer",
      },
      {
        "<localleader>gl",
        function()
          neogit().popups.pull.create()
        end,
        desc = "neogit: open pull popup",
      },
      {
        "<localleader>gp",
        function()
          neogit().popups.push.create()
        end,
        desc = "neogit: open push popup",
      },
    },
    config = function()
      neogit().setup({
        disable_signs = false,
        disable_hint = true,
        disable_commit_confirmation = true,
        disable_builtin_notifications = true,
        disable_insert_on_commit = false,
        signs = {
          section = { "", "" }, -- "", ""
          item = { "▸", "▾" },
          hunk = { "樂", "" },
        },
        integrations = {
          diffview = true,
        },
      })

      meg.augroup("Neogit", {
        pattern = "NeogitPushComplete",
        callback = neogit().close,
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<localleader>gd", "<Cmd>DiffviewOpen<CR>", desc = "diffview: open", mode = "n" },
      { "gh", [[:'<'>DiffviewFileHistory<CR>]], desc = "diffview: file history", mode = "v" },
      {
        "<localleader>gh",
        "<Cmd>DiffviewFileHistory<CR>",
        desc = "diffview: file history",
        mode = "n",
      },
    },
    opts = {
      default_args = { DiffviewFileHistory = { "%" } },
      enhanced_diff_hl = true,
      hooks = {
        diff_buf_read = function()
          local opt = vim.opt_local
          opt.wrap, opt.list, opt.relativenumber = false, false, false
          opt.colorcolumn = ""
        end,
      },
      keymaps = {
        view = { q = "<Cmd>DiffviewClose<CR>" },
        file_panel = { q = "<Cmd>DiffviewClose<CR>" },
        file_history_panel = { q = "<Cmd>DiffviewClose<CR>" },
      },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    lazy = false,
    config = function()
      require("git-conflict").setup({
        disable_diagnostics = true,
      })

      meg.augroup("GitConflicts", {
        {
          event = { "User" },
          pattern = { "GitConflictDetected" },
          command = function(args)
            meg.notify("Conflicts detected.")
            vim.diagnostic.disable(args.buf)
            vim.cmd("LspStop")
            meg.nnoremap(
              "cq",
              "<cmd>GitConflictListQf<CR>",
              { desc = "git-conflict: send conflicts to qf", buffer = args.buf }
            )
            meg.nnoremap(
              "[c",
              "<cmd>GitConflictPrevConflict<CR>",
              { desc = "git-conflict: prev conflict", buffer = args.buf }
            )
            meg.nnoremap(
              "]c",
              "<cmd>GitConflictNextConflict<CR>",
              { desc = "git-conflict: next conflict", buffer = args.buf }
            )
          end,
        },
        {
          event = { "User" },
          pattern = { "GitConflictResolved" },
          command = function(args)
            meg.notify("Conflicts resolved.")
            vim.diagnostic.enable(args.buf)
            vim.cmd("LspStart")
            vim.cmd("cclose")
          end,
        },
      })
    end,
  },
  {
    "f-person/git-blame.nvim",
    cmd = {
      "GitBlameOpenCommitURL",
      "GitBlameOpenFileURL",
      "GitBlameCopyCommitURL",
      "GitBlameCopyFileURL",
      "GitBlameCopySHA",
    },
    keys = {
      { "<localleader>gB", "<Cmd>GitBlameOpenCommitURL<CR>", desc = "git blame: open commit url", mode = "n" },
    },
    init = function()
      vim.g.gitblame_enabled = 0
    end,
  },
  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      {
        "<localleader>gu",
        function()
          linker().get_buf_range_url("n")
        end,
        desc = "gitlinker: copy line to clipboard",
      },
      {
        "<localleader>gu",
        function()
          linker().get_buf_range_url("v")
        end,
        desc = "gitlinker: copy range to clipboard",
      },
      {
        "<localleader>go",
        function()
          linker().get_repo_url(browser_open())
        end,
        desc = "gitlinker: open in browser",
      },
      {
        "<localleader>go",
        function()
          linker().get_buf_range_url("n", browser_open())
        end,
        desc = "gitlinker: open current line in browser",
      },
      {
        "<localleader>go",
        function()
          linker().get_buf_range_url("v", browser_open())
        end,
        desc = "gitlinker: open current selection in browser",
      },
    },
    opts = {
      mappings = nil,
    },
  },
}
