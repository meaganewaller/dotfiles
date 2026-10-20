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

-- GitHub Copilot as inline ghost text (<M-l> accept, <M-]>/<M-[> cycle,
-- <C-]> dismiss), separate from blink's menu. Deferred to the first
-- InsertEnter or :Copilot so the language server stays off startup; the
-- stub command is replaced by the plugin's own on packadd.
--
-- The server comes from mise (github:github/copilot-language-server-release
-- in dot_config/mise/config.toml.tmpl) rather than copilot.lua's
-- downloader, for the same reason blink uses the Lua fuzzy matcher.
vim.pack.add({
  { src = "https://github.com/zbirenbaum/copilot.lua" },
}, { load = function() end })

local copilot_loaded = false
local function load_copilot()
  if copilot_loaded then
    return
  end
  copilot_loaded = true
  vim.cmd.packadd("copilot.lua")
  require("copilot").setup({
    suggestion = { auto_trigger = true },
    server = { custom_server_filepath = "copilot-language-server" },
  })
end

vim.api.nvim_create_autocmd("InsertEnter", {
  group = vim.api.nvim_create_augroup("copilot_lazy", { clear = true }),
  once = true,
  callback = load_copilot,
})

vim.api.nvim_create_user_command("Copilot", function(opts)
  load_copilot()
  vim.cmd({ cmd = "Copilot", args = opts.fargs, bang = opts.bang })
end, { nargs = "*", bang = true })

-- copilot.lua's hide_during_completion only checks pumvisible(), which
-- blink's menu isn't, so the ghost text would draw over it. blink's own
-- recipe: hide the suggestion while the menu is open.
vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    if copilot_loaded then
      require("copilot.suggestion").dismiss()
    end
    vim.b.copilot_suggestion_hidden = true
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})
