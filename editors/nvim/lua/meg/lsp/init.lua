local M = {}

local diagnostic_ns = vim.api.nvim_create_namespace("lsp_diagnostics")
local lsp_group = vim.api.nvim_create_augroup("vimrc_lsp", { clear = true })

-- { == Configuration ==> =====================================================

function M.setup()
  M.configure_handlers()
  M.mason()
  M.servers()

  if vim.bo.filetype ~= '' then
    vim.cmd('doautocmd FileType ' .. vim.bo.filetype)
  end

  return lsp
end

function M.configure_handlers()
  vim.diagnostic.config({
    virtual_text = false,
  })

  vim.lsp.handlers['textDocument/hover'] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded', focusable = false })
  vim.lsp.handlers['textDocument/signatureHelp'] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single', focusable = false, silent = true })

  vim.cmd([[
    sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=
    sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=
    sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=
    sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=
  ]])
end

function M.mappings()
  local opts = { buffer = true, silent = true }
  vim.keymap.set('n', '<leader>ld', function()
    return require('telescope.builtin').lsp_definitions()
  end, opts)
  vim.keymap.set('n', '<leader>lw', function()
    return require('telescope.builtin').lsp_type_definitions()
  end, opts)
  vim.keymap.set('n', '<leader>lu', function()
    return require('telescope.builtin').lsp_references({
      previewer = false,
      fname_width = 80,
    })
  end, opts)
  vim.keymap.set('n', '<leader>lc', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', '<leader>lg', function()
    return require('telescope.builtin').lsp_implementations()
  end, opts)
  vim.keymap.set('n', '<Space>', vim.lsp.buf.hover, { silent = true, buffer = true })
  vim.keymap.set('n', '<leader>lf', function()
    vim.lsp.buf.format({ timeout_ms = 5000 })
  end, opts)
  vim.keymap.set('v', '<leader>lf', function()
    return vim.lsp.buf.format()
  end, opts)
  vim.keymap.set('n', '<leader>li', vim.lsp.buf.incoming_calls, opts)
  vim.keymap.set('n', '<leader>lo', vim.lsp.buf.outgoing_calls, opts)
  vim.keymap.set('n', '<leader>lt', vim.lsp.buf.document_symbol, opts)
  vim.keymap.set('n', '<leader>lo', vim.lsp.buf.outgoing_calls, opts)
  vim.keymap.set('n', '<leader>le', function()
    return vim.diagnostic.open_float({ scope = 'line', show_header = false, focusable = false, border = 'rounded' })
  end, opts)
  vim.keymap.set('n', '<Leader>e', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '[g', function()
    return vim.diagnostic.goto_prev({ float = false })
  end, opts)
  vim.keymap.set('n', ']g', function()
    return vim.diagnostic.goto_next({ float = false })
  end, opts)
  vim.keymap.set('n', '<Leader>la', vim.lsp.buf.code_action, opts)
  vim.keymap.set('x', '<Leader>la', function()
    return vim.lsp.buf.code_action()
  end, opts)
  vim.keymap.set('i', '<C-k>', function()
    vim.lsp.buf.signature_help()
    return ''
  end, { expr = true, buffer = true })
end

function M.mason()
  require("mason").setup({
    ui = {
      border = "rounded",
    },
  })
  require("mason-lspconfig").setup({
    ensure_installed = {
      "pylsp",
      "terraformls",
      "docker_compose_language_service",
      "dockerls",
      "vimls",
      "vtsls",
      "intelephense",
      "gopls",
      "lua_ls",
    },
  })
end

function M.servers()
    local nvim_lsp = require('lspconfig')

  local function lsp_setup(opts)
    opts = opts or {}
    return vim.tbl_deep_extend('force', {
      on_attach = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil
        if client.server_capabilities.documentSymbolProvider then
          require('nvim-navic').attach(client, bufnr)
        end
        M.attach_to_buffer(client, bufnr)
        if opts.disableFormatting then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      end,
    }, opts or {})
  end

  nvim_lsp.vimls.setup(lsp_setup())
  nvim_lsp.intelephense.setup(lsp_setup())
  nvim_lsp.gopls.setup(lsp_setup())
  nvim_lsp.pylsp.setup(lsp_setup())
  nvim_lsp.terraformls.setup(lsp_setup())
  nvim_lsp.docker_compose_language_service.setup(lsp_setup())
  nvim_lsp.dockerls.setup(lsp_setup())
  local vtsls_settings = {
    preferences = {
      quoteStyle = 'single',
      importModuleSpecifier = 'relative',
    },
  }
  nvim_lsp.vtsls.setup(lsp_setup({
    settings = {
      javascript = vtsls_settings,
      typescript = vtsls_settings,
      vtsls = {
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
    },
    disableFormatting = true,
  }))

  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  require('neodev').setup()
  nvim_lsp.lua_ls.setup(lsp_setup({
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = runtime_path,
        },
        diagnostics = {
          globals = { 'vim', 'describe', 'it', 'before_each', 'after_each' },
        },
        workspace = {
          checkThirdParty = false,
          ignoreDir = { '.git' },
        },
        telemetry = {
          enable = false,
        },
      },
    },
    disableFormatting = true,
  }))

  local null_ls = require('null-ls')
  null_ls.setup({
    diagnostic_config = {
      virtual_text = false,
    },
    sources = {
      -- Code actions
      null_ls.builtins.code_actions.eslint_d,

      -- Diagnostics
      null_ls.builtins.diagnostics.eslint_d,
      null_ls.builtins.diagnostics.sqlfluff.with({
        extra_args = { '--dialect', 'postgres' },
      }),

      -- Formatters
      null_ls.builtins.formatting.eslint_d,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.sqlfluff.with({
        extra_args = { '--dialect', 'postgres' },
      }),
    },
  })
end

local function show_diagnostics()
  vim.schedule(function()
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local bufnr = vim.api.nvim_get_current_buf()
    local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
    vim.diagnostic.show(diagnostic_ns, bufnr, diagnostics, { virtual_text = true })
  end)
end

local function refresh_diagnostics()
  vim.diagnostic.setloclist({ open = false })
  show_diagnostics()
  if vim.tbl_isempty(vim.fn.getloclist(0)) then
    vim.cmd.lclose()
  end
end

function M.attach_to_buffer(client, bufnr)
  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    buffer = bufnr,
    callback = show_diagnostics,
    group = lsp_group,
  })
  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    buffer = bufnr,
    callback = refresh_diagnostics,
    group = lsp_group,
  })
  if
    client.server_capabilities.signatureHelpProvider
    and not vim.tbl_isempty(client.server_capabilities.signatureHelpProvider)
  then
    vim.api.nvim_create_autocmd('CursorHoldI', {
      buffer = bufnr,
      callback = function()
        vim.defer_fn(function()
          vim.lsp.buf.signature_help()
        end, 500)
      end,
      group = lsp_group,
    })
  end
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
  M.mappings()
end

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
toggle_format_on_save("silent")

nx.cmd({
	{ "LspFormat", function() vim.lsp.buf.format({ async = true }) end, bang = true },
	{ "LspToggleAutoFormat", function(opt) toggle_format_on_save(opt.args) end, bang = true, nargs = "?" },
	{ "ToggleBufferDiagnostics", function() toggle_buffer_diags(vim.fn.bufnr()) end, bang = true },
})
-- <== }

--- { == Keymaps ==> ===========================================================

nx.map({
	{ "<leader>q", vim.diagnostic.setloclist, desc = "Buffer Diagnostics", wk_label = "Quickfix" },
	{ "<leader>db", vim.diagnostic.setloclist, desc = "Buffer Diagnostics" },
	{ "gl", function() vim.diagnostic.open_float({ border = border }) end, desc = "Show Diagnostics" },
	{
		"gL",
		function() vim.diagnostic.open_float({ scope = "cursor", border = border }) end,
		desc = "Show Diagnostics",
	},
	-- Keymaps for user commands
	{ "<leader>dtt", "<Cmd>ToggleBufferDiagnostics<CR>", desc = "Toggle Buffer Diagnostics" },
	{ "<leader>tdt", "<Cmd>ToggleBufferDiagnostics<CR>", desc = "Toggle ", wk_label = "Buffer Diagnostics" },
	{ "<leader>dj", vim.diagnostic.goto_next, desc = "Next diagnostic" },
	{ "<leader>dk", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
})
---@param bufnr number
function M.on_attach(_, bufnr)
	nx.map({
		{ "K", vim.lsp.buf.hover, desc = "LSP Hover" },
		{ "gh", vim.lsp.buf.signature_help, desc = "Signatrue Help" },
		-- Use mostly saga
		-- { "<C-.>", vim.lsp.buf.code_action, desc = "Code action" },
		-- { "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
		-- { "gD", vim.lsp.buf.declaration, desc = "Goto declaration" },
		-- { "<leader>lr", vim.lsp.buf.references, desc = "List References" },
		-- { "<F11>", vim.lsp.buf.references, desc = "List References" },
		-- { "<F12>", vim.lsp.buf.definition, desc = "Go to Definition" },
		-- { "<leader>ld", vim.lsp.buf.definition, desc = "Definitions" },
		-- { "<leader>li", vim.lsp.buf.implementation, desc = "Goto implementation" },
		{
			"<F2>",
			function()
				nx.au({
					"FileType",
					pattern = "DressingInput",
					once = true,
					callback = function()
						-- Start rename input dialog with selected content
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>^vE", true, false, true), "n", false)
					end,
				})
				vim.lsp.buf.rename()
			end,
			{ "i", "n" },
			desc = "Rename",
		},

		-- Telescope
		{ "<leader>ls", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Document Symbols" },
		{ "<leader>lS", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Workspace Symbols" },

		-- Keymaps for user commands
		{ { "<leader>ff", "<leader>lf" }, "<Cmd>LspFormat<CR>", desc = "Format Buffer" },
		-- stylua: ignore
		{ { "<leader>tF", "<leader>lF" }, "<Cmd>LspToggleAutoFormat<CR>", desc = "Toggle Format on Save", wk_label = "Format on Save" },
	}, { buffer = bufnr })
end
-- <== }

return M
-- local icons = mw.ui.icons
-- local borders = mw.ui.borders.default
--
-- local servers = {
--   "bashls",
--   "cssls",
--   "emmet_ls",
--   "eslint",
--   "jsonls",
--   "pyright",
--   "lua_ls",
--   "solargraph",
--   "sorbet",
--   "standardrb",
--   "tailwindcss",
--   "tsserver",
--   "vimls",
--   "yamlls",
-- }
--
-- local border = {
--   { borders.tl, "FloatBorder" },
--   { borders.t, "FloatBorder" },
--   { borders.tr, "FloatBorder" },
--   { borders.r, "FloatBorder" },
--   { borders.br, "FloatBorder" },
--   { borders.b, "FloatBorder" },
--   { borders.bl, "FloatBorder" },
--   { borders.l, "FloatBorder" },
-- }
--
-- local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
-- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
--   opts = opts or {}
--   opts = {
--     border = border,
--     width = 80,
--   }
--   return orig_util_open_floating_preview(contents, syntax, opts, ...)
-- end
--
-- -- Configure lsp handlers
-- vim.diagnostic.config({
--   virtual_text = {
--     source = "if_many", --"always" "if_many"
--     spacing = 4,
--     prefix = icons.lsp.diagnostics[1],
--   },
--   signs = true,
--   underline = true,
--   update_in_insert = false,
--   severity_sort = true,
-- })
--
-- -- Set diagnostic signs
-- local signs = {
--   Error = icons.lsp.error[1],
--   Warn = icons.lsp.warn[1],
--   Hint = icons.lsp.hint[1],
--   Info = icons.lsp.info[1],
-- }
-- for type, icon in pairs(signs) do
--   local hl = "DiagnosticSign" .. type
--   vim.fn.sign_define(hl, {
--     text = icon,
--     texthl = hl,
--     numhl = hl,
--   })
-- end
--
-- -- Files to look for when searching for project root dir
-- local root_files = {
--   "selene.toml",
--   "selene.yml",
--   "stylua.toml",
--   ".git",
--   ".luarc.json",
--   ".luacheckrc",
--   "Makefile",
--   ".nvim",
--   ".stylua.toml",
--   ".eslintrc.js",
--   "node_modules",
--   "Gemfile",
-- }
--
-- -- Setup language servers and null-ls
-- require("meg.lsp.config").setup(icons, border, root_files, servers)
-- require("meg.lsp.install").setup(servers)
--
-- -- Setup lsp utilities
-- require("meg.lsp.utils.signature").setup(icons, border)
-- require("meg.lsp.utils.fidget").setup(icons, borders)
-- require("meg.lsp.utils.inc-rename").setup()
-- require("meg.lsp.utils.glance").setup(icons, borders)
