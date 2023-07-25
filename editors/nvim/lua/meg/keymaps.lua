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

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local mappings = {}

-- Map save to Ctrl + S
vim.keymap.set('', '<c-s>', ':w<CR>', { remap = true, silent = true })
vim.keymap.set('i', '<c-s>', '<C-o>:w<CR>', { remap = true, silent = true })
vim.keymap.set('n', '<Leader>s', ':w<CR>', { silent = true })

-- Open vertical split
vim.keymap.set('n', '<Leader>v', '<C-w>w')

-- Move between splits
vim.keymap.set('n', '<c-h>', '<C-w>h')
vim.keymap.set('n', '<c-j>', '<C-w>j')
vim.keymap.set('n', '<c-k>', '<C-w>k')
vim.keymap.set('n', '<c-l>', '<C-w>l')
vim.keymap.set('n', '<c-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set('n', '<c-l>', '<C-\\><C-n><C-w>l')

vim.keymap.set('i', '<c-l>', '<c-g>u<Esc>1z=`]a<c-g>u')

-- Down is really the next line
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- Map for Escape key in terminal
vim.keymap.set('t', '<Leader>jj', '<C-\\><C-n>')

-- Clear search highlights
vim.keymap.set('n', '<Leader><space>', ':noh<CR>', { silent = true })

-- Stay on same position when searching word under cursor
vim.keymap.set('n', '*', '*N')
vim.keymap.set('n', '#', '#N')
vim.keymap.set('n', 'g*', 'g*N')
vim.keymap.set('n', 'g#', 'g#N')
vim.keymap.set('x', '*', [["yy/\V<C-R>=escape(getreg('y'), '\/?')<CR><CR>N]])
vim.keymap.set('x', '#', [["yy?\V<C-R>=escape(getreg('y'), '\/?')<CR><CR>N]])

vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

local mapping_group = vim.api.nvim_create_augroup('vimrc_terminal_mappings', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    -- Focus first file:line:col pattern in the terminal output
    vim.keymap.set('n', 'F', [[:call search('\f\+:\d\+:\d\+')<CR>]], { buffer = true, silent = true })
    vim.bo.bufhidden = 'wipe'
  end,
  group = mapping_group,
})

-- Copy to system clipboard
vim.keymap.set('v', '<C-c>', '"+y')
-- Paste from system clipboard with Ctrl + v
vim.keymap.set('i', '<C-v>', '<Esc>"+p')
vim.keymap.set('n', '<Leader>p', '"0p')
vim.keymap.set('v', '<Leader>p', '"0p')
vim.keymap.set('n', '<Leader>h', 'viw"0p', { nowait = false })

-- Move to the end of yanked text after yank and paste
vim.keymap.set('n', 'p', 'p`]')
vim.keymap.set('v', 'y', 'y`]')
vim.keymap.set('v', 'p', 'p`]')
-- Select last pasted text
vim.keymap.set('n', 'gp', "'`[' . strpart(getregtype(), 0, 1) . '`]'", { expr = true })

-- Move selected lines up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { silent = true })

-- Toggle between last 2 buffers
vim.keymap.set('n', '<leader><tab>', '<c-^>')

-- Indenting in visual mode
vim.keymap.set('x', '<s-tab>', '<gv')
vim.keymap.set('x', '<tab>', '>gv')

-- Resize window with shift + and shift -
vim.keymap.set('n', '_', '<c-w>5<')
vim.keymap.set('n', '+', '<c-w>5>')

-- Use Q to take nvim to background
vim.keymap.set('', 'Q', '<c-z>', { remap = true })

-- Jump to definition in vertical split
vim.keymap.set('n', '<Leader>]', '<C-W>v<C-]>')

-- Close all other buffers except current one
vim.keymap.set('n', '<Leader>db', ':silent w <BAR> :silent %bd <BAR> e#<CR>')

-- Unimpaired mappings
vim.keymap.set('n', '[q', ':cprevious<CR>', { silent = true })
vim.keymap.set('n', ']q', ':cnext<CR>', { silent = true })
vim.keymap.set('n', '[Q', ':copen<CR>', { silent = true })
vim.keymap.set('n', ']Q', ':cclose<CR>', { silent = true })
vim.keymap.set('n', '[e', ':lprevious<CR>', { silent = true })
vim.keymap.set('n', ']e', ':lnext<CR>', { silent = true })
vim.keymap.set('n', '[L', ':lopen', { silent = true })
vim.keymap.set('n', ']L', ':lclose<CR>', { silent = true })
vim.keymap.set('n', '[t', ':tprevious<CR>', { silent = true })
vim.keymap.set('n', ']t', ':tnext<CR>', { silent = true })
vim.keymap.set('n', '[T', ':tfirst<CR>', { silent = true })
vim.keymap.set('n', ']T', ':tlast<CR>', { silent = true })
vim.keymap.set('n', '[b', ':bprevious<CR>', { silent = true })
vim.keymap.set('n', ']b', ':bnext<CR>', { silent = true })
vim.keymap.set('n', '[B', ':bfirst<CR>', { silent = true })
vim.keymap.set('n', ']B', ':blast<CR>', { silent = true })

--rsi mappings
vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set('c', '<C-e>', '<End>')
vim.keymap.set('c', '<C-b>', '<End>')
vim.keymap.set('c', '<C-j>', 'wildmenumode() ? "<c-j>" : "<down>"', { expr = true, replace_keycodes = false })
vim.keymap.set('c', '<C-k>', 'wildmenumode() ? "<c-k>" : "<up>"', { expr = true, replace_keycodes = false })

vim.keymap.set('n', '<leader>T', function()
  return mappings.toggle_terminal()
end)
vim.keymap.set('t', '<leader>T', '<C-\\><C-n><C-w>c')

vim.keymap.set('n', 'gs', ':%s/')
vim.keymap.set('x', 'gs', ':s/')

vim.keymap.set('n', 'gx', function()
  vim.cmd([[
    unlet! g:loaded_netrw
    unlet! g:loaded_netrwPlugin
    runtime! plugin/netrwPlugin.vim
  ]])
  return vim.fn['netrw#BrowseX'](vim.fn.expand('<cfile>'), vim.fn['netrw#CheckIfRemote']())
end, { silent = true })

-- Taken from https://gist.github.com/romainl/c0a8b57a36aec71a986f1120e1931f20
for _, char in ipairs({ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' }) do
  vim.keymap.set('x', 'i' .. char, ':<C-u>normal! T' .. char .. 'vt' .. char .. '<CR>')
  vim.keymap.set('o', 'i' .. char, ':normal vi' .. char .. '<CR>')
  vim.keymap.set('x', 'a' .. char, ':<C-u>normal! F' .. char .. 'vf' .. char .. '<CR>')
  vim.keymap.set('o', 'a' .. char, ':normal va' .. char .. '<CR>')
end

local function close_buffer(bang)
  if vim.bo.buftype ~= '' then
    return vim.cmd.q({ bang = true })
  end

  local windowCount = vim.fn.winnr('$')
  local totalBuffers = #vim.fn.getbufinfo({ buflisted = 1 })
  local noSplits = windowCount == 1
  bang = bang and '!' or ''
  if totalBuffers > 1 and noSplits then
    local command = 'bp'
    if vim.fn.buflisted(vim.fn.bufnr('#')) then
      command = command .. '|bd' .. bang .. '#'
    end
    return vim.cmd(command)
  end
  return vim.cmd('q' .. bang)
end

local function open_file_on_line_and_column()
  local path = vim.fn.expand('<cfile>')
  local line = vim.fn.getline('.')
  local row = 1
  local col = 1
  if vim.fn.match(line, vim.fn.escape(path, '/') .. ':\\d*:\\d*') > -1 then
    local matchlist = vim.fn.matchlist(line, vim.fn.escape(path, '/') .. ':\\(\\d*\\):\\(\\d*\\)')
    row = matchlist[2] or 1
    col = matchlist[3] or 1
  end

  local buffers = vim.tbl_filter(function(entry)
    return entry.name:match(vim.pesc(path) .. '$') and vim.api.nvim_buf_get_option(entry.bufnr, 'buftype') == ''
  end, vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 }))

  local bufnr = -1
  local bufname = ''

  if #buffers == 0 then
    if vim.fn.filereadable(path) == 1 then
      vim.cmd('edit ' .. path)
      bufnr = vim.fn.bufnr('')
      bufname = vim.fn.bufname(bufnr)
    else
      return print('Unable to locate file/buffer for file ' .. path)
    end
  else
    bufnr = buffers[1].bufnr
    bufname = buffers[1].name
  end

  local winnr = vim.fn.bufwinnr(bufnr)
  if winnr < 0 then
    vim.cmd('vsplit ' .. bufname)
  else
    vim.cmd(winnr .. 'wincmd w')
  end
  vim.fn.cursor({ row, col })
end

local function open_file_or_create_new()
  local path = vim.fn.expand('<cfile>')
  if not path or path == '' then
    return false
  end

  if vim.bo.buftype == 'terminal' then
    return open_file_on_line_and_column()
  end

  if pcall(vim.cmd, 'norm!gf') then
    return true
  end

  vim.api.nvim_out_write('New file.\n')
  local new_path = vim.fn.fnamemodify(vim.fn.expand('%:p:h') .. '/' .. path, ':p')
  local ext = vim.fn.fnamemodify(new_path, ':e')

  if ext and ext ~= '' then
    return vim.cmd('edit ' .. new_path)
  end

  local suffixes = vim.fn.split(vim.bo.suffixesadd, ',')

  for _, suffix in ipairs(suffixes) do
    if vim.fn.filereadable(new_path .. suffix) then
      return vim.cmd('edit ' .. new_path .. suffix)
    end
  end

  return vim.cmd('edit ' .. new_path .. suffixes[1])
end

vim.keymap.set('n', 'gF', open_file_or_create_new)
vim.keymap.set('n', '<Leader>q', function()
  return close_buffer()
end)
vim.keymap.set('n', '<Leader>Q', function()
  return close_buffer(true)
end)

function mappings.paste_to_json_buffer()
  vim.cmd.vsplit()
  vim.cmd.enew()
  vim.bo.filetype = 'json'
  vim.cmd.norm({ '"+p', bang = true })
  vim.cmd.norm({ 'VGgq', bang = true })
end

local terminal_bufnr = 0
function mappings.toggle_terminal(close)
  if close then
    terminal_bufnr = 0
    return
  end
  if terminal_bufnr <= 0 then
    vim.api.nvim_create_autocmd('TermOpen', {
      pattern = '*',
      command = 'startinsert',
      once = true,
    })
    vim.cmd([[sp | term]])
    vim.cmd([[setlocal bufhidden=hide]])
    vim.api.nvim_create_autocmd('BufDelete', {
      pattern = '<buffer>',
      callback = function()
        mappings.toggle_terminal(true)
      end,
    })
    terminal_bufnr = vim.api.nvim_get_current_buf()
    return
  end

  local win = vim.fn.bufwinnr(terminal_bufnr)

  if win > -1 then
    vim.cmd(win .. 'close')
    return
  end

  vim.cmd('sp | b' .. terminal_bufnr .. ' | startinsert')
end

vim.api.nvim_create_user_command('Json', mappings.paste_to_json_buffer, { force = true })
return mappings


--nx.map({
--  { ";w", "<cmd>w<CR>", desc = "Write Buffer" },
--  { ";c", "function() MiniBufremove.delete(0, false) end", "", desc = "Close Buffer" },
--	{ ";C", "<Cmd>tabclose<CR>", "", desc = "Close Tab" },
--	{ ";q", "<Cmd>confirm quit<CR>", desc = "Close Window" },
--	{ ";Q", "<Cmd>confirm qa<CR>", desc = "Close Application" },
--	{ "ZQ", "<Cmd>confirm qa<CR>", desc = "Close Application" },
--
--	-- LINE NAVIGATION
--	{ { "j", "<Up>" }, "&wrap ? 'gj' : 'j'", "", expr = true, silent = true },
--	{ { "k", "<Down>" }, "&wrap ? 'gk' : 'k'", "", expr = true, silent = true },
--	{ "$", "&wrap ? 'g$' : '$'", "", expr = true, silent = true },
--	{ "^", "&wrap ? 'g^' : '^'", "", expr = true, silent = true },
--
--	-- Duplicate Lines
--	{ "<A-S-j>", '"yyy"yp', desc = "Duplicate Line Down" },
--	{ "<A-S-k>", '"yyy"yP', desc = "Duplicate Line Up" },
--	{ "<A-S-j>", "\"dy']\"dp`]'[V']", "v", desc = "Duplicate Lines Down" },
--	{ "<A-S-k>", "\"dy\"dP'[V']", "v", desc = "Duplicate Lines Up" },
--	-- Normal Mode
--	{ "<A-o>", 'o<Esc>^"_D', desc = "Add Blank Line Below" },
--	{ "<A-O>", 'O<Esc>^"_D', desc = "Add Blank Line Above" },
--	-- Indentation
--	-- NOTE: mapping <Tab> in normal mode == mapping <C-i>
--	{ "<S-Tab>", "<C-d>", "i", desc = "Outdent" },
--	-- Use correct indetation level when entering insert mode on empty lines
--	{ "i", "len(getline('.')) == 0 ? '\"_cc' : 'i'", expr = true, silent = true },
--	{ "a", "len(getline('.')) == 0 ? '\"_cc' : 'a'", expr = true, silent = true },
--	{ "A", "len(getline('.')) == 0 ? '\"_cc' : 'A'", expr = true, silent = true },
--	-- Preserve Selection when Indenting
--	{ "<Tab>", ">gv", "x", desc = "Indent" },
--	{ "<S-Tab>", "<gv", "v", desc = "Outdent" },
--	{ ">", ">gv", "v", desc = "Indent" },
--	{ "<", "<gv", "v", desc = "Outdent" },
--	-- Change Indent Size (requires tab indentation)
--	{ { "<M-S-.>", "<M->>", "<S-End>" }, "<Cmd>set ts+=1 sw=0 ts?<CR>", desc = "Increase Indentation Width" },
--	{ { "<M-S-,>", "<M-lt>", "<S-Home>" }, "<Cmd>set ts-=1 sw=0 ts?<CR>", desc = "Decrease Indentation Width" },
--
--	-- WINDOW NAVIGATION
--	-- Quick Switch Windows
--	{ "<C-w>1", "1<C-w><C-w>", desc = "Go to Window #1", wk_label = "ignore" },
--	{ "<C-w>2", "2<C-w><C-w>", desc = "Go to Window #2", wk_label = "ignore" },
--	{ "<C-w>3", "3<C-w><C-w>", desc = "Go to Window #3", wk_label = "ignore" },
--	{ "<C-w>4", "4<C-w><C-w>", desc = "Go to Window #4", wk_label = "ignore" },
--	{ "<C-w>5", "5<C-w><C-w>", desc = "Go to Window #5", wk_label = "ignore" },
--	-- Set Window Width to Colorcolumn (other predefined window width layouts are handled by windows.nvim)
--	{
--		"<C-w>b",
--		function()
--			---@param col "colorcolumn"|"numberwidth"|"signcolumn"
--			local function get_width(col)
--				local width = vim.api.nvim_get_option_value(col, { scope = "global" })
--				if col == "signcolumn" then width = width:match("[0-9]") end
--				return width
--			end
--			local widths = {
--				s = get_width("signcolumn"),
--				n = get_width("numberwidth"),
--				c = get_width("colorcolumn"),
--			}
--			vim.api.nvim_win_set_width(0, widths.s + widths.n + widths.c)
--		end,
--		desc = "Set Window Width to Colorcolumn",
--		silent = true,
--	},
--
--	-- TAB NAVIGATION
--	{ "<C-Tab>", "<Cmd>tabnext<CR>", "", desc = "Go to Next Tab", silent = true },
--	{ "<C-S-Tab>", "<Cmd>tabprevious<CR>", "", desc = "Go to Previous Tab", silent = true },
--	{ "<C-w>tt", "<Cmd>tabnew | lua MiniBufremove.delete(0, false)<CR>", desc = "New Tab", wk_label = "New" },
--	{ "<C-w>tc", "<Cmd>tabc<CR>", desc = "Close Current Tab", wk_label = "Close Current" },
--	{ "<C-w>tC", "<Cmd>tabo<CR>", desc = "Close All Other Tabs", wk_label = "Close All Other" },
--	{ "<C-w>c", "<Cmd>Bd<CR>", desc = "Close Buffer" },
--	{ "<C-w>q", "<Cmd>confirm quit<CR>", desc = "Quit Window" },
--
--	-- COMMANDLINE
--	{ "<C-n>", "<Down>", "c", desc = "Next Related Command History Item" },
--	{ "<C-p>", "<Up>", "c", desc = "Previous Related Command History Item" },
--	{ "<Down>", "<C-n>", "c", desc = "Next Command History Item" },
--	{ "<Up>", "<C-p>", "c", desc = "Previous Command History Item" },
--
--	-- SEARCH
--	{ "<C-c><C-c>", "<Cmd>noh<CR>", desc = "Clear Search Highlighting" },
--	{ "<Esc><Esc>", "<Cmd>noh<CR>", desc = "Clear Search Highlighting" },
--	{ "/", 'y/\\V<C-r>"<Esc>', "v", desc = "Search Selection" },
--
--	-- LEADER KEYMAPS
--	-- Config Quick Access
--	{ "<leader>,u", "<Cmd>e ~/.config/nvim/lua/meg/utils.lua<CR>", desc = "Open Utils" },
--	{ "<leader>,a", "<Cmd>e ~/.config/nvim/lua/meg/autocmds.lua<CR>", desc = "Open Autocmds" },
--	-- { "<leader>,i", "<Cmd>e ~/.config/nvim/init.lua<CR>", desc = "Open Init" },
--	{ "<leader>,,", "<Cmd>e ~/.config/nvim/lua/meg/init.lua<CR>", desc = "Open Init" },
--	{ "<leader>,o", "<Cmd>e ~/.config/nvim/lua/meg/options.lua<CR>", desc = "Open Options" },
--	{ "<leader>,w", "<Cmd>e ~/.config/nvim/lua/meg/plugins/which-key/init.lua<CR>", desc = "Which-Key" },
--	-- File
--	{ "<leader>fn", "<Cmd>ene!<CR>", desc = "New File" },
--	{ "<leader>fw", "<Cmd>noa w<CR>", desc = "Write Without Formatting" },
--	{ "<leader>fW", "<Cmd>w !sudo -A tee > /dev/null %<CR>", desc = "Write!" },
--	{
--		"<leader>fo",
--		"<Cmd>silent execute '!xdg-open ' . '%:p:h'<CR>",
--		desc = "Open File with System App",
--		wk_label = "System Open",
--	},
--	{
--		"<leader>fy",
--		"<Cmd>let @+ = expand('%')<CR>",
--		desc = "Yank Relative Path of Active File",
--		wk_label = "Yank Relative Path",
--	},
--	{
--		"<leader>fY",
--		"<Cmd>let @+ = expand('%:p')<CR>",
--		desc = "Yank Full Path of Active File",
--		wk_label = "Yank Full Path",
--	},
--	-- Toggles
--	{
--		"<leader>ts",
--		function()
--			vim.o.spell = not vim.o.spell
--			if vim.o.spell then
--				vim.notify("Spell On")
--			else
--				vim.notify("Spell Off")
--			end
--		end,
--		desc = "Toggle Spellcheck",
--		wk_label = "Spellcheck",
--	},
--	{
--		"<leader>tw",
--		function()
--			-- "<Cmd>set list! list?<CR>",
--			vim.o.list = not vim.o.list
--			if vim.o.list then
--				vim.notify("Whitespace Characters On")
--			else
--				vim.notify("Whitespace Characters Off")
--			end
--		end,
--		desc = "Toggle Whitespace Characters",
--		wk_label = "Whitespace Characters",
--	},
--	{
--		"<leader>tl",
--		function()
--			vim.o.wrap = not vim.o.wrap
--			vim.o.linebreak = vim.o.wrap
--			if vim.o.wrap then
--				vim.notify("Line Wrap On")
--			else
--				vim.notify("Line Wrap Off")
--			end
--		end,
--		desc = "Toggle Line Wrap",
--		wk_label = "Line Wrap",
--	},
--
--	-- F-KEYS
--	-- Equivalents in kitty to e.g., `<S-F3>` is `<F15>`
--	{
--		"<F6>",
--		function() vim.notify(string.format("Filetype: %s, Buftype: %s", vim.bo.filetype, vim.bo.buftype)) end,
--		desc = "Print File- and Buffertype",
--	},
--	{
--		"<F7>",
--		function()
--			vim.api.nvim_feedkeys("vgv", "v", false)
--			vim.schedule(function()
--				local cols = vim.fn.virtcol("'>") - vim.fn.virtcol("'<") + 1
--				vim.notify(string.format("Selected: %s", cols))
--			end)
--		end,
--		"v",
--		desc = "Print Selected Cols",
--	},
--	{
--		{ "<C-F5>", "<F29>" },
--		function()
--			if vim.o.cmdheight == 1 then
--				vim.o.cmdheight = 0
--			else
--				vim.o.cmdheight = 1
--			end
--		end,
--		"",
--		desc = "Toggle Command Line Height 0|1",
--	},
--
--	-- UTILITY
--	{ "<kEnter>", "<CR>", { "", "!" }, desc = "Enter" },
--	{ "<leader>`R", "<Cmd>ResetTerminal<CR>", desc = "Reset Terminal" },
--	{ "<C-c>", "<Esc>", desc = "Escape", "" },
--	{ "gV", "`[v`]", desc = "Select Last Pasted Text" },
--	-- 's/S' are Utilized for Plugins Like Surround / Hop
--	{ "s", "<nop>", "v" },
--	-- Preserve Selection on Increment / Decrement
--	{ "<C-a>", "<C-a>gv", "v", desc = "Increment" },
--	{ "<C-x>", "<C-x>gv", "v", desc = "Decrement" },
--	-- Undo Break Points
--	{ ",", ",<C-g>u", "i", desc = "Create Undo Breakpoint for ," },
--	{ ".", ".<C-g>u", "i", desc = "Create Undo Breakpoint for ." },
--	{ "!", "!<C-g>u", "i", desc = "Create Undo Breakpoint for !" },
--	{ "?", "?<C-g>u", "i", desc = "Create Undo Breakpoint for ?" },
--	{ "<SPACE>", "<SPACE><C-g>u", "i", desc = "Create Undo Breakpoint for <space>", wk_label = "<leader>" },
--
--	-- SCROLLING
--	-- Horizontal Scrolling
--	{ "<S-Right>", "2zl", desc = "Keyboard Scroll Viewport to the Right" },
--	{ "<S-Left>", "2zh", desc = "Keyboard Scroll Viewport to the Left" },
--	-- S-ScrollWheel works in GUIs and some TUIs (e.g., kitty)
--	{ "<S-ScrollWheelDown>", "<ScrollWheelRight>", "", desc = "Mouse Scroll Viewport to the Right" },
--	{ "<S-ScrollWheelUp>", "<ScrollWheelLeft>", "", desc = "Mouse Scroll Viewport to the Left" },
--	-- Increase scroll distance for <C-e> / <C-y>
--	-- For most clients they get overwritten by neoscroll anyway
--	{ "<C-e>", "6<C-e>", "", desc = "Scroll Down" },
--	{ "<C-y>", "6<C-y>", "", desc = "Scroll Up" },
--})
--
--nx.map({
--  -- Fix mouse scrolling when using scroll acceleration
--  { "<S-2-ScrollWheelDown>", "<2-ScrollWheelRight>", "" },
--  { "<S-3-ScrollWheelDown>", "<3-ScrollWheelRight>", "" },
--  { "<S-4-ScrollWheelDown>", "<4-ScrollWheelRight>", "" },
--  { "<S-2-ScrollWheelUp>", "<2-ScrollWheelLeft>", "" },
--  { "<S-3-ScrollWheelUp>", "<3-ScrollWheelLeft>", "" },
--  { "<S-4-ScrollWheelUp>", "<4-ScrollWheelLeft>", "" },
--}, { desc = "Fix: Scrolling with Acceleration" })
--
---- { == Filetype Keymaps ==> ==================================================
--
-----@param key string
--local function indent_new_line(key)
--	local line, indent_lvl = string.gsub(vim.api.nvim_get_current_line(), "\t", "")
--	local last_char = string.sub(line, -1)
--	if last_char == ":" or last_char == "=" then indent_lvl = indent_lvl + 1 end
--	return key .. string.rep("\t", indent_lvl)
--end
--
--nx.map({
--	{ "o", function() return indent_new_line("o") end },
--	{ "O", function() return indent_new_line("O") end },
--	{ "<CR>", function() return indent_new_line("<CR>") end, "i" },
--	{
--		"<Esc>",
--		function()
--			local trimmed_line = vim.api.nvim_get_current_line():match("^%s*(.*%S)") or ""
--			return trimmed_line == "" and "<Esc>g_<S-d>" or "<Esc>"
--		end,
--		"i",
--	},
--}, { expr = true, silent = true, ft = "nim" })
---- <== }
--
---- { == Plugin Keymaps ==> ====================================================
--
---- Plugin related keymaps are located inside the corresponding plugins config directory
---- "lua/nxvim/plugins/<pluginname>/keymaps.lua".
---- This modular approach aims for an uncluttered keymap configuration in case of removing or changing plugins.
---- <== }
--
--
---- "Undo chain" break points
---- local undo_break_points = { ".", ",", "!", "?", "=", "-", "_" }
----
---- local default_opts = {
----   noremap = true,
----   silent = true,
----   expr = false,
----   nowait = false,
----   script = false,
----   unique = false,
----   desc = nil,
---- }
----
---- local function set_undo_break_points(break_points)
----   for _, point in pairs(break_points) do
----     mw.mappings.i[point] = { point .. "<C-g>u" }
----   end
---- end
----
---- local function replaceTermcodes(str)
----   return vim.api.nvim_replace_termcodes(str, true, true, true)
---- end
----
---- local function set_keymap(mappings, mode, prefix)
----   if type(mappings) ~= "table" then
----     return
----   end
----
----   prefix = prefix or ""
----
----   if type(mappings[1]) == "string" then
----     local tree_opts = {
----       noremap = mappings.noremap,
----       silent = mappings.silent,
----       expr = mappings.expr,
----       nowait = mappings.nowait,
----       script = mappings.script,
----       unique = mappings.unique,
----     }
----     local opts = vim.tbl_deep_extend("force", default_opts, tree_opts)
----     vim.api.nvim_set_keymap(mode, prefix, mappings[1], opts)
----     return
----   end
----
----   for key, t in pairs(mappings) do
----     if key ~= "name" then
----       set_keymap(t, mode, prefix .. key)
----     end
----   end
---- end
----
---- local function set_mappings(mappings)
----   for mode, keymaps in pairs(mappings) do
----     set_keymap(keymaps, mode)
----   end
---- end
----
---- local function lua_cmd(plugin, modules, opts)
----   modules = modules or ""
----   opts = opts or ""
----
----   return string.format([[<CMD>lua %s.%s(%s)<CR>]], plugin, modules, opts)
---- end
----
---- local function telescope_picker(picker)
----   local config_path = [[require("meg.plugins.telescope_pickers")]]
----   return lua_cmd(config_path, picker)
---- end
----
---- mw.mappings = {
----   ["n"] = {
----     [";"] = {
----       ["w"] = { "<cmd>w<CR>", "Write Buffer" },
----       ["c"] = { function() MiniBufremove.delete(0, false) end, "Close Buffer" },
----       ["C"] = { "<cmd>tabclose<CR>", "Close Tab" },
----       ["q"] = { "<cmd>confirm quit<CR>", "Close Window" },
----       ["Q"] = { "<cmd>confirm qa<CR>", "Close Application" },
----     },
----     ["<C-w>"] = {
----       name = "Quick Switch Window",
----       ["1"] = { "1<C-w><C-w>", "Go to Window #1" },
----       ["2"] = { "2<C-w><C-w>", "Go to Window #2" },
----       ["3"] = { "3<C-w><C-w>", "Go to Window #3" },
----       ["4"] = { "4<C-w><C-w>", "Go to Window #4" },
----       ["5"] = { "5<C-w><C-w>", "Go to Window #5" },
----       ["b"] = {
----         function()
----           ---@param col "colorcolumn"|"numberwidth"|"signcolumn"
----           local function get_width(col)
----             local width = vim.api.nvim_get_option_value(col, { scope = "global" })
----             if col == "signcolumn" then width = width:match("[0-9]") end
----             return width
----           end
----           local widths = {
----             s = get_width("signcolumn"),
----             n = get_width("numberwidth"),
----             c = get_width("colorcolumn"),
----           }
----           vim.api.nvim_win_set_width(0, widths.s + widths.n + widths.c)
----         end,
----         "Set Window Width to ColorColumn"
----       },
----       ["tt"] = { "<Cmd>tabnew | lua MiniBufremove.delete(0, false)<CR>", "New Tab" },
----       ["tc"] = { "<Cmd>tabc<CR>", "Close Current Tab" },
----       ["tC"] = { "<cmd>tabo<CR>", "Close All Other Tabs" },
----       ["c"] = { "<cmd>Bd<CR>", "Close Buffer" },
----       ["q"] = { "<cmd>confirm quit<CR>", "Quit Window" },
----     },
----     ["<C-Tab>"] = { "<cmd>tabnext<CR>", "Go to Next Tab" },
----     ["<C-S-Tab>"] = { "<cmd>tabprevious<CR>", "Go to Previous Tab" },
----     ["j"] = { "&wrap ? 'gj' : 'j'" },
----     ["k"] = { "&wrap ? 'gk' : 'k'" },
----     ["^"] = { "&wrap ? 'g^' : '^'" },
----     ["<A-o>"] = { 'o<Esc>^"_D', "Add Blank Line Below" },
----     ["<A-O>"] = { 'O<Esc>^"_D', "Add Blank Line Above" },
----     ["*"] = { "*<cmd>lua require('hlslens').start()<CR>", "Search word under cursor" }, -- hlslens
----     ["#"] = { "#<CMD>lua require('hlslens').start()<CR>", "Search word under cursor backward" }, -- hlslens
----     ["<C-c><C-c>"] = { "<cmd>noh<CR>", "Clear Search Highlighting" },
----     ["<Esc><Esc>"] = { "<cmd>noh<CR>", "Clear Search Highlighting" },
----     ["]"] = {
----       ["["] = { nil,                                            "Next class start"                }, -- Assigned by nvim-treesitter-textobjects
----       ["]"] = { nil,                                            "Next class end"                  }, -- Assigned by nvim-treesitter-textobjects
----       ["a"] = { nil,                                            "Next parameter"                  }, -- Assigned by nvim-treesitter-textobjects
----       ["b"] = { "<CMD>bn<CR>",                                  "Next buffer"                     },
----       ["c"] = { "&diff ? ']c' : '<cmd>Gitsigns next_hunk<cr>'", "Next git hunk",      expr = true }, -- gitsigns.nvim
----       ["d"] = { "<CMD>lua vim.diagnostic.goto_next()<CR>",      "Next lsp diagnostic"             }, -- nvim-lspconfig
----       ["t"] = { "<CMD>tabnext<CR>",                             "Next tab"                        },
----     },
----     ["["] = {
----       ["["] = { nil,                                            "Previous class start"                }, -- Assigned by nvim-treesitter-textobjects
----       ["]"] = { nil,                                            "Previous class end"                  }, -- Assigned by nvim-treesitter-textobjects
----       ["a"] = { nil,                                            "Previous parameter"                  }, -- Assigned by nvim-treesitter-textobjects
----       ["b"] = { "<CMD>bp<CR>",                                  "Previous buffer"                     },
----       ["c"] = { "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<cr>'", "Previous git hunk",      expr = true }, -- gitsigns.nvim
----       ["d"] = { "<CMD>lua vim.diagnostic.goto_prev()<CR>",      "Previous lsp diagnostic"             }, -- nvim-lspconfig
----       ["t"] = { "<CMD>tabprevious<CR>",                         "Previous tab"                        }, -- Assigned by Hydra.nvim
----     },
----     ["<F1>"]  = { "<CMD>setlocal spell!<CR>",   "Toggle spelling"                           },
----     ["<F2>"]  = { [[:%s/\<<C-r><C-w>\>/]],      "Replace word under cursor", silent = false },
----     ["<F3>"]  = { "<CMD>set cursorcolumn!<CR>", "Toggle cursorcolumn"                       },
----     ["<F6>"] = {
----       function() vim.notify(string.format("Filetype: %s, Buftype: %s", vim.bo.filetype, vim.bo.buftype)) end,
----       "Print File and Buffertype"
----     },
----     ["<F11>"] = { "<CMD>set wrap!<CR>",         "Toggle wrap"                               },
----     ["g"] = {
----       ["*"] = { "*<CMD>lua require('hlslens').start()<CR>", "Search word under cursor"          }, -- hlslens
----       ["#"] = { "#<CMD>lua require('hlslens').start()<CR>", "Search word under cursor backward" }, -- hlslens
----       ["a"] = {
----         name = "Align",
----         ["T"] = {
----           [[:'<,'>Tabularize /^[^=]*\zs=<CR>:'<,'>GTabularize /\[\[\(.*\)\]\],\?\|"\([^"]*\)",\?\|--\s.*\zs\|.*{\slink\s=.*\zs\|\S\+/l0l1<CR>:'<,'>Tabularize /},\?$\|},\s--\s<CR>]],
----           "Lua tables"
----         }, -- Tabularize
----         ["t"] = { ":Tabularize ", "Tabularize", silent = false }, -- Tabularize
----       },
----       ["c"] = {
----         name = "Line comment",
----         ["A"] = { nil, "Add comment at the end of line" }, -- comment.nvim
----         ["c"] = { nil, "Comment out"                    }, -- comment.nvim
----         ["o"] = { nil, "Add comment on the line below"  }, -- comment.nvim
----         ["O"] = { nil, "Add comment on the line above"  }, -- comment.nvim
----       },
----       ["b"] = {
----         name = "Block comment",
----         ["c"] = { nil, "Comment out" }, -- comment.nvim
----       },
----     },
----     ["j"]     = { "v:count == 0 ? 'gj' : 'j'", "Move using displayed lines", expr = true },
----     ["k"]     = { "v:count == 0 ? 'gk' : 'k'", "Move using displayed lines", expr = true },
----     ["n"]     = { "<CMD>execute('normal! ' . v:count1 . 'n')<CR><CMD>lua MiniAnimate.execute_after('scroll', 'normal! zvzz'); require('hlslens').start()<CR><CMD>if &nu | set rnu | endif<CR>", "Repeat the latest '/' or '?'"           }, -- hlslens
----     ["N"]     = { "<CMD>execute('normal! ' . v:count1 . 'N')<CR><CMD>lua MiniAnimate.execute_after('scroll', 'normal! zvzz'); require('hlslens').start()<CR><CMD>if &nu | set rnu | endif<CR>", "Repeat the latest '/' or '?' backwards" }, -- hlslens
----     ["z"] = {
----       ["h"] = { nil, "Scroll the screen to the left"  }, -- Assigned using Hydra.nvim
----       ["l"] = { nil, "Scroll the screen to the right" }, -- Assigned using Hydra.nvim
----     },
----     ["<M-J>"] = { ":m .+1<CR>==", "Move line up"   },
----     ["<M-K>"] = { ":m .-2<CR>==", "Move line down" },
----     ["<Esc>"] = { [[:noh<CR>:lua require("notify").dismiss()<CR>:lua require("luasnip").unlink_current()<CR><Esc>]], "Clear search highlight" },
----     ["\\"] = {
----       ["b"] = {
----         name = "Buffer",
----         ["d"] = { "<cmd>Bdelete<CR>", "Delete buffer" }, -- bufdelete.nvim
----       },
----       ["i"] = { "<CMD>lua vim.show_pos()<CR>", "Show all the items at a given buffer position" },
----       ["l"] = {
----         name = "LSP alternative",
----         ["d"] = {
----           name = "Definitions",
----           ["t"] = { telescope_picker("lsp_definitions"), "Telescope" }, -- nvim-lspconfig -- telescope.nvim
----           ["q"] = { "<CMD>Trouble lsp_definitions<CR>",  "Trouble"   }, -- nvim-lspconfig -- trouble.nvim
----         },
----         ["i"] = {
----           name = "Implementations",
----           ["t"] = { telescope_picker("implementations"),    "Telescope" }, -- nvim-lspconfig -- telescope.nvim
----           ["q"] = { "<CMD>Trouble lsp_implementations<CR>", "Trouble"   }, -- nvim-lspconfig -- trouble.nvim
----         },
----         ["r"] = {
----           name = "References",
----           ["t"] = { telescope_picker("lsp_references"), "Telescope" }, -- nvim-lspconfig -- telescope.nvim
----           ["q"] = { "<CMD>Trouble lsp_references<CR>",  "Trouble"   }, -- nvim-lspconfig -- trouble.nvim
----         },
----         ["t"] = {
----           name = "Type Definitions",
----           ["t"] = { telescope_picker("lsp_type_definitions"), "Telescope" }, -- nvim-lspconfig -- telescope.nvim
----           ["q"] = { "<CMD>Trouble lsp_type_definitions<CR>",  "Trouble"   }, -- nvim-lspconfig -- trouble.nvim
----         },
----       },
----       ["q"] = { "<CMD>Bdelete<CR><CMD>quit<CR>",     "Delete buffer and close window" }, -- bufdelete.nvim
----       ["Q"] = { "<CMD>Bdelete<CR><CMD>tabclose<CR>", "Delete buffer and close tab"    }, -- bufdelete.nvim
----       ["t"] = {
----         name = "Tab",
----         ["}"] = { ":+tabmove<CR>",     "Move tab right"                },
----         ["{"] = { ":-tabmove<CR>",     "Move tab left"                 },
----         ["a"] = { "<CMD>tabnew<CR>",   "Create new tab"                },
----         ["c"] = { "<CMD>tabclose<CR>", "Close tab"                     },
----       },
----       ["u"] = {
----         name = "Utilities",
----         ["s"] = {
----           name = "Status",
----           ["l"] = { "<CMD>LspInfo<CR>",    "LSP info"       }, -- lsp-config
----           ["m"] = { "<CMD>Mason<CR>",      "Mason status"   }, -- mason.nvim
----           ["n"] = { "<CMD>NullLsInfo<CR>", "Null-ls info"   }, -- null-ls.nvim
----           ["p"] = { "<CMD>Lazy<CR>",       "Plugins status" }, -- lazy.nvim
----         },
----         ["u"] = {
----           name = "Update",
----           ["l"] = { "<CMD>Mason<CR><CMD>MasonToolsUpdate<CR>", "Update LSP packages"       }, -- mason-tool-installer.nvim
----           ["P"] = { "<CMD>Lazy update<CR>",                    "Update plugins"            }, -- lazy.nvim
----           ["p"] = { "<CMD>Lazy check<CR>",                     "Check for plugins updates" }, -- lazy.nvim
----         },
----       },
----     },
----     ["<Leader>"] = {
----       ["?"] = { "<Cmd>WhichKey<CR>", "Show available hotkeys"          }, -- which-key
----       ["."] = { "<CMD>Telescope resume<CR>",  "Reopen Telescope"       }, -- telescope.nvim
----       [","] = {
----         name = "Config Quick Access",
----         ["u"] = { "<cmd>e ~/.config/nvim/lua/meg/utils.lua<CR>", "Open Utils" },
----         ["a"] = { "<cmd>e ~/.config/nvim/lua/meg/autocmds.lua<CR>", "Open Autocmds" },
----         [","] = { "<cmd>e ~/.config/nvim/lua/meg/init.lua<CR>", "Open Init" },
----         ["o"] = { "<cmd>e ~/.config/nvim/lua/meg/options.lua<CR>", "Open Options" },
----         ["k"] = { "<cmd>e ~/.config/nvim/lua/meg/keymaps.lua<CR>", "Open Keymaps" },
----       },
----       ["b"] = { "<CMD>Telescope buffers<CR>", "Buffer list"            }, -- telescope.nvim
----       ["D"] = {
----         name = "Diff mode",
----         ["p"] = { ":diffpatch ",             "Patch the buffer with the requested file on a new buffer", silent = false, },
----         ["q"] = { "<CMD>diffoff<CR>",        "Revert and quit"                                                           },
----         ["R"] = { "<CMD>diffupdate<CR>",     "Updated the differences"                                                   },
----         ["t"] = { "<CMD>diffthis<CR>",       "Make the current window part of the diff windows"                          },
----         ["v"] = { ":vertical diffsplit ",    "Open the requested file in a split",                       silent = false, },
----         ["w"] = { "<CMD>windo diffthis<CR>", "Compare the visible files"                                                 },
----       },
----       ["e"] = {
----         name = "File, buffer and git explorer",
----         ["b"] = { "<CMD>Neotree buffers left focus reveal toggle<CR>",     "Toggle a list of currently open buffers"                           }, -- neo-tree.nvim
----         ["B"] = { "<CMD>Neotree buffers current<CR>",                      "Toggle a list of currently open buffers within the current window" }, -- neo-tree.nvim
----         ["e"] = { "<CMD>Neotree filesystem left focus reveal toggle<CR>",  "Toggle file explorer"                                              }, -- neo-tree.nvim
----         ["f"] = { "<CMD>NeoTreeFocus<CR>",                                 "Open or focus on file explorer"                                    }, -- neo-tree.nvim
----         ["E"] = { "<CMD>Neotree filesystem current<CR>",                   "Open file explorer within the current window"                      }, -- neo-tree.nvim
----         ["g"] = { "<CMD>Neotree git_status left focus reveal toggle <CR>", "Toggle git status in a floating window"                            }, -- neo-tree.nvim
----       },
----       ["f"] = {
----         name = "Files",
----         ["n"] = { "<cmd>ene!<cr>", "New File" },
----         ["w"] = { "<cmd>noa w<CR>", "Write without Formatting" },
----         ["W"] = { "<cmd>w !sudo -A tee > /dev/null %<CR>", "Write!" },
----         ["o"] = { "<cmd>silent execute '!xdg-open ' . '%:p:h'<CR>", "Open File with System App" },
----         ["y"] = { "<cmd>let @+ = expand('%')<CR>", "Yank Relative Path of Active File" },
----         ["Y"] = { "<Cmd>let @+ = expand('%:p')<CR>", "Yank Full Path of Active File" },
----       },
----       ["g"] = {
----         name = "Git",
----         ["b"] = {
----           name = "Git blame",
----           ["l"] = { "<CMD>Gitsigns toggle_current_line_blame<CR>",            "Toggle line blame" }, -- gitsigns.nvim
----           ["w"] = { "<CMD>lua require('gitsigns').blame_line{full=true}<CR>", "Show blame window" }, -- gitsigns.nvim
----         },
----         ["c"] = { "<CMD>Telescope git_commits<CR>",  "Commits"        }, -- telescope.nvim
----         ["C"] = { "<CMD>Telescope git_bcommits<CR>", "Buffer commits" }, -- telescope.nvim
----         ["g"] = {
----           name = "Git actions",
----           ["a"] = { "<CMD>Gitsigns stage_buffer<CR>",       "Stage buffer"    }, -- gitsigns.nvim
----           ["r"] = { "<CMD>Gitsigns reset_buffer<CR>",       "Reset buffer"    }, -- gitsigns.nvim
----           ["u"] = { "<CMD>Gitsigns undo_stage_hunk<CR>",    "Undo stage hunk" }, -- gitsigns.nvim
----         },
----         ["G"] = {
----           name = "Misc",
----           ["b"] = { "<CMD>Telescope git_branches<CR>", "Branches"  }, -- telescope.nvim
----           ["S"] = { "<CMD>Telescope git_stash<CR>",    "Stash"     }, -- telescope.nvim
----         },
----         ["h"] = {
----           name = "Git actions",
----           ["a"] = { "<CMD>Gitsigns stage_hunk<CR>",         "Stage hunk"      }, -- gitsigns.nvim
----           ["r"] = { "<CMD>Gitsigns reset_hunk<CR>",         "Reset hunk"      }, -- gitsigns.nvim
----           ["u"] = { "<CMD>Gitsigns reset_buffer_index<CR>", "Unstage buffer"  }, -- gitsigns.nvim
----         },
----         ["p"] = { "<CMD>Gitsigns preview_hunk_inline<CR>", "Preview hunk" }, -- gitsigns.nvim
----         ["s"] = { "<CMD>Telescope git_status<CR>",         "Status"       }, -- telescope.nvim
----         ["v"] = {
----           name = "Diff highlighting",
----           ["l"] = { "<CMD>Gitsigns toggle_linehl<CR>",    "Toggle line diff highlighting"     }, -- gitsigns.nvim
----           ["n"] = { "<CMD>Gitsigns toggle_numhl<CR>",     "Toggle number diff highlighting"   }, -- gitsigns.nvim
----           ["w"] = { "<CMD>Gitsigns toggle_word_diff<CR>", "Toggle word diff highlighting"     }, -- gitsigns.nvim
----           ["d"] = { "<CMD>Gitsigns toggle_deleted<CR>",   "Toggle deleted lines highlighting" }, -- gitsigns.nvim
----         },
----       },
----       ["l"] = {
----         name = "LSP",
----         ["a"] = { "<CMD>lua vim.lsp.buf.code_action()<CR>",            "Code actions"                          }, -- nvim-lspconfig
----         ["d"] = { "<CMD>Glance definitions<CR>",                       "Definitions"                           }, -- nvim-lspconfig -- glance.nvim
----         ["f"] = { "<CMD>lua vim.lsp.buf.format({ async = true })<CR>", "Format document"                       }, -- nvim-lspconfig
----         ["F"] = { "<CMD>LspToggleAutoFormat<CR>",                      "Toggle auto formatting"                }, -- nvim-lspconfig
----         ["h"] = { "<CMD>lua vim.diagnostic.open_float()<CR>",          "Line diagnostics"                      }, -- nvim-lspconfig
----         ["i"] = { "<CMD>Glance implementations<CR>",                   "Implementations"                       }, -- nvim-lspconfig -- glance.nvim
----         ["K"] = { "<CMD>lua vim.lsp.buf.hover()<CR>",                  "Hover symbol"                          }, -- nvim-lspconfig
----         ["q"] = { "<CMD>Trouble document_diagnostics<CR>",             "Document diagnostics"                  }, -- nvim-lspconfig -- trouble.nvim
----         ["Q"] = { "<CMD>Trouble workspace_diagnostics<CR>",            "Workspace diagnostics"                 }, -- nvim-lspconfig -- trouble.nvim
----         ["r"] = { "<CMD>Glance references<CR>",                        "References"                            }, -- nvim-lspconfig -- glance.nvim
----         ["R"] = { ":IncRename ",                                       "Rename symbol",         silent = false }, -- nvim-lspconfig -- inc-rename
----         ["s"] = { "<CMD>lua vim.lsp.buf.signature_help()<CR>",         "Signature help"                        }, -- nvim-lspconfig
----         ["t"] = { "<CMD>Glance type_definitions<CR>",                  "Type Definitions"                      }, -- nvim-lspconfig -- glance.nvim
----       },
----       ["o"] = { "<CMD>AerialToggle<CR>",  "Toggle Code outline"                  }, -- aerial.nvim
----       ["O"] = { "<CMD>AerialToggle!<CR>", "Toggle Code outline without focusing" }, -- aerial.nvim
----       ["q"] = {
----         name = "Trouble",
----         ["c"] = { "<CMD>TroubleClose<CR>",                  "Close"    }, -- trouble.nvim
----         ["f"] = { "<CMD>Trouble quickfix<CR>",              "Quickfix" }, -- trouble.nvim
----         ["l"] = { "<CMD>Trouble loclist<CR>",               "Loclist"  }, -- trouble.nvim
----         ["o"] = { "<CMD>Trouble<CR>",                       "Open"     }, -- trouble.nvim
----         ["q"] = { "<CMD>TroubleToggle<CR>",                 "Toggle"   }, -- trouble.nvim
----         ["R"] = { "<CMD>TroubleRefresh<CR>",                "Refresh"  }, -- trouble.nvim
----       },
----       ["r"] = { "<cmd>Telescope registers<CR>", "Registers"            }, -- telescope.nvim
----       ["s"] = {
----         name = "Search",
----         ["b"] = { telescope_picker("file_browser"), "File Browser" }, -- telescope.nvim
----         ["d"] = {
----           name = "Search in Directory",
----           ["g"] = { "<CMD>Telescope dir live_grep<CR>",  "ripGREP"     }, -- telescope.nvim -- dir-telescope.nvim
----           ["f"] = { "<CMD>Telescope dir find_files<CR>", "File search" }, -- telescope.nvim -- dir-telescope.nvim
----         },
----         ["f"] = { "<CMD>Telescope find_files<CR>",  "File search"             }, -- telescope.nvim
----         ["g"] = { "<CMD>Telescope live_grep<CR>",   "ripGREP"                 }, -- telescope.nvim
----         ["H"] = { "<CMD>Telescope highlights<CR>",  "Highlight groups"        }, -- telescope.nvim
----         ["h"] = { "<CMD>Telescope help_tags<CR>",   "Vim help"                }, -- telescope.nvim
----         ["n"] = { telescope_picker("notify"),       "Notify history"          }, -- telescope.nvimnvim -- notify
----         ["o"] = { "<CMD>Telescope vim_options<CR>", "Vim options"             }, -- telescope.nvim
----         ["R"] = { telescope_picker("frecency"),     "Frecency"                }, -- telescope.nvim
----         ["r"] = { telescope_picker("oldFiles"),     "Recent files"            }, -- telescope.nvim
----         ["S"] = { telescope_picker("luasnip"),      "List available snippets" }, -- telescope-luasnip.nvim
----         ["T"] = { "<CMD>TodoTelescope<CR>",         "Show TODO comments"      }, -- todo-comments
----         ["t"] = {
----           name = "Telescope",
----           ["b"] = { "<CMD>Telescope builtin<CR>",         "Telescope builtin" }, -- telescope.nvim
----           ["c"] = { "<CMD>Telescope command_history<CR>", "Command history"   }, -- telescope.nvim
----         },
----       },
----       ["u"] = { "<CMD>NeoTreeClose<CR><CMD>UndotreeToggle<CR>", "Toggle undo tree" }, -- undotree
----       ["<Leader>"] = {
----         name = "Launch",
----         ["l"] = { "<CMD>LaunchURL brave --new-tab<CR>", "Open URL under cursor in browser"       },
----         ["t"] = { "<CMD>terminal<CR>i",                   "Start a terminal session within Neovim" },
----       },
----     },
----     ["<LocalLeader>"] = {
----       ["t"] = {
----         name = "+ Test Runner",
----         ["n"] = { function() require("neotest").run.run() end, "Test Nearest" },
----         ["f"] = { function() require("neotest").run.run(vim.fn.expand("%")) end, "Test File" },
----         ["s"] = {
----           name = "+ Summary",
----           ["t"] = {
----             function()
----               require("neotest").summary.toggle()
----             end,
----             "Summary Toggle",
----           }
----         }
----       }
----       -- ["t"] = {
----       --   name = "Toggles",
----       --   ["s"] = {
----       --     function()
----       --       vim.o.spell = not vim.o.spell
----       --       if vim.o.spell then
----       --         vim.notify("Spell on")
----       --       else
----       --         vim.notify("Spell off")
----       --       end
----       --     end,
----       --     "Toggle spell checking"
----       --   },
----       --   ["w"] = {
----       --     function()
----       --       -- "<Cmd>set list! list?<CR>",
----       --       vim.o.list = not vim.o.list
----       --       if vim.o.list then
----       --         vim.notify("Whitespace Characters On")
----       --       else
----       --         vim.notify("Whitespace Characters Off")
----       --       end
----       --     end,
----       --     "Toggle whitespace characters"
----       --   },
----       --   ["l"] = {
----       --     function()
----       --       vim.o.wrap = not vim.o.wrap
----       --       vim.o.linebreak = vim.o.wrap
----       --       if vim.o.wrap then
----       --         vim.notify("Line Wrap On")
----       --       else
----       --         vim.notify("Line Wrap Off")
----       --       end
----       --     end,
----       --     "Toggle Line Wrap",
----       --   },
----       -- },
----     },
----   },
----   -- Visual mode mappings
----   ["v"] = {
----     ["/"] = { 'y/\\V<C-r>"<Esc>', "Search Selection" },
----     ["<F2>"]  = { [[y:%s/\V<C-r>"/]],             "Replace word under cursor", silent = false },
----     ["<F3>"]  = { "<CMD>set relativenumber!<CR>", "Toggle relative number"                    },
----     ["<M-J>"] = { ":m '>+1<CR>gv-gv",             "Move line up"                              },
----     ["<M-K>"] = { ":m '<-2<CR>gv-gv",             "Move line up"                              },
----     ["<Leader>"] = {
----       ["p"] = { '"_dP', "Keep yanked text after paste" },
----     },
----     ["<F7>"] = {
----       function()
----         vim.api.nvim_feedkeys("vgv", "v", false)
----         vim.schedule(function()
----           local cols = vim.fn.virtcol("'>") - vim.fn.virtcol("'<") + 1
----           vim.notify(string.format("Selected: %s", cols))
----         end)
----       end,
----       "Print Selected Cols"
----     },
----   },
----   -- Select mode mappings
----   ["s"] = {
----     ["<BS>"]  = { [[<BS>i]],  "Delete selection" }, -- Helpful when editing snippet placeholders
----     ["<C-h>"] = { [[<C-h>i]], "Delete selection" }, -- Helpful when editing snippet placeholders
----   },
----   -- Visual mode mappings
----   ["x"] = {
----     ["<Tab>"] = { ">gv", "Indent" },
----     ["g"] = {
----       ["a"] = {
----         name = "Align",
----         ["T"] = {
----           [[:Tabularize /^[^=]*\zs=<CR>:'<,'>GTabularize /\[\[\(.*\)\]\],\?\|"\([^"]*\)",\?\|--\s.*\zs\|.*{\slink\s=.*\zs\|\S\+/l0l1<CR>:'<,'>Tabularize /},\?$\|}\?$\|},\s--\s\S\+\|}\s--\s\S\+<CR>]],
----           "Lua tables",
----         }, -- Tabularize
----         ["t"] = { ":Tabularize ", "Tabularize", silent = false }, -- Tabularize
----       },
----       ["c"] = { nil, "Line comment"  }, -- comment.nvim
----       ["b"] = { nil, "Block comment" }, -- comment.nvim
----     },
----     ["i"] = {
----       ["g"] = {
----         name = "Git & gitsigns",
----         ["h"] = { ":<C-U>Gitsigns select_hunk<CR>", "Git hunk" }, -- gitsigns
----       },
----     },
----     ["<Leader>"] = {
----       ["gh"] = {
----         name = "Git & gitsigns",
----         ["a"] = { ":Gitsigns stage_hunk<CR>",       "Stage hunk"      }, -- gitsigns
----         ["r"] = { ":Gitsigns reset_hunk<CR>",       "Reset hunk"      }, -- gitsigns
----         ["v"] = { ":<C-U>Gitsigns select_hunk<CR>", "Select git hunk" }, -- gitsigns
----       },
----     },
----   },
----   -- Operator-pending mode mappings
----   ["o"] = {
----     ["i"] = {
----       ["g"] = {
----         name = "Git & gitsigns",
----         ["h"] = { ":<C-U>Gitsigns select_hunk<CR>", "Git hunk" }, -- gitsigns
----       },
----     },
----   },
----   -- Insert mode mappints
----   ["i"] = {
----     ["<F1>"]  = { "<CMD>setlocal spell!<CR>",               "Toggle spelling"                               },
----     ["<F3>"]  = { "<CMD>set cursorcolumn!<CR>",             "Toggle cursorcolumn"                           },
----     ["<C-j>"] = { "<CR>",                                   "Carriage return",              noremap = false }, -- Helpful with autopair plugins
----     ["<M-p>"] = { [[<C-r><C-o>+]],                          "Paste and stay in insert mode"                 },
----   },
----   -- Command-line mode mappings
----   ["c"] = {
----     ["<C-n>"] = { "<Down>", "Next Related Command History Item" },
----     ["<C-p>"] = { "<Up>", "Previous Related Command History Item" },
----     ["<M-H>"] = { "<Left>",    "Cursor left",           silent = false },
----     ["<M-L>"] = { "<Right>",   "Cursor right",          silent = false },
----     ["<M-h>"] = { "<S-Left>",  "Cursor one word left",  silent = false },
----     ["<M-l>"] = { "<S-Right>", "Cursor one word right", silent = false },
----   },
----   -- Terminal mode mappings
----   ["t"] = {
----     ["<Esc>"] = {
----       ["<Esc>"]    = { "<Esc>",                          "Escape Neovim insert mode"   },
----       ["<Leader>"] = { replaceTermcodes([[<C-\><C-N>]]), "Escape terminal insert mode" },
----     },
----     ["<C-w>"] = {
----       ["h"] = { replaceTermcodes([[<C-\><C-N><C-w>h]]), "Go to the left window"  },
----       ["j"] = { replaceTermcodes([[<C-\><C-N><C-w>j]]), "Go to the down window"  },
----       ["k"] = { replaceTermcodes([[<C-\><C-N><C-w>k]]), "Go to the up window"    },
----       ["l"] = { replaceTermcodes([[<C-\><C-N><C-w>l]]), "Go to the right window" },
----     },
----   },
---- }
----
---- set_undo_break_points(undo_break_points)
---- set_mappings(mw.mappings)
