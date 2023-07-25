local loaded, fugitive = pcall(require, "vim-fugitive")
if not loaded then
  mw.loading_error_msg("vim-fugitive")
  return
end

local function setup(fugitive)
  local git_group = vim.api.nvim_create_augroup("custom_fugitive", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "fugitive",
    callback = function()
      vim.keymap.set("n", "<Space>", "=zt", { remap = true, silent = true, buffer = true })
      vim.keymap.set("n", "}", "]m=zt", { remap = true, silent = true, buffer = true })
      vim.keymap.set('n', '{', '[m=zt', { remap = true, silent = true, buffer = true })
    end,
    group = git_group,
  })
end

setup(fugitive)
