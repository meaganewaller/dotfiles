-- https://github.com/luukvbaal/statuscol.nvim

-- { == Configuration ==> =====================================================

local builtin = require("statuscol.builtin")

require("statuscol").setup({
  ft_ignore = { "vim" },
  bt_ignore = { "nofile" },
  segments = {
    {
      sign = {
        name = { "Diagnostic" },
        maxwidth = 1,
        colwidth = 2,
      },
      click = "v:lua.ScSa",
    },
    {
      text = { "%s" },
      click = "v:lua.ScSa",
    },
    {
      text = { builtin.lnumfunc, " " },
      condition = { true, builtin.not_empty },
      click = "v:lua.ScLa",
    },
    {
      text = { builtin.foldfunc },
      condition = { true, builtin.not_empty },
      click = "v:lua.ScFa",
    },
    {
      sign = {
        name = { "GitSigns" },
        colwidth = 1,
      },
      click = "v:lua.ScSa",
    },
  },
})
