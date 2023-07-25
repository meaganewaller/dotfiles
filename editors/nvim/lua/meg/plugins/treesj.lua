local function setup(treesj)
  treesj.setup({
    use_default_keymaps = false,
    check_syntax_error = true,
    max_join_length = 200,
    cursor_behavior = "hold",
    notify = true,
  })

  vim.keymap.set("n", "gS", ":TSJSplit<CR>", { silent = true })
  vim.keymap.set("n", "gJ", ":TSJJoin<CR>", { silent = true })
end

local loaded, treesj = pcall(require, "treesj")
if not loaded then
  return
end

setup(treesj)
