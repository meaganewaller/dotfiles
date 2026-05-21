-- vim.pack startup diagnostic — launched via: nvim -S /tmp/nvim-debug.lua
-- Waits for vim.pack.add() to finish its install/update pass, then dumps
-- plugin state + :messages history to /tmp/nvim-debug-output.txt.
vim.defer_fn(function()
  local lines = {}
  table.insert(lines, "COLORSCHEME: " .. (vim.g.colors_name or "NONE"))
  table.insert(lines, "TERMGUICOLORS: " .. tostring(vim.o.termguicolors))
  table.insert(lines, "BACKGROUND: " .. vim.o.background)
  table.insert(lines, "")

  local pok, plugins = pcall(vim.pack.get)
  if pok and plugins then
    table.insert(lines, "PLUGINS (" .. #plugins .. "):")
    for _, p in ipairs(plugins) do
      local name = p.spec and p.spec.name or "?"
      local rev = (p.rev or "?"):sub(1, 8)
      local status = p.active and "active" or "inactive"
      table.insert(lines, string.format("  %-35s %s  %s", name, status, rev))
    end
  else
    table.insert(lines, "[ERROR] vim.pack.get() failed: " .. tostring(plugins))
  end
  table.insert(lines, "")

  -- LSP clients (only attach after a buffer with a matching filetype loads,
  -- but :checkhealth and most config issues show up here regardless).
  local clients = vim.lsp.get_clients()
  table.insert(lines, "LSP CLIENTS (" .. #clients .. "):")
  for _, c in ipairs(clients) do
    table.insert(lines, "  " .. c.name)
  end
  table.insert(lines, "")

  -- :messages is where vim.pack, LSP, and plugins route errors and warnings.
  local mok, msgs = pcall(vim.api.nvim_exec2, "messages", { output = true })
  if mok and msgs.output and msgs.output ~= "" then
    table.insert(lines, "MESSAGES:")
    for msg in msgs.output:gmatch("[^\n]+") do
      local tag = msg:lower():match("error") and "[ERROR] " or "  "
      table.insert(lines, tag .. msg)
    end
  end

  local f = io.open("/tmp/nvim-debug-output.txt", "w")
  if f then
    f:write(table.concat(lines, "\n") .. "\n")
    f:close()
  end
  vim.cmd("qa!")
end, 5000)
