vim.keymap.set({ "n", "x" }, "<Space>", "<Ignore>")
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local opts = { silent = true }

vim.keymap.set("n", "<Esc>", "<Cmd>noh<CR>", { desc = "search: Clear Highlights" })
vim.keymap.set("n", "<C-s>", "<Cmd>write<CR>", { desc = "edit: Write to file" })

vim.keymap.set("n", "<UP>", "<NOP>", opts)
vim.keymap.set("n", "<DOWN>", "<NOP>", opts)
vim.keymap.set("n", "<LEFT>", "<NOP>", opts)
vim.keymap.set("n", "<RIGHT>", "<NOP>", opts)

vim.keymap.set({ "n", "t", "v", "i", "" }, "<C-x>", "<cmd>echo &filetype<cr>", opts)

-- Use x and Del key for black hole register
vim.keymap.set("", "<Del>", '"_x', opts)
vim.keymap.set("", "x", '"_x', opts)

-- Paste over selected text
vim.keymap.set("v", "p", '"_dP', opts)

-- Window operations
vim.keymap.set("n", "<Leader>wv", "<C-w>v", { desc = "Window - Split Vertically" })
vim.keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Window - Split Horizontally" })
vim.keymap.set("n", "<leader>wm", "<cmd>WindowsMaximize<CR>", { desc = "Window - Maximize" })
vim.keymap.set("n", "<leader>wc", "<cmd>bdelete!<CR>", { desc = "Window - Close" })
vim.keymap.set({ "n", "x" }, "<C-h>", "<C-w>h", { desc = "window: Go left" })
vim.keymap.set({ "n", "x" }, "<C-j>", "<C-w>j", { desc = "window: Go down" })
vim.keymap.set({ "n", "x" }, "<C-k>", "<C-w>k", { desc = "window: Go up" })
vim.keymap.set({ "n", "x" }, "<C-l>", "<C-w>l", { desc = "window: Go right" })

-- Resize splits with alt+cursor keys
vim.keymap.set("n", "<M-Up>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<M-Down>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<M-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<M-Right>", ":vertical resize +2<CR>", opts)

-- Up/down motions
vim.keymap.set({ "n", "x", "o" }, "j", 'v:count ? "j" : "gj"', { expr = true })
vim.keymap.set({ "n", "x", "o" }, "k", 'v:count ? "k" : "gk"', { expr = true })

-- move lines
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Insert lines above/below without leaving normal mode
vim.keymap.set("n", "oo", "o<Esc>k", opts)
vim.keymap.set("n", "OO", "O<Esc>j", opts)

-- Escape in normal mode seems to tab
vim.keymap.set("n", "<esc>", "<NOP>", opts)

-- Indent
vim.keymap.set({ "x", "o" }, ">", ">gv", { desc = "edit: Increase indent" })
vim.keymap.set({ "x", "o" }, "<", "<gv", { desc = "edit: Decrease indent" })

-- Buffer navigation

-- Delete buffer
vim.keymap.set("n", "<c-w>", ":bd<CR>", opts)

-- Navigate buffers
vim.keymap.set("n", "bn", ":bnext<CR>", opts)
vim.keymap.set("n", "bl", ":bnext<CR>", opts)
vim.keymap.set("n", "bv", ":bprevious<CR>", opts)
vim.keymap.set("n", "bh", ":bprevious<CR>", opts)
vim.keymap.set("n", "BN", ":bprevious<CR>", opts)

vim.keymap.set("n", "<c-]>", ":bnext<CR>", opts)
vim.keymap.set("n", "<c-[>", "", opts)
vim.keymap.set("n", "<c-[>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<leader>wf", "<cmd>BufferPin<CR>", { desc = "Buffer - Pin" })
vim.keymap.set("n", "<leader>we", "<cmd>WindowsEqualize<CR>", { desc = "Window - Equalize" })

-- CHECK PLUGIN UPDATE
vim.keymap.set("n", "<leader>up", "<cmd>Lazy sync<CR>", { desc = "Update - Plugins" })
vim.keymap.set("n", "<leader>ut", "<cmd>TSUpdate<CR>", { desc = "Update - Treesitter" })

-- CREATE NEW BLANK BUFFER
vim.keymap.set("n", "<leader>n", "<cmd>enew<CR>", { desc = "Create New Buffer" })

-- Correct misspelled word / mark as correct
vim.keymap.set("i", "<C-S-L>", "<Esc>[szg`]a")
vim.keymap.set("i", "<C-l>", "<C-G>u<Esc>[s1z=`]a<C-G>u")
-- SPELL CHECK
vim.keymap.set("n", "wc", "z=", { desc = "Writer - Correct" })
vim.keymap.set("n", "wd", "zg", { desc = "Writer - Add to dictionary" })
vim.keymap.set("n", "wn", "]s", { desc = "Writer - Next Incorrect" })
vim.keymap.set("n", "wp", "[s", { desc = "Writer - Previous Incorrect" })

-- VIEW NOTIFY HISTORY
vim.keymap.set("n", "<leader>vn", "<cmd>Notifications<CR>", { desc = "View - Notifications History" })

-- BOOKMARKS
vim.keymap.set("n", "<leader>mt", "<cmd>BookmarkToggle<CR>", { desc = "Bookmark - Toggle" })
vim.keymap.set("n", "<leader>ma", "<cmd>BookmarkAnnotate ", { desc = "Bookmark - Annotation" })
vim.keymap.set("n", "<leader>mc", "<cmd>BookmarkClear<CR>", { desc = "Bookmark - Clear All" })
vim.keymap.set("n", "<leader>ms", "<cmd>BookmarkShowAll<CR>", { desc = "Bookmark - Bookmark Summary" })

-- -- CONFIG =====================================================
-- HLSLENS
vim.keymap.set("n", "<leader>chs", "<cmd>HlSearchLensToggle<CR>", { desc = "Highlight - Toggle Search" })
-- BAR
vim.keymap.set("n", "<leader>cbe", "<cmd>:ScrollViewEnable<CR>", { desc = "Scrollbar - Enable" })
vim.keymap.set("n", "<leader>cbd", "<cmd>:ScrollViewDisable<CR>", { desc = "Scrollbar - Disable" })
vim.keymap.set("n", "<leader>cbs", "<cmd>:ScrollViewRefresh<CR>", { desc = "Scrollbar - Sync" })
-- DISABLE HIGHLIGHT
vim.keymap.set("n", "<leader>chn", "<cmd>nohl<CR>", { desc = "Highlight - Disable" })
-- TOGGLE AUTO SAVE
vim.keymap.set("n", "<leader>cs", "<cmd>ASToggle<CR>", { desc = "Config - Toggle Autosave" })
-- LSP CONFIG
vim.keymap.set("n", "<leader>cl", "<cmd>Mason<CR>", { desc = "Config - LSP Config" })
-- SWITCH THEME
vim.keymap.set("n", "<leader>ctd", "<cmd>set background=dark<CR>", { desc = "Theme - Dark" })
vim.keymap.set("n", "<leader>ctl", "<cmd>set background=light<CR>", { desc = "Theme - Light" })
-- CLEAR SPELL CHECKER HIGHLIGHT
vim.keymap.set("n", "<leader>chc", "<cmd>highlight clear SpellBad<CR>", { desc = "Highlight - Clear Spell Checker" })
-- TOGGLE ILLUMINATE REUSED WORDS
vim.keymap.set("n", "<leader>chr", "<cmd>IlluminateToggle<CR>", { desc = "Highlight - Toggle Reused Words" })
-- AUTOWIDTH
vim.keymap.set("n", "<leader>cm", "<cmd>WindowsToggleAutowidth<CR>", { desc = "Config - Toggle Autowidth" })
-- INLINE FOLD
vim.keymap.set("n", "<leader>cf", "<cmd>InlineFoldToggle<CR>", { desc = "Config - Toggle Inline Fold" })

-- -- EXTENSIONS =================================================
-- MARKDOWN PREVIEW
vim.keymap.set("n", "<leader>pm", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Previews - Markdown" })
-- PLANTUML PREVIEW
vim.keymap.set("n", "<leader>ppo", "<cmd>PlantumlOpen<CR>", { desc = "PlantUML - Start Preview" })
vim.keymap.set("n", "<leader>ppp", "<cmd>PlantumlStop<CR>", { desc = "PLantUML - Stop Preview" })
vim.keymap.set("n", "<leader>pps", ":PlantumlSave", { desc = "PlantUML - Save to" })

-- Close all floating windows
vim.keymap.set("n", "q", function()
  local count = 0
  local current_win = vim.api.nvim_get_current_win()
  -- close current win only if it's a floating window
  if vim.api.nvim_win_get_config(current_win).relative ~= "" then
    vim.api.nvim_win_close(current_win, true)
    return
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local config = vim.api.nvim_win_get_config(win)
    -- close floating windows that can be focused
    if config.relative ~= "" and config.focusable then
      vim.api.nvim_win_close(win, false) -- do not force
      count = count + 1
    end
  end
  if count == 0 then -- Fallback
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("q", true, true, true), "n", false)
  end
end, { desc = "window: Close floating windows" })

vim.keymap.set(
  "t",
  "<C-x>",
  vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true),
  { desc = "terminal: Exit terminal mode" }
)

-- -- Multi-window operations
-- -- stylua: ignore start
-- vim.keymap.set({ 'x', 'n' }, '<M-W>',      '<C-w>W')
-- vim.keymap.set({ 'x', 'n' }, '<M-H>',      '<C-w>H')
-- vim.keymap.set({ 'x', 'n' }, '<M-J>',      '<C-w>J')
-- vim.keymap.set({ 'x', 'n' }, '<M-K>',      '<C-w>K')
-- vim.keymap.set({ 'x', 'n' }, '<M-L>',      '<C-w>L')
-- vim.keymap.set({ 'x', 'n' }, '<M-=>',      '<C-w>=')
-- vim.keymap.set({ 'x', 'n' }, '<M-_>',      '<C-w>_')
-- vim.keymap.set({ 'x', 'n' }, '<M-|>',      '<C-w>|')
-- vim.keymap.set({ 'x', 'n' }, '<M-<>',      '<C-w><')
-- vim.keymap.set({ 'x', 'n' }, '<M->>',      'v:count ? "<C-w>>" : "4<C-w>>"', { expr = true })
-- vim.keymap.set({ 'x', 'n' }, '<M-<>',      'v:count ? "<C-w><" : "4<C-w><"', { expr = true })
-- vim.keymap.set({ 'x', 'n' }, '<M-+>',      'v:count ? "<C-w>+" : "2<C-w>+"', { expr = true })
-- vim.keymap.set({ 'x', 'n' }, '<M-->',      'v:count ? "<C-w>-" : "2<C-w>-"', { expr = true })
-- vim.keymap.set({ 'x', 'n' }, '<M-p>',      '<C-w>p')
-- vim.keymap.set({ 'x', 'n' }, '<M-r>',      '<C-w>r')
-- vim.keymap.set({ 'x', 'n' }, '<M-v>',      '<C-w>v')
-- vim.keymap.set({ 'x', 'n' }, '<M-s>',      '<C-w>s')
-- vim.keymap.set({ 'x', 'n' }, '<M-x>',      '<C-w>x')
-- vim.keymap.set({ 'x', 'n' }, '<M-z>',      '<C-w>z')
-- vim.keymap.set({ 'x', 'n' }, '<M-c>',      '<C-w>c')
-- vim.keymap.set({ 'x', 'n' }, '<M-n>',      '<C-w>n')
-- vim.keymap.set({ 'x', 'n' }, '<M-o>',      '<C-w>o')
-- vim.keymap.set({ 'x', 'n' }, '<M-t>',      '<C-w>t')
-- vim.keymap.set({ 'x', 'n' }, '<M-T>',      '<C-w>T')
-- vim.keymap.set({ 'x', 'n' }, '<M-]>',      '<C-w>]')
-- vim.keymap.set({ 'x', 'n' }, '<M-^>',      '<C-w>^')
-- vim.keymap.set({ 'x', 'n' }, '<M-b>',      '<C-w>b')
-- vim.keymap.set({ 'x', 'n' }, '<M-d>',      '<C-w>d')
-- vim.keymap.set({ 'x', 'n' }, '<M-f>',      '<C-w>f')
-- vim.keymap.set({ 'x', 'n' }, '<M-}>',      '<C-w>}')
-- vim.keymap.set({ 'x', 'n' }, '<M-g>]',     '<C-w>g]')
-- vim.keymap.set({ 'x', 'n' }, '<M-g>}',     '<C-w>g}')
-- vim.keymap.set({ 'x', 'n' }, '<M-g>f',     '<C-w>gf')
-- vim.keymap.set({ 'x', 'n' }, '<M-g>F',     '<C-w>gF')
-- vim.keymap.set({ 'x', 'n' }, '<M-g>t',     '<C-w>gt')
-- vim.keymap.set({ 'x', 'n' }, '<M-g>T',     '<C-w>gT')
-- vim.keymap.set({ 'x', 'n' }, '<M-w>',      '<C-w><C-w>')
-- vim.keymap.set({ 'x', 'n' }, '<M-h>',      '<C-w><C-h>')
-- vim.keymap.set({ 'x', 'n' }, '<M-j>',      '<C-w><C-j>')
-- vim.keymap.set({ 'x', 'n' }, '<M-k>',      '<C-w><C-k>')
-- vim.keymap.set({ 'x', 'n' }, '<M-l>',      '<C-w><C-l>')
-- vim.keymap.set({ 'x', 'n' }, '<M-g><M-]>', '<C-w>g<C-]>')
-- vim.keymap.set({ 'x', 'n' }, '<M-g><Tab>', '<C-w>g<Tab>')
--
-- vim.keymap.set({ 'x', 'n' }, '<C-w>>', 'v:count ? "<C-w>>" : "4<C-w>>"', { expr = true })
-- vim.keymap.set({ 'x', 'n' }, '<C-w><', 'v:count ? "<C-w><" : "4<C-w><"', { expr = true })
-- vim.keymap.set({ 'x', 'n' }, '<C-w>+', 'v:count ? "<C-w>+" : "2<C-w>+"', { expr = true })
-- vim.keymap.set({ 'x', 'n' }, '<C-w>-', 'v:count ? "<C-w>-" : "2<C-w>-"', { expr = true })
-- -- stylua: ignore end
--
-- -- Up/down motions
-- vim.keymap.set({ 'n', 'x', 'o' }, 'j', 'v:count ? "j" : "gj"', { expr = true })
-- vim.keymap.set({ 'n', 'x', 'o' }, 'k', 'v:count ? "k" : "gk"', { expr = true })
--
-- -- Buffer navigation
-- vim.keymap.set('n', ']b', '<Cmd>exec v:count1 . "bn"<CR>')
-- vim.keymap.set('n', '[b', '<Cmd>exec v:count1 . "bp"<CR>')
--
-- -- Correct misspelled word / mark as correct
-- vim.keymap.set('i', '<C-S-L>', '<Esc>[szg`]a')
-- vim.keymap.set('i', '<C-l>', '<C-G>u<Esc>[s1z=`]a<C-G>u')
--
-- -- Only clear highlights and message area and don't redraw if search
-- -- highlighting is on to avoid flickering
-- vim.keymap.set('n', '<C-l>', function()
--   return vim.v.hlsearch == 1 and '<Cmd>nohlsearch<Bar>diffupdate<Bar>echo<CR>'
--     or '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-l><CR>'
-- end, { expr = true })
--
-- -- Don't include extra spaces around quotes
-- vim.keymap.set({ 'o', 'x' }, 'a"', '2i"', { noremap = false })
-- vim.keymap.set({ 'o', 'x' }, "a'", "2i'", { noremap = false })
-- vim.keymap.set({ 'o', 'x' }, 'a`', '2i`', { noremap = false })
--
-- -- Close all floating windows
-- vim.keymap.set('n', 'q', function()
--   local count = 0
--   local current_win = vim.api.nvim_get_current_win()
--   -- close current win only if it's a floating window
--   if vim.api.nvim_win_get_config(current_win).relative ~= '' then
--     vim.api.nvim_win_close(current_win, true)
--     return
--   end
--   for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
--     if vim.api.nvim_win_is_valid(win) then
--       local config = vim.api.nvim_win_get_config(win)
--       -- close floating windows that can be focused
--       if config.relative ~= '' and config.focusable then
--         vim.api.nvim_win_close(win, false) -- do not force
--         count = count + 1
--       end
--     end
--   end
--   if count == 0 then -- Fallback
--     vim.api.nvim_feedkeys(
--       vim.api.nvim_replace_termcodes('q', true, true, true),
--       'n',
--       false
--     )
--   end
-- end)
--
-- -- Text object: current buffer
-- -- stylua: ignore start
-- vim.keymap.set('x', 'af', ':<C-u>silent! keepjumps normal! ggVG<CR>', { silent = true, noremap = false })
-- vim.keymap.set('x', 'if', ':<C-u>silent! keepjumps normal! ggVG<CR>', { silent = true, noremap = false })
-- vim.keymap.set('o', 'af', '<Cmd>silent! normal m`Vaf<CR><Cmd>silent! normal! ``<CR>', { silent = true, noremap = false })
-- vim.keymap.set('o', 'if', '<Cmd>silent! normal m`Vif<CR><Cmd>silent! normal! ``<CR>', { silent = true, noremap = false })
-- -- stylua: ignore end
--
-- -- Abbreviations
-- utils.keymap.command_abbrev('S', '%s')
-- utils.keymap.command_abbrev(':', 'lua')
-- utils.keymap.command_abbrev('qa', 'qa!')
-- utils.keymap.command_abbrev('bw', 'bw!')
-- utils.keymap.command_abbrev('mks', 'mks!')
-- utils.keymap.command_abbrev('man', 'Man')
