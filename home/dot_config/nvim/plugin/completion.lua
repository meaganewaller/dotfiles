vim.pack.add({
  { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1.*") },
})

require("blink.cmp").setup({
  fuzzy = {
    implementation = "lua", -- pure Lua, no prebuilt binary to download (mise owns tool installs, not blink's downloader)
  },
  keymap = { preset = "default" },
  sources = { default = { "lsp", "path", "snippets", "buffer" } },
  completion = {
    trigger = { show_on_keyword = true, show_on_trigger_character = true },
    menu = { auto_show = true },
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
  },
})

-- Advertise blink.cmp's completion capabilities to every LSP server
-- configured in plugin/lsp.lua.
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})
