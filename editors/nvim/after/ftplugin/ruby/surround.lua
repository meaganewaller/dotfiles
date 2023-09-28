-- Define surround mappings for <foo> (...) { }
if not vim.b.erb_loaded then
  vim.b["surround_" .. string.byte("i")] = "if \1if: \1 \r end"
  vim.b["surround_" .. string.byte("u")] = "unless \1unless: \1 \r end"
  vim.b["surround_" .. string.byte("w")] = "while \1while: \1 do \r end"
  vim.b["surround_" .. string.byte("e")] = "\1collection: \1.each do |\2item: \2| \r end"
  vim.b["surround_" .. string.byte("m")] = "module \r end"
  vim.b["surround_" .. string.byte("d")] = "do\n \r end"
end

vim.b["surround_" .. string.byte("#")] = "#{\r}"
vim.b.surround_indent = 1
