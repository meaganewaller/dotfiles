return {
  "RRethy/vim-illuminate",
  event = "BufReadPost",
  config = function()
    local illuminate = require "illuminate"
    illuminate.configure {
      delay = 100,
      filetypes_denylist = {
        "alpha",
        "oil",
        "NvimTree",
        "nvimtree",
        "Telescope",
        "harpoon",
        "xxd",
      },
      under_cursor = true,
    }

    -- Highlight on yank
    -- conflict with vim-illuminate
    vim.api.nvim_create_autocmd("TextYankPost", {
      group = vim.api.nvim_create_augroup("highlight_on_yank", {}),
      desc = "Briefly highlight yanked text",
      callback = function()
        illuminate.pause()
        vim.highlight.on_yank()
        illuminate.resume()
      end,
    })

    local map = require("meg.utils").map

    map("n", "]]", function() require('illuminate').goto_next_reference(false) end, "Next reference")
    map("n", "[[", function() require('illuminate').goto_prev_reference(false) end, "Prev reference")
  end,
}
