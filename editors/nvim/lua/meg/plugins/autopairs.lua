-- https://github.com/windwp/nvim-autopairs

local function init()
  -- { == Configuration ==> ====================================================

  require("nvim-autopairs").setup({
    check_ts = true,
    enable_check_bracket_line = false,
    ts_config = {
      lua = { "string" }, -- it will not add pair on that treesitter node
      javascript = { "template_string" },
    },
  })
  -- <== }

  local cmp_autopairs_setup, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
  if cmp_autopairs_setup then
    local cmp_setup, cmp = pcall(require, "cmp")
    if cmp_setup then cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done()) end
  end

  -- { == Keymaps ==> ==========================================================

  nx.map({ -- Autopairs Exeptions
    { "<A-'>", "'", "i" },
    { "<A-S-'>", '"', "i" },
    { '<A-">', '"', "i" },
    { "<A-(>", "(", "i" },
    { "<A-S-9>", "(", "i" },
    { "<A-)>", ")", "i" },
    { "<A-S-0>", ")", "i" },
    { "<A-[>", "[", "i" },
    { "<A-]>", "]", "i" },
    { "<A-{>", "{", "i" },
    { "<A-}>", "{", "i" },
    { "<A-S-[>", "{", "i" },
    { "<A-S-]>", "}", "i" },
    { "<A-`>", "`", "i" },
  })
  -- <== }
end

nx.au({ "InsertEnter", once = true, callback = init })
