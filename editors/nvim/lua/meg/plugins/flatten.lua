-- https://github.com/willothy/flatten.nvim

local toggleterm = require("toggleterm")

require("flatten").setup({
  window = {
    open = "alternate",
  },
  callbacks = {
    post_open = function(bufnr, winnr, ft, is_blocking)
      if is_blocking then
        toggleterm.toggle(0)
      else
        vim.api.nvim_set_current_win(winnr)
      end

      if ft == "gitcommit" then
        vim.api.nvim_create_autocmd("BufWritePost", {
          buffer = bufnr,
          once = true,
          callback = function()
            vim.defer_fn(function() vim.api.nvim_buf_delete(bufnr, {}) end, 50)
          end,
        })
      end
    end,
    block_end = function() toggleterm.toggle(0) end,
  },
  one_per = {
    kitty = false,
  },
})
