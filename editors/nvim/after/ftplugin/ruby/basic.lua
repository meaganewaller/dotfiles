-- Check if b:erb_loaded exists and exit if true
if vim.b.erb_loaded then return end

-- Set foldmethod to 'indent'
vim.wo.foldmethod = "indent"

-- Set the compiler to 'ruby' and makeprg to 'ruby -wc %'
vim.bo.compiler = "ruby"
vim.bo.makeprg = "ruby -wc %"

-- Look up the word under the cursor on apidock
vim.api.nvim_buf_set_keymap(0, "n", "gm", ":Doc ruby<CR>", { noremap = true, buffer = true })

-- Check if the file type is 'rspec' and exit if true
if vim.bo.filetype:match("rspec") then return end

-- Define b:deleft_closing_pattern and b:outline_pattern
vim.bo.deleft_closing_pattern = "^s*end>"
vim.bo.outline_pattern = "\\v^\\s*(def|class|module|public|protected|private|(attr_\\k{-})|test)(\\s|$)"

-- Create folding settings using a Lua module (ruby-folding)
require("ruby-folding").create()

-- Disable folding (nofoldenable)
vim.wo.foldenable = false
