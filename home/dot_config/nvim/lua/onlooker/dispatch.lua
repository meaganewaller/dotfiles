-- Dispatches a new Claude Code agent as a Neovim terminal job that
-- onlooker owns, so it can later be taken over or steered.
local accounts = require("onlooker.accounts")
local discover = require("onlooker.discover")
local registry = require("onlooker.registry")

local M = {}

--- opts.cwd: working directory (default: current). opts.prompt: initial
--- message to queue once the agent boots. opts.label: display label.
--- opts.account: account name or config dir (default: resolved, see
--- accounts.resolve -- may prompt).
function M.dispatch(opts)
  opts = opts or {}
  accounts.resolve(opts.account, function(account)
    if account then
      M.start(account, opts)
    end
  end)
end

function M.start(account, opts)
  local cwd = opts.cwd or vim.fn.getcwd()
  local since = os.time()
  local label = opts.label or vim.fn.fnamemodify(cwd, ":t")
  -- The prompt goes on the command line rather than into the pty: typed
  -- input that arrives before the TUI has booted loses its Enter. `--`
  -- stops a variadic flag the shell wrapper adds (--add-dir) from
  -- swallowing it as another directory.
  local argv, env = accounts.command(account, opts.prompt and { "--", opts.prompt } or {})

  vim.cmd("tabnew")
  local buf = vim.api.nvim_get_current_buf()

  local entry
  local job_id = vim.fn.jobstart(argv, {
    term = true,
    cwd = cwd,
    env = env,
    on_exit = function()
      vim.schedule(function()
        vim.notify(string.format("onlooker: %s exited", label))
      end)
    end,
  })

  if job_id <= 0 then
    vim.notify("onlooker: failed to start '" .. argv[1] .. "'", vim.log.levels.ERROR)
    vim.api.nvim_buf_delete(buf, { force = true })
    return nil
  end

  entry = registry.add({ job_id = job_id, buf = buf, cwd = cwd, label = label, account = account.name })
  pcall(vim.api.nvim_buf_set_name, buf, string.format("onlooker://dispatch/%s/%d", label, entry.id))

  -- Bind the transcript Claude Code creates for this run, so idle
  -- tracking and the dashboard reflect real activity, not just wall time
  -- since dispatch.
  local attempts = 0
  local timer = vim.uv.new_timer()
  timer:start(
    1000,
    1000,
    vim.schedule_wrap(function()
      attempts = attempts + 1
      local session = discover.find_new_session(cwd, since, account)
      if session or attempts >= 30 then
        if session then
          entry.session_id = session.session_id
          entry.session_path = session.path
        end
        timer:stop()
        timer:close()
      end
    end)
  )

  vim.notify(string.format("onlooker: dispatched %s agent in %s", account.name, cwd))
  return entry
end

return M
