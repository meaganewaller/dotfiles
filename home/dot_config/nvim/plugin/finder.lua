vim.pack.add({
  { src = "https://github.com/ibhagwan/fzf-lua" },
})

local fzf = require("fzf-lua")
fzf.setup({})

local map = vim.keymap.set

-- Files
map("n", "<leader>ff", fzf.files, { desc = "Find files" })
map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
map("n", "<leader>fc", function()
  fzf.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find config files" })

-- Search
map("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
map("n", "<leader>fs", fzf.grep_cword, { desc = "Grep word under cursor" })
map("n", "<leader>fS", fzf.grep_cWORD, { desc = "Grep WORD under cursor" })

-- Neovim
map("n", "<leader>fk", fzf.keymaps, { desc = "Find keymaps" })
map("n", "<leader>fh", fzf.helptags, { desc = "Find help tags" })
map("n", "<leader>fd", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })
map("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
map("n", "<leader>fu", fzf.undotree, { desc = "Undo tree" })

-- Theme (see plugin/colorschemes.lua for the installed themes, lua/theme
-- for the universal switcher this feeds back into)
map("n", "<leader>ft", function()
  local theme = require("theme")
  theme.set_picker_active(true)
  theme.enforce_dark_background()
  fzf.colorschemes({
    colors = theme.get_managed_themes(),
    live_preview = true,
    actions = {
      ["default"] = function(selected)
        theme.set_picker_active(false)
        if selected and selected[1] then
          theme.apply_managed_theme(selected[1])
        end
      end,
      ["esc"] = function()
        theme.set_picker_active(false)
        local saved = theme.get_saved_theme()
        if saved then
          theme.apply_managed_theme(saved)
        end
      end,
    },
  })
end, { desc = "Pick theme" })
