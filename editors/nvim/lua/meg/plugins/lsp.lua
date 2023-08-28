local function setup_typescript_tools()
  local api = require("typescript-tools.api")

  require("typescript-tools").setup({
    -- on_attach = function() ... end,
    handlers = {
      ["textDocument/publishDiagnostics"] = api.filter_diagnostics(
      -- Ignore 'This may be converted to an async function' diagnostics.
        { 80006 }
      ),
    },
    settings = {
      -- spawn additional tsserver instance to calculate diagnostics on it
      separate_diagnostic_server = true,
      -- "change"|"insert_leave" determine when the client asks the server about diagnostic
      publish_diagnostic_on = "insert_leave",
      -- array of strings("fix_all"|"add_missing_imports"|"remove_unused")
      -- specify commands exposed as code_actions
      expose_as_code_action = {},
      -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
      -- not exists then standard path resolution strategy is applied
      tsserver_path = nil,
      -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
      -- (see 💅 `styled-components` support section)
      tsserver_plugins = {
        -- for TypeScript v4.9+
        "@styled/typescript-styled-plugin",
        -- or for older TypeScript versions
        -- "typescript-styled-plugin",
      },
      -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
      -- memory limit in megabytes or "auto"(basically no limit)
      tsserver_max_memory = "auto",
      -- described below
      tsserver_file_preferences = {},
      tsserver_format_options = {},
    },
  })
end

local function setup_comment()
  require("Comment").setup({
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil,
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
      ---Line-comment toggle keymap
      line = "gcc",
      ---Block-comment toggle keymap
      block = "gbc",
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
      ---Line-comment keymap
      line = "gc",
      ---Block-comment keymap
      block = "gb",
    },
    ---LHS of extra mappings
    extra = {
      ---Add comment on the line above
      above = "gcO",
      ---Add comment on the line below
      below = "gco",
      ---Add comment at the end of line
      eol = "gcA",
    },
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
      ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
      basic = true,
      ---Extra mapping; `gco`, `gcO`, `gcA`
      extra = true,
    },
    ---Function to call after (un)comment
    post_hook = nil,
    ---Function to call before (un)comment
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    -- pre_hook = function(ctx)
    -- 	local U = require("Comment.utils")
    --
    -- 	local location = nil
    -- 	if ctx.ctype == U.ctype.block then
    -- 		location = require("ts_context_commentstring.utils").get_cursor_location()
    -- 	elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
    -- 		location = require("ts_context_commentstring.utils").get_visual_start_location()
    -- 	end
    --
    -- 	return require("ts_context_commentstring.internal").calculate_commentstring({
    -- 		key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
    -- 		location = location,
    -- 	})
    -- end,
  })
end

return {
  "neovim/nvim-lspconfig",
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  "onsails/lspkind-nvim",
  "ray-x/lsp_signature.nvim",
  "nvimdev/lspsaga.nvim",
  {
    "pmizio/typescript-tools.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function() setup_typescript_tools() end,
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    enabled = true,
    config = function() setup_comment() end,
  },
}
