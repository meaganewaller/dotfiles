vim.opt.viewoptions:remove "curdir"
vim.opt.shortmess:append { s = true, I = true }
vim.opt.backspace:append { "nostop" }
vim.opt.diffopt:append "linematch:60"

local options = {
  opt = {
    clipboard = "unnamedplus",
    breakindent = true,
    cmdheight = 0,
    completeopt = { "menu", "menuone", "noselect" },
    copyindent = true,
    cursorline = true,
    expandtab = true,
    fileencoding = "utf-8",
    fillchars = { eob = " ", fold = " ", foldclose = "", foldopen = " ", foldsep = " " },
    foldenable = true,
    foldlevel = 99,
    foldlevelstart = 99,
    foldcolumn = vim.fn.has "nvim-0.9" == 1 and "1" or nil, -- show foldcolumn in nvim 0.9+.
    ignorecase = true, -- Case insensitive searching.
    infercase = true, -- Infer cases in keyword completion.
    laststatus = 3, -- globalstatus.
    linebreak = true, -- Wrap lines at'breakat'.
    number = true, -- Show numberline.
    preserveindent = true, -- Preserve indent structure as much as possible.
    pumheight = 10, -- Height of the pop up menu.
    relativenumber = false, -- Show relative numberline.
    shiftwidth = 2, -- Number of space inserted for indentation.
    showmode = false, -- Disable showing modes in command line.
    showtabline = 2, -- always display tabline.
    signcolumn = "yes", -- Always show the sign column.
    smartcase = true, -- Case sensitivie searching.
    smartindent = false, -- Smarter autoindentation.
    splitbelow = true, -- Splitting a new window below the current one.
    splitright = true, -- Splitting a new window at the right of the current one.
    tabstop = 2, -- Number of space in a tab.
    termguicolors = true, -- Enable 24-bit RGB color in the TUI.
    timeoutlen = 500, -- Shorten key timeout length a little bit for which-key.
    undofile = true, -- Enable persistent undo between session and reboots.
    updatetime = 300, -- Length of time to wait before triggering the plugin.
    virtualedit = "block", -- allow going past end of line in visual block mode.
    writebackup = false, -- Disable making a backup before overwriting a file.
    shada = "!,'1000,<50,s10,h", -- Remember the last 1000 opened files
    undodir = vim.fn.stdpath "data" .. "/undodir", -- Chooses where to store the undodir.
    history = 1000, -- Number of commands to remember in a history table (per buffer).
    swapfile = false, -- Ask what state to recover when opening a file that was not saved.
    wrap = true, -- Disable wrapping of lines longer than the width of window.
    colorcolumn = "80", -- PEP8 like character limit vertical bar.
    mouse = "a", -- Enable mouse support.
    mousescroll = "ver:1,hor:0", -- Disables hozirontal scroll in neovim.
    guicursor = "n:blinkon200,i-ci-ve:ver25", -- Enable cursor blink.
    autochdir = true, -- Use current file dir as working dir (See project.nvim).
    scrolloff = 1000, -- Number of lines to leave before/after the cursor when scrolling. Setting a high value keep the cursor centered.
    sidescrolloff = 8, -- Same but for side scrolling.
    selection = "old", -- Don't select the newline symbol when using <End> on visual mode.
  },
  g = {
    mapleader = " ", -- Set leader key.
    maplocalleader = ",", -- Set default local leader key.
    autoformat_enabled = false, -- Enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled).
    autopairs_enabled = false, -- Enable autopairs at start.
    inlay_hints_enabled = false, -- Enable LSP inlay_hints at startup.
    semantic_tokens_enabled = true, -- Enable LSP semantic tokens on startup.
    cmp_enabled = true, -- Enable completion at start.
    codelens_enabled = true, -- Enable or disable automatic codelens refreshing for lsp that support it.
    diagnostics_mode = 3, -- Set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on).
    highlighturl_enabled = true, -- Highlight URLs by default.
    icons_enabled = true, -- Disable icons in the UI (disable if no nerd font is available).
    lsp_handlers_enabled = true, -- Enable or disable default vim.lsp.handlers (hover and signatureHelp).
    notifications_enabled = true, -- nvim notifications enabled/disabled.
    big_file = { size = 1024 * 100, lines = 10000 },
  },
  t = vim.t.bufs and vim.t.bufs or { bufs = vim.api.nvim_list_bufs() }
}

for scope, table in pairs(options) do
  for setting, value in pairs(table) do
    vim[scope][setting] = value
  end
end
