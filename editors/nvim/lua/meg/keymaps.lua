--[[ Mode reference (see `:h map-table`)
┌──────┬──────┬─────┬─────┬─────┬─────┬─────┬──────┬──────┐
│ Mode │ Norm │ Ins │ Cmd │ Vis │ Sel │ Opr │ Term │ Lang │
├──────┼──────┼─────┼─────┼─────┼─────┼─────┼──────┼──────┤
│ ""   │     │  -  │  -  │    │    │    │  -   │  -   │
│ "n"  │     │  -  │  -  │  -  │  -  │  -  │  -   │  -   │
│ "!"  │  -   │    │    │  -  │  -  │  -  │  -   │  -   │
│ "i"  │  -   │    │  -  │  -  │  -  │  -  │  -   │  -   │
│ "c"  │  -   │  -  │    │  -  │  -  │  -  │  -   │  -   │
│ "v"  │  -   │  -  │  -  │    │    │  -  │  -   │  -   │
│ "x"  │  -   │  -  │  -  │    │  -  │  -  │  -   │  -   │
│ "s"  │  -   │  -  │  -  │  -  │    │  -  │  -   │  -   │
│ "o"  │  -   │  -  │  -  │  -  │  -  │    │  -   │  -   │
│ "t"  │  -   │  -  │  -  │  -  │  -  │  -  │     │  -   │
│ "l"  │  -   │    │    │  -  │  -  │  -  │  -   │     │
└──────┴──────┴─────┴─────┴─────┴─────┴─────┴──────┴──────┘
]]

-- { == Global Keymaps ==> ====================================================
local ok, legendary = pcall(require, "legendary")
if not ok then return end
-- Functions for multiple cursors
vim.g.mc = vim.api.nvim_replace_termcodes([[y/\V<C-r>=escape(@", '/')<CR><CR>]], true, true, true)

function SetupMultipleCursors()
  vim.keymap.set(
    "n",
    "<Enter>",
    [[:nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z]],
    { remap = true, silent = true }
  )
end

return legendary.keymaps({
  {
    "<C-x>",
    function() mw.float_term(nil, { cwd = nil, esc_esc = true }) end,
    description = "Open terminal",
    mode = { "n", "t" },
  },
  { "<C-y>", "<cmd>%y+<CR>", hide = true, description = "Copy buffer" },
  {
    "<C-s>",
    "<cmd>silent! write<CR>",
    hide = true,
    description = "Save buffer",
    mode = { "n", "i" },
  },

  -- Editing words
  { "<LocalLeader>,", "<cmd>norm A,<CR>", hide = true, description = "Append comma" },
  { "<LocalLeader>;", "<cmd>norm A;<CR>", hide = true, description = "Append semicolon" },

  {
    itemgroup = "Wrap text",
    icon = "",
    description = "Wrapping text functionality",
    keymaps = {
      {
        "<LocalLeader>(",
        { n = [[ciw(<c-r>")<esc>]], v = [[c(<c-r>")<esc>]] },
        description = "Wrap text in brackets ()",
      },
      {
        "<LocalLeader>[",
        { n = [[ciw[<c-r>"]<esc>]], v = [[c[<c-r>"]<esc>]] },
        description = "Wrap text in square braces []",
      },
      {
        "<LocalLeader>{",
        { n = [[ciw{<c-r>"}<esc>]], v = [[c{<c-r>"}<esc>]] },
        description = "Wrap text in curly braces {}",
      },
      {
        '<LocalLeader>"',
        { n = [[ciw"<c-r>""<esc>]], v = [[c"<c-r>""<esc>]] },
        description = 'Wrap text in quotes ""',
      },
    },
  },

  {
    itemgroup = "Find and Replace",
    icon = "",
    description = "Find and replace within the buffer",
    keymaps = {
      {
        "<LocalLeader>fw",
        [[:%s/\<<C-r>=expand("<cword>")<CR>\>/]],
        description = "Replace cursor words in buffer",
      },
      { "<LocalLeader>fl", [[:s/\<<C-r>=expand("<cword>")<CR>\>/]], description = "Replace cursor words in line" },
      -- {
      --   "<LocalLeader>f",
      --   ":s/{search}/{replace}/g",
      --   description = "Find and Replace (buffer)",
      --   mode = { "n", "v" },
      --   opts = { silent = false },
      -- },
    },
  },

  -- Working with lines
  { "B", "^", hide = true, description = "Beginning of a line", mode = { "n", "v" } },
  { "E", "$", hide = true, description = "End of a line", mode = { "n", "v" } },
  { "<CR>", "o<Esc>", hide = true, description = "Insert blank line below" },
  { "<S-CR>", "O<Esc>", hide = true, description = "Insert blank line above" },

  -- Moving lines
  {
    "<A-k>",
    {
      n = ":m .-2<CR>==",
      v = ":m '<-2<CR>gv=gv",
    },
    hide = true,
    description = "Move selection up",
    opts = { silent = true },
  },
  {
    "<A-j>",
    hide = true,
    {
      n = ":m .+1<CR>==",
      v = ":m '>+1<CR>gv=gv",
    },
    description = "Move selection down",
    opts = { silent = true },
  },

  -- Splits
  { "<LocalLeader>sv", "<C-w>v", description = "Split: Vertical" },
  { "<LocalLeader>sh", "<C-w>h", description = "Split: Horizontal" },
  { "<LocalLeader>sc", "<C-w>q", description = "Split: Close" },
  { "<LocalLeader>so", "<C-w>o", description = "Split: Close all but current" },

  -- Misc
  { "<Esc>", "<cmd>:noh<CR>", description = "Clear searches" },
  { "<S-w>", "<cmd>set winbar=<CR>", description = "Hide WinBar" },
  { "<LocalLeader>U", "gUiw`", description = "Capitalize word" },
  { ">", ">gv", hide = true, description = "Indent", mode = { "v" } },
  { "<", "<gv", hide = true, description = "Outdent", mode = { "v" } },

  -- Multiple Cursors
  -- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
  -- https://github.com/akinsho/dotfiles/blob/45c4c17084d0aa572e52cc177ac5b9d6db1585ae/.config/nvim/plugin/mappings.lua#L298

  -- 1. Position the cursor anywhere in the word you wish to change;
  -- 2. Or, visually make a selection;
  -- 3. Hit cn, type the new word, then go back to Normal mode;
  -- 4. Hit `.` n-1 times, where n is the number of replacements.
  {
    itemgroup = "Multiple Cursors",
    icon = "",
    description = "Working with multiple cursors",
    keymaps = {
      {
        "cn",
        {
          n = { "*``cgn" },
          x = { [[g:mc . "``cgn"]], opts = { expr = true } },
        },
        description = "Inititiate",
      },
      {
        "cN",
        {
          n = { "*``cgN" },
          x = { [[g:mc . "``cgN"]], opts = { expr = true } },
        },
        description = "Inititiate (in backwards direction)",
      },

      -- 1. Position the cursor over a word; alternatively, make a selection.
      -- 2. Hit cq to start recording the macro.
      -- 3. Once you are done with the macro, go back to normal mode.
      -- 4. Hit Enter to repeat the macro over search matches.
      {
        "cq",
        {
          n = { [[:\<C-u>call v:lua.SetupMultipleCursors()<CR>*``qz]] },
          x = { [[":\<C-u>call v:lua.SetupMultipleCursors()<CR>gv" . g:mc . "``qz"]], opts = { expr = true } },
        },
        description = "Inititiate with macros",
      },
      {
        "cQ",
        {
          n = { [[:\<C-u>call v:lua.SetupMultipleCursors()<CR>#``qz]] },
          x = {
            [[":\<C-u>call v:lua.SetupMultipleCursors()<CR>gv" . substitute(g:mc, '/', '?', 'g') . "``qz"]],
            opts = { expr = true },
          },
        },
        description = "Inititiate with macros (in backwards direction)",
      },
    },
  },
})


-- Leader key
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = ","
--
-- local opts = { noremap = true, silent = true }
-- local maps = vim.keymap.set
-- local M = {}
--
-- function M.tab()
--   maps({ "i", "n", "t", "v"}, "<C-i>", "<Tab>", { silent = true, remap = true })
--   maps({"n"}, "<ESC>", function() vim.cmd("noh") end, opts)
--   maps({'n'}, "<C-l>", function ()
--     local oldprint = print
--     print = require("plugin_dev_debug.print_to_buf").liveprint
--     vim.cmd("w | source %")
--     vim.schedule(function () print = oldprint end)
--   end, opts)
-- end
--
-- local choose_debug_session = function ()
--   if vim.bo.filetype == "lua" and not require("dap").session() then require("osv").run_this()
--   else require("dap").continue() end
-- end
--
-- M.debug_bindings = {
--   mappings = {
--     { 'n', "<Leader>b" },
--     { 'n', "<C-o>" },
--     { 'n', "<C-O>" },
--     { 'n', "<C-n>" },
--     { 'n', "<Leader>r" },
--     { 'n', "<Leader>c" },
--   },
--   callbacks = {
--     function () require("dap").toggle_breakpoint() end,
--     function () require("dap").step_over() end,
--     function () require("dap").step_out() end,
--     function () require("dap").step_into() end,
--     function () require("dap").repl.toggle() end,
--     function () choose_debug_session() end
--   }
-- }
--
-- M.debug = function()
--   for index, mapping in pairs(M.debug_bindings.mappings) do
--     maps(mapping[1], mapping[2], M.debug_bindings.callbacks[index], opts)
--   end
--   maps("n", "<leader>t", function()
--     vim.cmd([[TroubleToggle]])
--   end, opts)
-- end
--
-- M.terminal_mappings = function ()
--   local ft_cmds = {
--     python = "python3 " .. vim.fn.expand('%'),
--   }
--   local toggle_modes = {'n', 't'}
--   local mappings = {
--     { 'n', '<C-l>', function () require("nvterm.terminal").send(ft_cmds[vim.bo.filetype]) end },
--     { toggle_modes, '<A-h>', function () require("nvterm.terminal").toggle('horizontal') end },
--     { toggle_modes, '<A-v>', function () require("nvterm.terminal").toggle('vertical') end },
--     { toggle_modes, '<A-i>', function () require("nvterm.terminal").toggle('float') end },
--   }
--   return mappings
-- end
--
-- M.terminal = function()
--   maps("t", "<esc>", [[<C-\><C-n>]], opts)
--   maps("t", "jk", "<esc>", opts)
--   maps("t", "<C-w>h", [[<C-\><C-n><C-W>h]], opts)
--   maps("t", "<C-w>j", [[<C-\><C-n><C-W>j]], opts)
--   maps("t", "<C-w>k", [[<C-\><C-n><C-W>k]], opts)
--   maps("t", "<C-w>l", [[<C-\><C-n><C-W>l]], opts)
--   vim.tbl_map(function(mapping)
--     vim.keymap.set(mapping[1], mapping[2], mapping[3], opts)
--   end, M.terminal_mappings())
-- end
--
-- M.lsp = function ()
--   local lsp = vim.lsp.buf
--   local diag = vim.diagnostic
--   maps({"n"}, "gD", function() lsp.declaration() end, opts)
--   maps({"n"}, "gd", function() lsp.definition() end, opts)
--   maps({"n"}, "K", function() lsp.hover() end, opts)
--   maps({"n"}, "gi", function() lsp.implementation() end, opts)
--   maps({"n"}, "<C-k>", function() lsp.signature_help() end, opts)
--   maps({"n"}, "<leader>D", function() lsp.type_definition() end, opts)
--   maps({"n"}, "<leader>ra", function() lsp.rename() end, opts)
--   maps({"n"}, "<leader>ca", function() lsp.code_action() end, opts)
--   maps({"n"}, "gr", function() lsp.references({}) end, opts)
--   maps({"n"}, "<leader>f", function() diag.open_float() end, opts)
--   maps({"n"}, "[d", function() diag.goto_prev() end, opts)
--   maps({"n"}, "d]", function() diag.goto_next() end, opts)
--   maps({"n"}, "<leader>q", function() vim.diagnostic.setloclist() end, opts)
--   maps({"n"}, "<leader>fm", function() lsp.formatting() end, opts)
--   maps({"n"}, "<leader>wa", function() lsp.add_workspace_folder() end, opts)
--   maps({"n"}, "<leader>wr", function() lsp.remove_workspace_folder() end, opts)
--   maps({"n"}, "<leader>wl", function() print(vim.inspect(lsp.list_workspace_folders())) end, opts)
-- end
--
-- M.comment = function ()
--   maps({"n"}, "<leader>/", function()
--     require("Comment.api").toggle.linewise.current()
--   end, opts)
--   maps({"v"}, "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", opts)
-- end
--
-- M.set_all = function ()
--   M.tab()
--   M.lsp()
--   M.terminal()
--   M.comment()
--   M.debug()
-- end
--
-- return M
