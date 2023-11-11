local status, illuminate = pcall(require, "illuminate")
if not status then return end

illuminate.configure({
  providers = {
    "lsp",
    "treesitter",
    "regex",
  },
  delay = 200,
  filetype_overrides = {},
  filetypes_denylist = {
    "dirvish",
    "fugitive",
  },
  filetypes_allowlist = {},
  modes_denylist = {},
  modes_allowlist = {},
  providers_regex_syntax_denylist = {},
  providers_regex_syntax_allowlist = {},
  under_cursor = true,
  large_file_cutoff = nil,
  large_file_overrides = nil,
  min_count_to_highlight = 1,
})

vim.cmd([[
  hi def IlluminatedWordText gui=underline,bold
  hi def IlluminatedWordRead gui=underline,bold,italic
  hi def IlluminatedWordWrite gui=underdashed,bold,inverse,italic
]])
