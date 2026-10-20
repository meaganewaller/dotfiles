-- Text-editing operators.
--
-- sort.nvim: `go{motion}` sorts lines, or the items within one line split
-- on its delimiter (`, | ; :` or whitespace), with natural number order.
-- `gogo` sorts the current line, `io`/`ao` select a sortable region, and
-- `]o`/`[o` jump between delimiters. `:Sort` wraps the builtin `:sort` for
-- multi-line ranges. `go` shadows the rarely used native "go to byte N".
--
-- Its README documents io/ao and ]o/[o, but the code defaults to is/as and
-- ]s/[s, which would clobber the native sentence text objects and
-- next/prev misspelling. Pinned to the documented keys.
vim.pack.add({
  { src = "https://github.com/sQVe/sort.nvim" },
})

require("sort").setup({
  mappings = {
    textobject = { inner = "io", around = "ao" },
    motion = { next_delimiter = "]o", prev_delimiter = "[o" },
  },
})
