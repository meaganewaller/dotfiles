return {
  "chrisgrieser/nvim-alt-substitute",
  config = function()
    require('alt-substitute').setup()
  end,
  cmd = { 'CmdlineEnter' },
}
