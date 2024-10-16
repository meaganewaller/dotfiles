local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local nvim_cmp = {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-calc",
        {
			"onsails/lspkind.nvim",
			--lazy = false,
			config = function()
				require("lspkind").init()
			end
		},
		{
			"quangnguyen30192/cmp-nvim-ultisnips",
			config = function()
				-- optional call to setup (see customization section)
				require("cmp_nvim_ultisnips").setup {}
			end,
		}
    },
    config = function()
        local cmp = require("cmp")
        local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
        cmp.setup {
            preselect = cmp.PreselectMode.Item,
            snippet = {
                expand = function(args)
                    -- luasnip.lsp_expand(args.body)
                    vim.fn["UltiSnips#Anon"](args.body)
                end,
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'ultisnips' },
            }, {
                { name = 'buffer' },
                { name = 'path' },
                { name = 'calc' },
            }),
            mapping = {
                ["<c-n>"] = cmp.mapping(
                    function(fallback)
                        cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
                    end,
                    { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
                ),
                ["<c-p>"] = cmp.mapping(
                    function(fallback)
                        cmp_ultisnips_mappings.jump_backwards(fallback)
                    end,
                    { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
                ),
                ['<CR>'] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            fallback()
                        end
                    end
                }),
                ["<Tab>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ })
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end,
                }),
                ["<S-Tab>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ })
                        end
                    end,
                }),
            },
        }
    end
}

local snips = {
    "SirVer/ultisnips",
    event = "InsertEnter",
    dependencies = {
        "MissYourSmile/vim-snippets"
    }
}

return {
    snips,
    nvim_cmp
}
