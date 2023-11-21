-- https://github.com/stevearc/dressing.nvim

-- { == Configuration ==> =====================================================

require("dressing").setup({
  input = {
    insert_only = false,
    win_options = {
      sidescrolloff = 4,
      winblend = vim.o.winblend,
    },
    get_config = function()
      if vim.api.nvim_win_get_width(0) < 50 then return { relative = "editor" } end
    end,
  },
  select = {
    backend = { "fzf_lua", "telescope", "builtin" },
    telescope = require("telescope.themes").get_dropdown({
      previewer = false,
      border = nx.opts.float_win_border ~= "none" and true or false,
    }),
    builtin = {
      win_options = {
        winblend = vim.o.winblend,
      },
      border = nx.opts.float_win_border,
    },
    nui = {
      win_options = {
        winblend = vim.o.winblend,
      },
      border = nx.opts.float_win_border,
    },
  },
})
-- <== }

-- { == Highlights ==> ========================================================

nx.map({
  {
    "z=",
    function()
      local word = vim.fn.expand("<cword>")
      local suggestions = vim.fn.spellsuggest(word)
      vim.ui.select(
        suggestions,
        {},
        vim.schedule_wrap(function(selected)
          if selected then
            vim.cmd.normal({
              args = { "ciw" .. selected },
              bang = true,
            })
          end
        end)
      )
    end,
    desc = "Suggest word",
  },
  { "<Esc>", "<Esc>", "i" },
  { "<C-c>", "<Cmd>close<CR>", { "i", "x" } },
  { "q", "<Cmd>close<CR>", "x" },
}, { buffer = 0, ft = "DressingInput" })
-- <== }
