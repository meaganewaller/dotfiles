vim.pack.add({
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  -- Highlights merge conflicts and adds buffer-local resolve maps in
  -- conflicted files: co/ct/cb/c0 (ours/theirs/both/none), ]x/[x to move.
  { src = "https://github.com/akinsho/git-conflict.nvim" },
})

-- git-conflict colors ours/theirs from the backgrounds of two highlight
-- groups (DiffText/DiffAdd by default) and recomputes on every ColorScheme.
-- Most managed themes give those usable, distinct backgrounds, but not all:
-- afterglow's DiffAdd is the Normal bg, melange and yugen give both the same
-- bg, and boo's DiffText has none. These two groups keep the theme's pair
-- when it works and otherwise tint Normal's bg with the theme's
-- Changed/Added fg. Registered before git-conflict's setup so this runs
-- ahead of its own ColorScheme handler. A theme that ships GitConflict*
-- groups itself (onedark) still wins, since the plugin sets them as
-- `default`.
local function blend(fg, bg, alpha)
  local function channel(shift)
    local f, b = bit.band(bit.rshift(fg, shift), 0xff), bit.band(bit.rshift(bg, shift), 0xff)
    return bit.lshift(math.floor(f * alpha + b * (1 - alpha) + 0.5), shift)
  end
  return channel(16) + channel(8) + channel(0)
end

local function set_conflict_highlights()
  local function get(name)
    return vim.api.nvim_get_hl(0, { name = name, link = false })
  end
  local normal_bg = get("Normal").bg or 0x000000
  local ours, theirs = get("DiffText").bg, get("DiffAdd").bg
  if not (ours and theirs and ours ~= theirs and ours ~= normal_bg and theirs ~= normal_bg) then
    ours = blend(get("Changed").fg or 0x8cf8f7, normal_bg, 0.25)
    theirs = blend(get("Added").fg or 0xb3f6c0, normal_bg, 0.25)
  end
  vim.api.nvim_set_hl(0, "ConflictOursBase", { bg = ours })
  vim.api.nvim_set_hl(0, "ConflictTheirsBase", { bg = theirs })
end

set_conflict_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("conflict_highlights", { clear = true }),
  callback = set_conflict_highlights,
})

require("git-conflict").setup({
  highlights = { current = "ConflictOursBase", incoming = "ConflictTheirsBase" },
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
