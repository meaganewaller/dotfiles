-- https://github.com/luukvbaal/statuscol.nvim

-- { == Configuration ==> =====================================================

local builtin = require("statuscol.builtin")

require("statuscol").setup({
  setopt = true,
  thousands = false,
  relculright = false,
  ft_ignore = nil,
  bt_ignore = nil,
  segments = {
    { text = { "%C" }, click = "v:lua.ScFa" },
    { text = { "%s" }, click = "v:lua.ScSa" },
    {
      text = { " ", builtin.lnumfunc, " " },
      condition = { true, builtin.not_empty },
      click = "v:lua.ScLa",
    },
  },
  clickmod = "c",
  clickhandlers = {
    -- builtin click handlers
    Lnum = builtin.lnum_click,
    FoldClose = builtin.foldclose_click,
    FoldOpen = builtin.foldopen_click,
    FoldOther = builtin.foldother_click,
    DapBreakpointRejected = builtin.toggle_breakpoint,
    DapBreakpoint = builtin.toggle_breakpoint,
    DapBreakpointCondition = builtin.toggle_breakpoint,
    DiagnosticSignError = builtin.diagnostic_click,
    DiagnosticSignHint = builtin.diagnostic_click,
    DiagnosticSignInfo = builtin.diagnostic_click,
    DiagnosticSignWarn = builtin.diagnostic_click,
    GitSignsTopdelete = builtin.gitsigns_click,
    GitSignsUntracked = builtin.gitsigns_click,
    GitSignsAdd = builtin.gitsigns_click,
    GitSignsChange = builtin.gitsigns_click,
    GitSignsChangedelete = builtin.gitsigns_click,
    GitSignsDelete = builtin.gitsigns_click,
    gitsigns_extmark_signs_ = builtin.gitsigns_click,
  },
})
-- <== }
