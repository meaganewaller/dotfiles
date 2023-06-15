local icons = mw.ui.icons
local borders = mw.ui.borders.default

local servers = {
  "bashls",
  "cssls",
  "cssmodules_ls",
  "clangd",
  "emmet_ls",
  "eslint",
  "jsonls",
  "pyright",
  "lua_ls",
  "tsserver",
  "vimls",
  "yamlls",
  "taplo",
}

local border = {
  { borders.tl, "FloatBorder" },
  { borders.t, "FloatBorder" },
  { borders.tr, "FloatBorder" },
  { borders.r, "FloatBorder" },
  { borders.br, "FloatBorder" },
  { borders.b, "FloatBorder" },
  { borders.bl, "FloatBorder" },
  { borders.l, "FloatBorder" },
}

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts = {
    border = border,
    width = 80,
  }
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Configure lsp handlers
vim.diagnostic.config({
  virtual_text = {
    source = "if_many", --"always" "if_many"
    spacing = 4,
    prefix = icons.lsp.diagnostics[1],
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Set diagnostic signs
local signs = {
  Error = icons.lsp.error[1],
  Warn = icons.lsp.warn[1],
  Hint = icons.lsp.hint[1],
  Info = icons.lsp.info[1],
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, {
    text = icon,
    texthl = hl,
    numhl = hl,
  })
end

-- Files to look for when searching for project root dir
local root_files = {
  "selene.toml",
  "selene.yml",
  "stylua.toml",
  ".git",
  ".luarc.json",
  ".luacheckrc",
  "Makefile",
  ".nvim",
  ".stylua.toml",
  ".eslintrc.js",
  "node_modules",
}

require("meg.lsp.config").setup(icons, border, root_files, servers)
require("meg.lsp.install").setup(servers)

require("meg.lsp.plugins.signature").setup(icons, border)
require("meg.lsp.plugins.fidget").setup(icons, borders)
require("meg.lsp.plugins.inc-rename").setup()
require("meg.lsp.plugins.glance").setup(icons, borders)

-- local M = {}
--
-- local border = nx.opts.float_win_border
-- local signs = {
--   { name = "DiagnosticSignError", text = "󰅙" },
--   { name = "DiagnosticSignWarn",  text = "" },
--   { name = "DiagnosticSignHint",  text = "󰌵" },
--   { name = "DiagnosticSignInfo",  text = "" },
-- }
--
-- for _, sign in ipairs(signs) do
--   vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
-- end
--
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
-- -- { == Commands ==============================================================
--
-- ---@type { [number]: boolean }
-- local diag_disabled_buffers = {}
-- ---@param bufnr number
-- local function toggle_buffer_diags(bufnr)
--   if diag_disabled_buffers[bufnr] == nil or not diag_disabled_buffers[bufnr] then
--     vim.diagnostic.disable(bufnr)
--     diag_disabled_buffers[bufnr] = true
--     vim.notify("Disabled Diagnostics for Buffer")
--   else
--     vim.diagnostic.enable(bufnr)
--     diag_disabled_buffers[bufnr] = false
--     vim.notify("Enabled Diagnostics for Buffer")
--   end
-- end
--
-- ---@param silent? "silent"
-- local function toggle_format_on_save(silent)
--   if vim.fn.exists("#FormatOnSave") ~= 0 then
--     vim.api.nvim_del_augroup_by_name("FormatOnSave")
--     if silent ~= "silent" then vim.notify("Disabled Format on Save") end
--     return
--   end
--
--   nx.au({
--     "BufWritePre",
--     create_group = "FormatOnSave",
--     callback = function()
--       if next(vim.lsp.get_active_clients({ bufnr = 0 })) == nil then return end
--       vim.lsp.buf.format({ async = false })
--     end,
--   })
--   if silent ~= "silent" then vim.notify("Enabled Format on Save") end
-- end
--
-- -- enable format on save by default
-- -- toggle_format_on_save("silent")
--
-- nx.cmd({
--   { "LspFormat",               function() vim.lsp.buf.format({ async = true }) end, bang = true },
--   { "LspToggleAutoFormat",     function(opt) toggle_format_on_save(opt.args) end,   bang = true, nargs = "?" },
--   { "ToggleBufferDiagnostics", function() toggle_buffer_diags(vim.fn.bufnr()) end,  bang = true },
-- })
-- -- <== }
--
-- --- { == Keymaps ==> ===========================================================
--
-- nx.map({
--   { "<leader>q",  vim.diagnostic.setloclist,                                     desc = "Buffer Diagnostics",
--                                                                                                                 wk_label =
--     "Quickfix" },
--   { "<leader>db", vim.diagnostic.setloclist,                                     desc = "Buffer Diagnostics" },
--   { "gl",         function() vim.diagnostic.open_float({ border = border }) end, desc = "Show Diagnostics" },
--   {
--     "gL",
--     function() vim.diagnostic.open_float({ scope = "cursor", border = border }) end,
--     desc = "Show Diagnostics",
--   },
--   -- Keymaps for user commands
--   { "<leader>dtt", "<Cmd>ToggleBufferDiagnostics<CR>", desc = "Toggle Buffer Diagnostics" },
--   { "<leader>tdt", "<Cmd>ToggleBufferDiagnostics<CR>", desc = "Toggle ",                  wk_label = "Buffer Diagnostics" },
--   { "<leader>dj",  vim.diagnostic.goto_next,           desc = "Next diagnostic" },
--   { "<leader>dk",  vim.diagnostic.goto_prev,           desc = "Previous diagnostic" },
-- })
-- ---@param bufnr number
-- function M.on_attach(_, bufnr)
--   nx.map({
--     { "K",  vim.lsp.buf.hover,          desc = "LSP Hover" },
--     { "gh", vim.lsp.buf.signature_help, desc = "Signatrue Help" },
--     -- Use mostly saga
--     -- { "<C-.>", vim.lsp.buf.code_action, desc = "Code action" },
--     -- { "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
--     -- { "gD", vim.lsp.buf.declaration, desc = "Goto declaration" },
--     -- { "<leader>lr", vim.lsp.buf.references, desc = "List References" },
--     -- { "<F11>", vim.lsp.buf.references, desc = "List References" },
--     -- { "<F12>", vim.lsp.buf.definition, desc = "Go to Definition" },
--     -- { "<leader>ld", vim.lsp.buf.definition, desc = "Definitions" },
--     -- { "<leader>li", vim.lsp.buf.implementation, desc = "Goto implementation" },
--     {
--       "<F2>",
--       function()
--         nx.au({
--           "FileType",
--           pattern = "DressingInput",
--           once = true,
--           callback = function()
--             -- Start rename input dialog with selected content
--             vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>^vE", true, false, true), "n", false)
--           end,
--         })
--         vim.lsp.buf.rename()
--       end,
--       { "i", "n" },
--       desc = "Rename",
--     },
--
--     -- Telescope
--     { "<leader>ls",                   "<Cmd>Telescope lsp_document_symbols<CR>",          desc = "Document Symbols" },
--     { "<leader>lS",                   "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Workspace Symbols" },
--
--     -- Keymaps for user commands
--     { { "<leader>lf" },               "<Cmd>LspFormat<CR>",                               desc = "Format Buffer" },
--     -- stylua: ignore
--     { { "<leader>tF", "<leader>lF" }, "<Cmd>LspToggleAutoFormat<CR>",                     desc = "Toggle Format on Save",
--                                                                                                                             wk_label =
--       "Format on Save" },
--   }, { buffer = bufnr })
-- end
--
-- -- <== }
--
-- return M
-- -- local M = {}
-- --
-- -- local border = nx.opts.float_win_border
-- -- local signs = {
-- -- 	{ name = "DiagnosticSignError", text = "󰅙" },
-- -- 	{ name = "DiagnosticSignWarn", text = "" },
-- -- 	{ name = "DiagnosticSignHint", text = "󱍄" },
-- -- 	{ name = "DiagnosticSignInfo", text = "" },
-- -- }
-- --
-- -- for _, sign in ipairs(signs) do
-- -- 	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
-- -- end
-- --
-- -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
-- --
-- -- ---@type { [number]: boolean }
-- -- local diag_disabled_buffers = {}
-- -- ---@param bufnr number
-- -- local function toggle_buffer_diags(bufnr)
-- -- 	if diag_disabled_buffers[bufnr] == nil or not diag_disabled_buffers[bufnr] then
-- -- 		vim.diagnostic.disable(bufnr)
-- -- 		diag_disabled_buffers[bufnr] = true
-- -- 		vim.notify("Disabled Diagnostics for Buffer")
-- -- 	else
-- -- 		vim.diagnostic.enable(bufnr)
-- -- 		diag_disabled_buffers[bufnr] = false
-- -- 		vim.notify("Enabled Diagnostics for Buffer")
-- -- 	end
-- -- end
-- --
-- -- ---@param silent? "silent"
-- -- local function toggle_format_on_save(silent)
-- -- 	if vim.fn.exists("#FormatOnSave") ~= 0 then
-- -- 		vim.api.nvim_del_augroup_by_name("FormatOnSave")
-- -- 		if silent ~= "silent" then
-- -- 			vim.notify("Disabled Format on Save")
-- -- 		end
-- -- 		return
-- -- 	end
-- --
-- -- 	nx.au({
-- -- 		"BufWritePre",
-- -- 		create_group = "FormatOnSave",
-- -- 		callback = function()
-- -- 			if next(vim.lsp.get_active_clients({ bufnr = 0 })) == nil then
-- -- 				return
-- -- 			end
-- -- 			vim.lsp.buf.format({ async = false })
-- -- 		end,
-- -- 	})
-- -- 	if silent ~= "silent" then
-- -- 		vim.notify("Enabled Format on Save")
-- -- 	end
-- -- end
-- --
-- -- -- enable format on save by default
-- -- toggle_format_on_save("silent")
-- --
-- -- nx.cmd({
-- -- 	{
-- -- 		"LspFormat",
-- -- 		function()
-- -- 			vim.lsp.buf.format({ async = true })
-- -- 		end,
-- -- 		bang = true,
-- -- 	},
-- -- 	{
-- -- 		"LspToggleAutoFormat",
-- -- 		function(opt)
-- -- 			toggle_format_on_save(opt.args)
-- -- 		end,
-- -- 		bang = true,
-- -- 		nargs = "?",
-- -- 	},
-- -- 	{
-- -- 		"ToggleBufferDiagnostics",
-- -- 		function()
-- -- 			toggle_buffer_diags(vim.fn.bufnr())
-- -- 		end,
-- -- 		bang = true,
-- -- 	},
-- -- })
-- --
-- -- nx.map({
-- -- 	{ "<leader>q", vim.diagnostic.setloclist, desc = "Buffer Diagnostics", wk_label = "Quickfix" },
-- -- 	{ "<leader>db", vim.diagnostic.setloclist, desc = "Buffer Diagnostics" },
-- -- 	{
-- -- 		"gl",
-- -- 		function()
-- -- 			vim.diagnostic.open_float({ border = border })
-- -- 		end,
-- -- 		desc = "Show Diagnostics",
-- -- 	},
-- -- 	{
-- -- 		"gL",
-- -- 		function()
-- -- 			vim.diagnostic.open_float({ scope = "cursor", border = border })
-- -- 		end,
-- -- 		desc = "Show Diagnostics",
-- -- 	},
-- -- 	-- Keymaps for user commands
-- -- 	{ "<leader>dtt", "<Cmd>ToggleBufferDiagnostics<CR>", desc = "Toggle Buffer Diagnostics" },
-- -- 	{ "<leader>tdt", "<Cmd>ToggleBufferDiagnostics<CR>", desc = "Toggle ", wk_label = "Buffer Diagnostics" },
-- -- 	{ "<leader>dj", vim.diagnostic.goto_next, desc = "Next diagnostic" },
-- -- 	{ "<leader>dk", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
-- -- })
-- -- ---@param bufnr number
-- -- function M.on_attach(client, bufnr)
-- -- 	-- require("tailwind-highlight").setup(client, bufnr)
-- --
-- -- 	local opts = { noremap = true, silent = true }
-- -- 	nx.map({
-- -- 		{ "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Goto Declaration", opts },
-- -- 		{ "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Goto Definition", opts },
-- -- 		{ "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "Goto Type Definition", opts },
-- -- 		{ "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Goto Implementation", opts },
-- -- 		{ "gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "List References", opts },
-- -- 		{ "K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "LSP Hover", opts },
-- -- 		{ "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", desc = "Signature Help", opts },
-- -- 		{ "<LocalLeader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename file in buffer", opts },
-- -- 		{ "<LocalLeader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "View code actions", opts },
-- -- 		{ "<Leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "Float diagnostics", opts },
-- -- 		{ "<Leader>dk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "Goto Prev Diagnostic", opts },
-- -- 		{ "<Leader>dj", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Goto Next Diagnostic", opts },
-- -- 		{ "<Leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", desc = "Set Diagnostic List", opts },
-- --
-- -- 		-- Telescope
-- -- 		{ "<leader>ls", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Document Symbols" },
-- -- 		{ "<leader>lS", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Workspace Symbols" },
-- --
-- -- 		-- Keymaps for user commands
-- -- 		{ { "<leader>lf" }, "<Cmd>LspFormat<CR>", desc = "Format Buffer" },
-- --     -- stylua: ignore
-- --     { { "<leader>tF", "<leader>lF" }, "<Cmd>LspToggleAutoFormat<CR>", desc = "Toggle Format on Save", wk_label = "Format on Save" },
-- -- 	}, { buffer = bufnr })
-- -- end
-- -- -- <== }
-- --
-- -- return M
