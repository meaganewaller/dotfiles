vim.pack.add({
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("gitsigns").setup({
  current_line_blame = true,
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, "Gitsigns: next hunk")

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, "Gitsigns: prev hunk")

    -- Actions
    map("n", "<leader>hs", gitsigns.stage_hunk, "Gitsigns: stage hunk")
    map("n", "<leader>hr", gitsigns.reset_hunk, "Gitsigns: reset hunk")
    map("n", "<leader>hS", gitsigns.stage_buffer, "Gitsigns: stage buffer")
    map("n", "<leader>hR", gitsigns.reset_buffer, "Gitsigns: reset buffer")
    map("n", "<leader>hp", gitsigns.preview_hunk, "Gitsigns: preview hunk")
    map("n", "<leader>hb", function()
      gitsigns.blame_line({ full = true })
    end, "Gitsigns: blame line")
    map("n", "<leader>hd", gitsigns.diffthis, "Gitsigns: diff this")

    -- Toggles
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Gitsigns: toggle line blame")

    -- Text object
    map({ "o", "x" }, "ih", gitsigns.select_hunk, "Gitsigns: select hunk")
  end,
})
