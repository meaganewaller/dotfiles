local fzf = require('fzf-lua')
fzf.setup({
  global_git_icons = false,
  files = {
    previewer = false,
  },
  -- This is required to support older version of fzf
  fzf_opts = { ["--border"] = false },
  git = {
    files = {
      previewer = false,
    },
  },
})
mw._find_files_impl = function(opts)
  opts = opts or {}
  -- git_files fails to find new files, which I often want
  -- if not opts.cwd and vim.fn.isdirectory(".git") == 1 then
  --   require("fzf-lua").git_files(opts)
  -- else
  require("fzf-lua").files(opts)
  -- end
end
