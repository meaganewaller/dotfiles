local neotest = require("neotest")
local lib = require("neotest.lib")

local function get_env()
  local env = {}
  local file = ".env"
  if not lib.files.exists(file) then return {} end

  for _, line in ipairs(vim.fn.readfile(file)) do
    for name, value in string.gmatch(line, "(%S+)=['\"]?(.*)['\"]?") do
      local str_end = string.sub(value, -1, -1)
      if str_end == "'" or str_end == '"' then value = string.sub(value, 1, -2) end

      env[name] = value
    end
  end

  return env
end

neotest.setup({
  log_level = vim.log.levels.DEBUG,
  quickfix = {
    open = false,
  },
  status = {
    virtual_text = true,
    signs = true,
  },
  output = {
    open_on_run = false,
  },
  icons = {
    running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
  },
  strategies = {
    integrated = {
      width = 180,
    },
  },
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false, console = "integratedTerminal", subProcess = false },
      pytest_discovery = true,
    }),
    require("neotest-plenary"),
    require("neotest-rspec"),
  },
})

local group = vim.api.nvim_create_augroup("NeotestConfig", {})
for _, ft in ipairs({ "output", "attach", "summary" }) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "neotest-" .. ft,
    group = group,
    callback = function(opts)
      vim.keymap.set("n", "q", function() pcall(vim.api.nvim_win_close, 0, true) end, {
        buffer = opts.buf,
      })
    end,
  })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "neotest-output-panel",
  group = group,
  callback = function() vim.cmd("norm G") end,
})

vim.keymap.set("n", "<Leader>no", function() require("neotest").summary.toggle() end)
vim.keymap.set("n", "<Leader>nn", function() require("neotest").run.run() end)
vim.keymap.set("n", "<Leader>nf", function() require("neotest").run.run(vim.fn.expand("%")) end)
vim.keymap.set("n", "<Leader>nl", function() require("neotest").run.run_last() end)
vim.keymap.set("n", "<Leader>ns", function()
  local ntest = require("neotest")
  for _, adapter_id in ipairs(ntest.state.adapter_ids()) do
    ntest.run.run({ suite = true, adapter = adapter_id })
  end
end)
