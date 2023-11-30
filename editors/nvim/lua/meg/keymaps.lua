local utils = require("meg.utils")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

utils.map("i", "<c-u>", "<Esc>viwUea", "Uppercase word under cursor")
utils.map("i", "<c-t>", "<Esc>b~lea", "Titlecase word under cursor")
utils.map("n", [[\d]], "<cmd>bprevious <bar> bdelete #<cr>", "Delete buffer", { silent = true  })

utils.map("n", "j", "v:count == 0 ? 'gj' : 'j'", "Move down", { expr = true })
utils.map("n", "k", "v:count == 0 ? 'gk' : 'k'", "Move up", { expr = true })
utils.map("n", "^", "g^", "Move to first non-blank character of line")
utils.map("n", "$", "g$", "Move to end of line")
utils.map("n", "0", "g0", "Move to first character of line")

utils.map("x", "$", "g_", "Move to end of line")
utils.map({"n", "x"}, "H", "^", "Move to first character of line")
utils.map({"n", "x"}, "L", "g_", "Move to end of line")

utils.map("x", "<", "<gv", "Shift left")
utils.map("x", ">", ">gv", "Shift right")

utils.map("n", "/", [[/\v]])
utils.map("n", "<Leader>cd", "<cmd>lcd %:p:h<CR>", "Change directory to current file")
utils.map("t", "<Esc>", "<C-\\><C-n>", "Exit terminal mode")

utils.map("n", "<Leader>y", "<cmd>%yank<cr>", "Yank entire file")

utils.map("n", "<A-k>", "<cmd>m .-2<cr>==", "Move line up")
utils.map("n", "<A-j>", "<cmd>m .+1<cr>==", "Move line down")

utils.map("x", "<A-k>", "<cmd>m '<-2<cr>gv=gv", "Move line up")
utils.map("x", "<A-j>", "<cmd>m '>+1<cr>gv=gv", "Move line down")

utils.map("x", "p", '"_c<Esc>p', "Paste over selection")

utils.map({ "x", "o" }, "iu", "<cmd>call text_obj#URL()<CR>", "Select URL")
utils.map({ "x", "o" }, "iB", "<cmd>call text_obj#Buffer()<cr>", "Select buffer")

utils.map("n", "J", function()
  vim.cmd([[
    normal! mzJ`z
    delmarks z
  ]])
end, "Join lines")

utils.map("n", "gJ", function()
  vim.cmd([[
    normal! mzgJ`z
    delmarks z
  ]])
end, "Join lines without spaces")

utils.map("i", "<A-;>", "<Esc>A;<Esc>", "Insert semicolon at end of line")
utils.map("i", "<A-:>", "<Esc>A:<Esc>", "Insert colon at end of line")
utils.map("i", "<C-A>", "<HOME>", "Move to beginning of line")
utils.map("i", "<C-E>", "<END>", "Move to end of line")

utils.map("i", "<C-D>", "<DEL>", "Delete character to right of the cursor")

utils.map("n", "<Leader>cb", function()
  local cnt = 0
  local blink_times = 7
  local timer = vim.loop.new_timer()

  timer:start(0, 100, vim.schedule_wrap(function()
    if cnt % 2 == 0 then
      vim.cmd("set cursorline")
    else
      vim.cmd("set nocursorline")
    end

    cnt = cnt + 1
    if cnt == blink_times then
      timer:stop()
      vim.cmd("set nocursorline")
    end
  end))
end, "Blink cursor")


-- local which_key_ok, which_key = pcall(require, "which-key")
-- if which_key_ok then
--   which_key.register({
--     ["<leader>"] = {
--       ['<leader>'] = { "<cmd>WhichKey<CR>", "WhichKey bindings" },
--       b = {
--         name = "+buffer",
--       },
--       c = {
--         name = "+code",
--       },
--       e = {
--         name = "+edit",
--       },
--       d = {
--         name = "+debug",
--       },
--       f = {
--         name = "+find",
--       },
--       g = {
--         name = "+git",
--       },
--       h = {
--         name = "+help",
--       },
--       l = {
--         name = "+list",
--       },
--       p = {
--         name = "+project",
--       },
--       w = {
--         name = "+window",
--       },
--       s = {
--         name = '+session',
--       },
--       t = {
--         name = "+toggle",
--       },
--       ["<tab>"] = {
--         name = '+tabs',
--       },
--       m = {
--         name = '+misc',
--       },
--       o = {
--         name = '+open',
--       },
--       q = {
--         name = '+quit',
--       },
--     },
--   })
--
--   which_key.register({
--     ['<localleader>'] = {
--       ['<localleader>'] = { name = '+localleader' },
--       s = {
--         name = "+search",
--       },
--     }
--   })
--
--   --   [','] = {
--   --     name = "+localleader",
--   --     w = { "<cmd>w<CR>", "Save file" },
--   --     p = { "\"+p", "Paste from system clipboard" },
--   --     P = { "<cmd>call mdip#MarkdownClipboardImage()<CR>", "Paste image" },
--   --     y = { "\"+y", "Copy to system clipboard" },
--   --     t = {
--   --       name = "+terminal",
--   --     },
--   --     f = {
--   --       name = "+format",
--   --       j = { name = "+json (jq formatter)" }
--   --     },
--   --   }
--   -- })
--
--   --   ["["] = { name = "+prev" },
--   --   ["]"] = { name = "+next" },
--   --   ["g"] = { name = "+goto" },
--   --   ["<leader>"] = {
--   --     name = "+<leader>",
--   --     ["<leader>"] = {
--   --       name = "+<leader>"
--   --     },
--   --     ["f"] = {
--   --       name = "+find",
--   --       b = { name = "+buffers" },
--   --       ["d"] = { name = "+debug" },
--   --     },
--   --     ["g"] = {
--   --       name = "+git",
--   --       ["d"] = { name = "+diffview" },
--   --     },
--   --     ["s"] = {
--   --       name = "+session",
--   --       ["c"] = { name = "+current" },
--   --     },
--   --     ["b"] = {
--   --       name = custom.prefer_tabpage and "+tab" or "+buffer",
--   --       ["s"] = { name = "+sort" },
--   --     },
--   --     ["l"] = {
--   --       name = "+lsp",
--   --       ["w"] = { name = "+workspace" },
--   --     },
--   --     ["i"] = { name = "+insert" },
--   --     ["m"] = { name = "+manage" },
--   --     ["r"] = { name = "+tasks" },
--   --     ["d"] = { name = "+debug" },
--   --     ["t"] = { name = "+toggle" },
--   --     ["h"] = { name = "+helper" },
--   --     ["q"] = { name = "+quickfix" },
--   --   },
--   -- })
-- end
-- --
-- -- local function toggle_quickfix()
-- --   local wins = vim.fn.getwininfo()
-- --   local qf_win = vim
-- --     .iter(wins)
-- --     :filter(function(win)
-- --       return win.quickfix == 1
-- --     end)
-- --     :totable()
-- --   if #qf_win == 0 then
-- --     vim.cmd.copen()
-- --   else
-- --     vim.cmd.cclose()
-- --   end
-- -- end
-- --
-- -- vim.keymap.set("n", "<leader>q", toggle_quickfix, { desc = "Quickfix" })
-- -- vim.keymap.set("n", "<leader>tq", toggle_quickfix, { desc = "Quickfix" })
-- -- vim.keymap.set("n", "<leader>hi", function()
-- --   vim.show_pos()
-- -- end, { desc = "Inspect" })
-- -- vim.keymap.set("n", "<leader>ht", function()
-- --   vim.treesitter.inspect_tree()
-- -- end, { desc = "Treesitter Tree" })
-- -- vim.keymap.set("n", "<leader>hq", function()
-- --   vim.treesitter.query.edit()
-- -- end, { desc = "Treesitter Query" })
-- --
-- -- -- Provided by nvim-next
-- -- -- vim.keymap.set("n", "[q", "<Cmd>cprevious<CR>", {})
-- -- -- vim.keymap.set("n", "]q", "<Cmd>cnext<CR>", {})
-- --
-- -- local filetype_keymaps = vim.api.nvim_create_augroup("meaganewaller_filetype_keymaps", {})
-- -- vim.api.nvim_create_autocmd("Filetype", {
-- --   group = filetype_keymaps,
-- --   pattern = "qf",
-- --   callback = function(args)
-- --     local bufnr = args.buf
-- --     vim.keymap.set("n", "q", "<Cmd>cclose<CR>", { buffer = bufnr })
-- --   end,
-- -- })
