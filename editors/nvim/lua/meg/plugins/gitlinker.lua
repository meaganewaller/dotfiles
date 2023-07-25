local loaded, gitlinker = pcall(require, "gitlinker")
if not loaded then
  mw.loading_error_msg("gitlinker")
  return
end

local function setup(gitlinker)
  vim.keymap.set("n", "<Leader>yg", function()
    return require("gitlinker").get_buf_range_url(
    "n", { action_callback = require("gitlinker.actions").open_in_browser }
    )
  end, { silent = true })

  vim.keymap.set('v', '<leader>yg', function()
    return require('gitlinker').get_buf_range_url(
    'v',
    { action_callback = require('gitlinker.actions').open_in_browser }
    )
  end, {})

  gitlinker.setup({
    opts = {
      action_callback = require("gitlinker.actions").open_in_browser,
    },
    mappings = "<Leader>yg",
  })
end
