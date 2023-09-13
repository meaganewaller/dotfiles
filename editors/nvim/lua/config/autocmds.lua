local autocmds = {}

function autocmds.setup()
  vim.api.nvim_create_augroup('Highlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 100 })
    end,
  })

  vim.api.nvim_create_augroup('LspNodeModules', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '*/node_modules/*',
    command = 'lua vim.diagnostic.disable(0)',
    group = 'LspNodeModules',
  })

  vim.api.nvim_create_autocmd({ 'BufEnter,WinEnter' }, {
    pattern = '*/node_modules/*',
    command = 'LspStop',
    group = 'LspNodeModules',
  })

  vim.api.nvim_create_autocmd('BufLeave', {
    pattern = '*/node_modules/*',
    command = 'LspStart',
    group = 'LspNodeModules',
  })

  vim.api.nvim_create_autocmd(
    { 'BufEnter', 'WinEnter', 'BufLeave' },
    { pattern = '*.min.*', command = 'LspStop', group = 'LspNodeModules' }
  )

  vim.api.nvim_create_augroup('Spell', { clear = true })

  -- Enable spell checking for certain file types
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.txt', '*.md', '*.tex' },
    command = 'setlocal spell',
    group = 'Spell',
  })

  -- Show `` in specific files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.txt', '*.md', '*.json' },
    command = 'setlocal conceallevel=0',
    group = 'Spell',
  })

  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = '*/spell/*.add',
    command = 'silent! :mkspell! %',
    group = 'Spell',
  })

  vim.api.nvim_create_augroup('NvimTree', { clear = true })
  vim.api.nvim_create_autocmd('BufWinEnter', {
    pattern = '*/spell/*.add',
    command = 'let &l:statusline = " Explorer"',
    group = 'NvimTree',
  })

  vim.api.nvim_create_augroup('Startified', { clear = true })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'Startified',
    command = 'setlocal cursorline',
    group = 'Startified',
  })

  vim.api.nvim_create_augroup('ClearLuasnipSession', { clear = true })
  vim.api.nvim_create_autocmd('CursorHold', {
    pattern = '*',
    -- Can't use InsertLeave here because that fires when we go to select mode
    command = 'silent! LuaSnipUnlinkCurrent',
    group = 'ClearLuasnipSession',
  })

  vim.api.nvim_create_augroup('Spell', { clear = true })
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 100 })
    end,
  })

  -- Disable diagnostics in node_modules (0 is current buffer only)
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*/node_modules/*",
    command = "lua vim.diagnostic.disable(0)"
  })

  -- Enable spell checking for certain file types
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.txt", "*.md", "*.tex" },
    command = "setlocal spell"
  })
  -- Show `` in specific files
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.txt", "*.md", "*.json" },
    command = "setlocal conceallevel=0"
  })

  -- Attach specific keybindings in which-key for specific filetypes
  local present, _ = pcall(require, "which-key")
  if not present then return end
  local _, pwk = pcall(require, "plugins.which-key")

  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.md",
    callback = function() pwk.attach_markdown(0) end
  })
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.ts", "*.tsx" },
    callback = function() pwk.attach_typescript(0) end
  })
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "package.json" },
    callback = function() pwk.attach_npm(0) end
  })
  vim.api.nvim_create_autocmd("FileType",
    {
      pattern = "*",
      callback = function()
        if BrioVim.plugins.zen.enabled and vim.bo.filetype ~= "alpha" then
          pwk.attach_zen(0)
        end
      end
    })
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*test.js", "*test.ts", "*test.tsx" },
    callback = function() pwk.attach_jest(0) end
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "spectre_panel",
    callback = function() pwk.attach_spectre(0) end
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "NvimTree",
    callback = function() pwk.attach_nvim_tree(0) end
  })

  vim.api.nvim_create_augroup('ClearLuasnipSession', { clear = true })
  vim.api.nvim_create_autocmd('CursorHold', {
    pattern = '*',
    -- Can't use InsertLeave here because that fires when we go to select mode
    command = 'silent! LuaSnipUnlinkCurrent',
    group = 'ClearLuasnipSession',
  })
end

return autocmds
