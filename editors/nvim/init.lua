-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
-- Last updated: 2023-12-08
-- code: https://github.com/meaganewaller/dotfiles

vim.defer_fn(function()
  if vim.fn.argc() > 0 then return end
  for _, file in ipairs(vim.v.oldfiles) do
    if vim.loop.fs_stat(file) and vim.fs.basename(file) ~= "COMMIT_EDITMSG" then
      vim.cmd.edit(file)
      return
    end
  end
end, 1)

vim.g.mapleader = " "
vim.g.maplocalleader = ","

local function safeRequire(module)
  local success, result = pcall(require, module)
  if success then return end

  vim.defer_fn(
    function() vim.notify(("Error loading %s\n%s"):format(module, result), vim.log.levels.ERROR) end,
    1
  )
end

safeRequire 'config.lazy'
if vim.fn.has('gui_running') == 1 then safeRequire 'config.gui' end

safeRequire 'config.theme'
safeRequire 'config.settings'
safeRequire 'config.bindings'
safeRequire 'config.leader-bindings'
safeRequire 'config.diagnostics'
safeRequire 'config.cmds'
safeRequire 'config.spellfixes'

if vim.version().major == 0 and vim.version().minor >= 10 then
  vim.notify("TODO version 0.10.md")
end
