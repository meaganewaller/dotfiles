-- https://github.com/jcdickinson/codeium.nvim
nx.au({
  "FileType",
  pattern = "TelescopePrompt",
  callback = function()
    vim.cmd("Codeium DisableBuffer")
  end,
})

nx.hl({ "CodeiumSuggestion", fg = "SpecialComment:fg", bold = nx.opts.second_font, italic = true })

nx.map({
  "<Tab>",
  function()
    return vim.fn["codeium#Accept"]()
  end,
  "i",
  expr = true,
})

vim.cmd("Codeium Enable")
