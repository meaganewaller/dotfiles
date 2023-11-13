local M = {}

-- { == Configuration ==> =====================================================

local border = nx.opts.float_win_border
local signs = {
  { name = "DiagnosticSignError", text = "󰅙" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "󰌵" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })

-- <== }

-- { == Commands ==============================================================

---@type { [number]: boolean }
local diag_disabled_buffers = {}
---@param bufnr number
local function toggle_buffer_diags(bufnr)
  if diag_disabled_buffers[bufnr] == nil or not diag_disabled_buffers[bufnr] then
    vim.diagnostic.disable(bufnr)
    diag_disabled_buffers[bufnr] = true
    vim.notify("Disabled Diagnostics for Buffer")
  else
    vim.diagnostic.enable(bufnr)
    diag_disabled_buffers[bufnr] = false
    vim.notify("Enabled Diagnostics for Buffer")
  end
end

---@param silent? "silent"
local function toggle_format_on_save(silent)
  if vim.fn.exists("#FormatOnSave") ~= 0 then
    vim.api.nvim_del_augroup_by_name("FormatOnSave")
    if silent ~= "silent" then vim.notify("Disabled Format on Save") end
    return
  end

  nx.au({
    "BufWritePre",
    create_group = "FormatOnSave",
    callback = function()
      if next(vim.lsp.get_active_clients({ bufnr = 0 })) == nil then return end
      vim.lsp.buf.format({ async = false })
    end,
  })
  if silent ~= "silent" then vim.notify("Enabled Format on Save") end
end

-- enable format on save by default
-- toggle_format_on_save("silent")

nx.cmd({
  { "LspFormat", function() vim.lsp.buf.format({ async = true }) end, bang = true },
  { "LspToggleAutoFormat", function(opt) toggle_format_on_save(opt.args) end, bang = true, nargs = "?" },
  { "ToggleBufferDiagnostics", function() toggle_buffer_diags(vim.fn.bufnr()) end, bang = true },
})
-- <== }

--- { == Keymaps ==> ===========================================================

nx.map({
  { "<Leader>lgr", "<cmd>Lspsaga finder tyd+ref+imp+def<cr>", desc = "Show references" },
  { "<Leader>lgd", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek definition" },
  { "<Leader>lgD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Show declaration" },
  { "<Leader>lgi", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Show implementation" },
  { "<Leader>lgy", "<cmd>Lspsaga peek_type_definition<cr>", desc = "Show type definition" },
  { "<Leader>lr", "<cmd>Lspsaga rename<CR>", desc = "Rename" },
  { "<Leader>la", "<cmd>Lspsaga code_action<CR>", desc = "Code actions" },
  { "<Leader>lk", "<cmd>Lspsaga hover_doc<CR>", desc = "Show documentation" },
  { "<Leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Show workspace symbols" },
  { "<Leader>lo", "<cmd>Lspsaga outline<CR>", desc = "Show outline" },
  { "<Leader>td", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Show dynamic workspace symbols" },
  { "<Leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Show line diagnostics" },
  { "<Leader>dc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", desc = "Show cursor diagnostics" },
  { "<Leader>dn", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Jump to next error" },
  { "<Leader>dp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Jump to previous error" },
  -- Keymaps for user commands
  { "<leader>dtt", "<Cmd>ToggleBufferDiagnostics<CR>", desc = "Toggle Buffer Diagnostics" },
  { "<leader>tdt", "<Cmd>ToggleBufferDiagnostics<CR>", desc = "Toggle ", wk_label = "Buffer Diagnostics" },
  { "<leader>dj", vim.diagnostic.goto_next, desc = "Next diagnostic" },
  { "<leader>dk", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
})

---@param bufnr number
function M.on_attach(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local bufmap = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, opts) end

  vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

  bufmap("n", "K", "<cmd>Lspsaga hover_doc<CR>")
  bufmap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
  bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  bufmap("n", "gy", "<cmd>Lspsaga peek_type_definition<CR>")
  bufmap("n", "gr", "<cmd>Lspsaga finder tyd+ref+imp+def<CR>")
  bufmap("n", "rn", "<cmd>Lspsaga rename<CR>")
  bufmap("n", "<C-a>", "<cmd>Lspsaga code_action<CR>")
  bufmap("n", "gl", "<cmd>Lspsaga show_line_diagnostics<CR>")
  bufmap(
    "n",
    "[d",
    function() require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR }) end
  )
  bufmap(
    "n",
    "]d",
    function() require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR }) end
  )

  if client.name == "tsserver" then bufmap("n", "<Leader>rf", "<cmd>TypescriptRenameFile<CR>") end

  require("lsp_signature").on_attach({
    bind = true,
    handler_opts = {
      border = "rounded",
    },
  }, bufnr)
end

local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

local ih = require("inlay-hints")
ih.setup({
  only_current_line = true,
  eol = {
    right_align = true,
  },
})

local signature_config = {
  log_path = vim.fn.expand("$HOME") .. "/tmp/sig.log",
  debug = false,
  hint_enable = true,
  noice = true,
  handler_opts = { border = "single" },
  max_width = 80,
}

local signature = require("lsp_signature")
signature.setup(signature_config)

return M
