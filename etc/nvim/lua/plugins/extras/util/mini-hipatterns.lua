return {
  "echasnovski/mini.hipatterns",
  event = "VeryLazy",
  opts = function()
    local hi = require("mini.hipatterns")
    return {
      tailwind = {
        enabled = true,
        ft = { "typescriptreact", "javascriptreact", "css", "javascript", "typescript", "html" },
        style = "full",
      },
      highlighters = {
        hex_code = hi.gen_highlighter.hex_color({ priority = 2000 }),
      },
    }
  end,
  config = function(_, opts)
    require("mini.hipatterns").setup(opts)
  end,
}
