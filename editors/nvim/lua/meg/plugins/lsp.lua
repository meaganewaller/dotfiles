local lsp = require("meg.lsp")
local utils = require("meg.utils")

local function locations_equal(loc1, loc2)
  return (loc1.uri or loc1.targetUri) == (loc2.uri or loc2.targetUri)
    and (loc1.range or loc1.targetSelectionRange).start.line == (loc2.range or loc2.targetSelectionRange).start.line
end

local function location_handler(_, result, ctx, _)
  if result == nil or vim.tbl_isempty(result) then return nil end

  local client = vim.lsp.get_client_by_id(ctx.client_id)

  local has_telescope = pcall(require, "telescope")
  if vim.tbl_islist(result) then
    if #result == 1 or (#result == 2 and locations_equal(result[1], result[2])) then
      pcall(vim.lsp.util.jump_to_location, result[1], client.offset_encoding, false)
    elseif has_telescope then
      local opts = {}
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local make_entry = require("telescope.make_entry")
      local conf = require("telescope.config").values
      local items = vim.lsp.util.locations_to_items(result, client.offset_encoding)
      pickers
        .new(opts, {
          prompt_title = "LSP Locations",
          finder = finders.new_table({
            results = items,
            entry_maker = make_entry.gen_from_quickfix(opts),
          }),
          previewer = conf.qflist_previewer(opts),
          sorter = conf.generic_sorter(opts),
        })
        :find()
    else
      vim.fn.setqflist({}, " ", {
        title = "LSP locations",
        items = vim.lsp.util.locations_to_items(result, client.offset_encoding),
      })
      vim.cmd.copen({ mods = { split = "botright" } })
    end
  else
    vim.lsp.util.jump_to_location(result, client.offset_encoding)
  end
end

vim.lsp.handlers["textDocument/declaration"] = location_handler
vim.lsp.handlers["textDocument/definition"] = location_handler
vim.lsp.handlers["textDocument/typeDefinition"] = location_handler
vim.lsp.handlers["textDocument/implementation"] = location_handler

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

local diagnostics_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, context, config)
  local client = vim.lsp.get_client_by_id(context.client_id)
  if client.config.diagnostics ~= false then diagnostics_handler(err, result, context, config) end
end

vim.lsp.handlers["window/showMessage"] = function(_err, result, context, _config)
  local client_id = context.client_id
  local message_type = result.type
  local message = result.message
  local client = vim.lsp.get_client_by_id(client_id)
  local client_name = client and client.name or string.format("id=%d", client_id)
  if not client then
    vim.notify("LSP[" .. client_name .. "] client has shut down after sending the message", vim.log.levels.ERROR)
  end
  if message_type == vim.lsp.protocol.MessageType.Error then
    vim.notify("LSP[" .. client_name .. "] " .. message, vim.log.levels.ERROR)
  else
    local message_type_name = vim.lsp.protocol.MessageType[message_type]
    local map = {
      Error = vim.log.levels.ERROR,
      Warning = vim.log.levels.WARN,
      Info = vim.log.levels.INFO,
      Log = vim.log.levels.DEBUG,
    }
    -- The whole reason to override this handler is so that this uses vim.notify instead of
    -- vim.api.nvim_out_write
    vim.notify(string.format("LSP[%s] %s\n", client_name, message), map[message_type_name])
  end
  return result
end

-- Configure the LSP servers
local lspservers = {
  "bashls",
  "cssls",
  "gdscript",
  "gopls",
  "html",
  "omnisharp",
  "pyright",
  "rust_analyzer",
  "vimls",
  "zls",
}
for _, server in ipairs(lspservers) do
  lsp.safe_setup(server)
end
lsp.safe_setup("yamlls", {
  settings = {
    yaml = {
      schemas = require("schemastore").json.schemas(),
    },
  },
})
lsp.safe_setup("clangd", {
  filetypes = { "c", "cpp", "objc", "objcpp" },
})
lsp.safe_setup("jsonls", {
  filetypes = { "json", "jsonc", "json5" },
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
    },
  },
})

lsp.safe_setup("flow", {
  root_dir = function(fname)
    local util = require("lspconfig.util")
    -- Disable flow when a typescript project is detected
    if util.root_pattern("tsconfig.json")(fname) then return nil end
    return util.root_pattern(".flowconfig")(fname)
  end,
  cmd = { "flow", "lsp", "--lazy" },
  settings = {
    flow = {
      coverageSeverity = "warn",
      showUncovered = true,
      stopFlowOnExit = false,
      useBundledFlow = false,
    },
  },
})

-- conflicts with work
-- lspconfig.sorbet.setup({
--   capabilities = lsp.capabilities,
--   cmd = { "bundle", "exec", "srb", "tc", "--lsp" },
-- })

local group = vim.api.nvim_create_augroup("LspSetup", {})
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "My custom attach behavior",
  pattern = "*",
  group = group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    lsp.on_attach(client, args.buf)
  end,
})
