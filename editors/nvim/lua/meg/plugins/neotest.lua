local loaded, neotest = pcall(require, "neotest")
if not loaded then
  mw.loading_error_msg("neotest")
  return
end

local function setup(neotest, icons)
  local border = {
    borders.tl,
    borders.t,
    borders.tr,
    borders.r,
    borders.br,
    borders.b,
    borders.bl,
    borders.l,
  }

  neotest.setup({
    adapters = {
      require("neotest-plenary"),
      require("neotest-rspec"),
    },
    consumers = {
      overseer = require("neotest.consumers.overseer")
    },
    diagnostic = {
      enabled = false,
    },
    log_level = 1,
    icons = {
      expanded = icons.arrow.hollow.b,
      child_prefix = "",
      child_indent = "",
      final_child_prefix = "",
      non_collapsible = "",
      collapsed = icons.arrow.hollow.r,
      passed = "",
      running = "",
      failed = "",
      unknown = "",
      skipped = "",
    },
    floating = {
      border = "single",
      max_height = 0.8,
      max_width = 0.9,
    },
    summary = {
      mappings = {
        attach = "a",
        expand = { "<CR>", "<2-LeftMouse>" },
        expand_all = "e",
        jumpto = "i",
        output = "o",
        run = "r",
        short = "O",
        stop = "u",
      }
    }
  })
end
