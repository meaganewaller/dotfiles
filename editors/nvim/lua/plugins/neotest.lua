local present, neotest = pcall(require, "neotest")
if not present then
  return
end

local neotest_ns = vim.api.nvim_create_namespace "neotest"
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local message = diagnostic.message
        :gsub("\n", " ")
        :gsub("\t", " ")
        :gsub("%s+", " ")
        :gsub("^%s+", "")
      return message
    end,
  },
}, neotest_ns)

-- ╭──────────────────────────────────────────────────────────╮
-- │ Setup                                                    │
-- ╰──────────────────────────────────────────────────────────╯
neotest.setup({
  adapters = {
    require("neotest-python"),
    require("neotest-go"),
    require("neotest-minitest"),
    require("neotest-rspec"),
    require("neotest-vitest"),
    require("neotest-testthat"),
    require("neotest-pest"),
    require("neotest-jest")({
      jestCommand = "npm test --",
      env = { CI = true },
      cwd = function(path)
        return vim.fn.getcwd()
      end,
    }),
  },
  diagnostic = {
    enabled = false
  },
  floating = {
    border = BrioVim.ui.float.border or "rounded",
    max_height = 0.6,
    max_width = 0.6
  },
  highlights = {
    adapter_name = "NeotestAdapterName",
    border = "NeotestBorder",
    dir = "NeotestDir",
    expand_marker = "NeotestExpandMarker",
    failed = "NeotestFailed",
    file = "NeotestFile",
    focused = "NeotestFocused",
    indent = "NeotestIndent",
    namespace = "NeotestNamespace",
    passed = "NeotestPassed",
    running = "NeotestRunning",
    skipped = "NeotestSkipped",
    test = "NeotestTest"
  },
  icons = {
    child_indent = "│",
    child_prefix = "├",
    collapsed = "─",
    expanded = "╮",
    failed = "✖",
    final_child_indent = " ",
    final_child_prefix = "╰",
    non_collapsible = "─",
    passed = "✔",
    running = "",
    skipped = "ﰸ",
    unknown = "?"
  },
  output = {
    enabled = true,
    open_on_run = true,
  },
  run = {
    enabled = true
  },
  status = {
    enabled = true
  },
  strategies = {
    integrated = {
      height = 40,
      width = 120
    }
  },
  summary = {
    enabled = true,
    expand_errors = true,
    follow = true,
    mappings = {
      attach = "a",
      expand = { "<CR>", "<2-LeftMouse>" },
      expand_all = "e",
      jumpto = "i",
      output = "o",
      run = "r",
      short = "O",
      stop = "u"
    }
  }
})
