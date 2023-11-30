local status_ok, which_key = pcall(require, "which-key")
if status_ok then
  local opts = {
    mode = "n",
    prefix = "<localleader>",
    buffer = 0,
    silent = true,
    noremap = true,
    nowait = true,
  }

  local mappings = {
    name = "HTML",
    p = { ":BrowserPreview<CR>", "BrowserSync Preview On" },
    P = { ":BrowserStop<CR>", "BreowserSync Preview Off"  },
  }

  which_key.register(mappings, opts)
end
