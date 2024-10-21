-- Hard Hacker theme for Neovim (Lua)
vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "hardhacker"

if not vim.fn.has('gui_running') and vim.o.t_Co ~= "256" and not (vim.fn.has('termguicolors') and vim.o.termguicolors) then
  return
end

-- Default to not using darker variant unless specified
local darker = vim.g.hardhacker_darker or 0

-- Define palette
local palette = {
  bg_darker = "#211e2a",
  bg_dark = "#282433",
  fg = "#eee9fc",
  selection = "#3f3951",
  comment = "#938AAD",
  red = "#e965a5",
  green = "#b1f2a7",
  yellow = "#ebde76",
  blue = "#b1baf4",
  purple = "#e192ef",
  cyan = "#b3f4f3",
  black = "#000000",
  -- terminal colors
  bg2_darker = "234",
  bg2_dark = "235",
  fg2 = "255",
  selection2 = "238",
  comment2 = "243",
  red2 = "205",
  green2 = "157",
  yellow2 = "227",
  blue2 = "153",
  purple2 = "219",
  cyan2 = "123",
  black2 = "16",
  none = "NONE"
}

if darker == 1 then
  palette.bg = palette.bg_darker
  palette.bg2 = palette.bg2_darker
else
  palette.bg = palette.bg_dark
  palette.bg2 = palette.bg2_dark
end

-- Helper function for setting highlight groups
local function hi_group(group, termfg, termbg, guifg, guibg)
  vim.cmd(string.format(
    'hi %s ctermfg=%s ctermbg=%s cterm=NONE guifg=%s guibg=%s gui=NONE',
    group, termfg, termbg, guifg, guibg
  ))
end

local function load_hardhacker()
    -- Apply highlights
    hi_group('Cursor', palette.fg2, palette.red2, palette.fg, palette.red)
    hi_group('CursorLine', palette.none, palette.selection2, palette.none, palette.selection)
    hi_group('CursorLineNr', palette.purple2, palette.bg2, palette.purple, palette.bg2)
    hi_group('CursorColumn', palette.none, palette.bg2, palette.none, palette.bg)
    hi_group('ColorColumn', palette.none, palette.bg2, palette.none, palette.bg)

    hi_group('StatusLine', palette.fg2, palette.selection2, palette.fg, palette.selection)
    hi_group('StatusLineNC', palette.fg2, palette.bg2, palette.fg, palette.bg)
    hi_group('WildMenu', palette.none, palette.purple2, palette.none, palette.purple)

    hi_group('Pmenu', palette.fg2, palette.selection2, palette.fg, palette.selection)
    hi_group('PmenuSel', palette.black2, palette.purple2, palette.black, palette.purple)

    hi_group('Normal', palette.fg2, palette.bg2, palette.fg, palette.bg)
    hi_group('EndOfBuffer', palette.selection2, palette.bg2, palette.selection, palette.bg)
    hi_group('LineNr', palette.comment2, palette.bg2, palette.comment, palette.bg)
    hi_group('Visual', palette.none, palette.selection2, palette.none, palette.selection)

    -- Define foreground groups
    local function hi_fg_group(group, ctermfg, guifg)
        hi_group(group, ctermfg, palette.none, guifg, palette.none)
    end

    -- Define background groups
    local function hi_bg_group(group, ctermbg, guibg)
        hi_group(group, palette.none, ctermbg, palette.none, guibg)
    end

    -- Assign specific colors to highlight groups
    hi_fg_group('HardHacker_Red', palette.red2, palette.red)
    hi_fg_group('HardHacker_Purple', palette.purple2, palette.purple)
    hi_fg_group('HardHacker_Blue', palette.blue2, palette.blue)
    hi_fg_group('HardHacker_Yellow', palette.yellow2, palette.yellow)
    hi_fg_group('HardHacker_Cyan', palette.cyan2, palette.cyan)
    hi_fg_group('HardHacker_Green', palette.green2, palette.green)
    hi_fg_group('HardHacker_FG', palette.fg2, palette.fg)
    hi_bg_group('HardHacker_BG_Darker', palette.black2, palette.black)
    hi_bg_group('HardHacker_Selection', palette.selection2, palette.selection)

    hi_fg_group('Comment', palette.comment2, palette.comment)
    vim.cmd('hi! link String HardHacker_Green')
    vim.cmd('hi! link Constant HardHacker_Purple')
    vim.cmd('hi! link Number HardHacker_Yellow')
    vim.cmd('hi! link Function HardHacker_Blue')
    vim.cmd('hi! link Identifier HardHacker_Blue')
    vim.cmd('hi! link Conditional HardHacker_Red')
    vim.cmd('hi! link Keyword HardHacker_Red')
    vim.cmd('hi! link Type HardHacker_Cyan')
    vim.cmd('hi! link DiffAdd HardHacker_Green')

    -- Diagnostic Highlights (for Neovim)
    if vim.fn.has('nvim') then
        vim.cmd('hi! link DiagnosticError HardHacker_Red')
        vim.cmd('hi! link DiagnosticWarn HardHacker_Yellow')
        vim.cmd('hi! link DiagnosticInfo HardHacker_Cyan')
    end
end

load_hardhacker()
