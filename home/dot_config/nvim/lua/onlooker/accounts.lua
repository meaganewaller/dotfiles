-- Claude Code config directories ("accounts"). Claude Code keeps settings
-- and transcripts under $CLAUDE_CONFIG_DIR, defaulting to ~/.claude; a
-- multi-account setup has one directory per account (~/.claude-personal,
-- ~/.claude-work, ...). Observation scans all of them; dispatch picks one.
local config = require("onlooker.config")

local M = {}

local function normalize(dir)
  return vim.fn.fnamemodify(vim.fn.expand(dir), ":p"):gsub("/$", "")
end

--- Display name for a config dir: ~/.claude-work -> "work",
--- ~/.claude -> "default", anything else -> its basename.
function M.name(dir)
  local base = vim.fn.fnamemodify(dir, ":t")
  if base == ".claude" then
    return "default"
  end
  return base:match("^%.claude%-(.+)$") or base
end

--- Every config dir to observe, as { { name = ..., dir = ... }, ... }.
--- Uses options.claude_dirs when set; otherwise discovers ~/.claude,
--- ~/.claude-*, and $CLAUDE_CONFIG_DIR, keeping those with a projects/.
function M.list()
  local candidates = config.options.claude_dirs
  if not candidates then
    candidates = {}
    if vim.env.CLAUDE_CONFIG_DIR and vim.env.CLAUDE_CONFIG_DIR ~= "" then
      candidates[#candidates + 1] = vim.env.CLAUDE_CONFIG_DIR
    end
    candidates[#candidates + 1] = "~/.claude"
    vim.list_extend(candidates, vim.fn.glob("~/.claude-*", false, true))
  end

  local seen, accounts = {}, {}
  for _, dir in ipairs(candidates) do
    dir = normalize(dir)
    if not seen[dir] and vim.fn.isdirectory(dir .. "/projects") == 1 then
      seen[dir] = true
      accounts[#accounts + 1] = { name = M.name(dir), dir = dir }
    end
  end
  table.sort(accounts, function(a, b)
    return a.name < b.name
  end)
  return accounts
end

local function find(accounts, wanted)
  for _, a in ipairs(accounts) do
    if a.name == wanted or a.dir == wanted then
      return a
    end
  end
  return nil
end

local function tmux_default()
  if not vim.env.TMUX then
    return nil
  end
  local out = vim.fn.system({ "tmux", "show-option", "-gqv", "@claude_account" })
  out = vim.trim(out or "")
  return (vim.v.shell_error == 0 and out ~= "") and out or nil
end

--- Resolve the account to dispatch into, calling callback(account|nil).
--- Order matches tmux-claude-compose: explicit name, $CLAUDE_CONFIG_DIR,
--- tmux @claude_account, $CLAUDE_ACCOUNT, the only account; otherwise ask.
function M.resolve(wanted, callback)
  local accounts = M.list()
  if #accounts == 0 then
    vim.notify("onlooker: no Claude config dirs with a projects/ found", vim.log.levels.ERROR)
    return callback(nil)
  end

  if wanted and wanted ~= "" then
    local a = find(accounts, normalize(wanted)) or find(accounts, wanted)
    if not a then
      local names = vim.tbl_map(function(x)
        return x.name
      end, accounts)
      vim.notify(
        string.format("onlooker: unknown account '%s'. Available: %s", wanted, table.concat(names, ", ")),
        vim.log.levels.ERROR
      )
    end
    return callback(a)
  end

  local env_dir = vim.env.CLAUDE_CONFIG_DIR
  local default = (env_dir and env_dir ~= "" and find(accounts, normalize(env_dir)))
    or find(accounts, tmux_default() or "")
    or find(accounts, vim.env.CLAUDE_ACCOUNT or "")
    or (#accounts == 1 and accounts[1])
  if default then
    return callback(default)
  end

  vim.ui.select(accounts, {
    prompt = "Claude account",
    format_item = function(a)
      return string.format("%-12s %s", a.name, vim.fn.fnamemodify(a.dir, ":~"))
    end,
  }, callback)
end

--- argv + env that start Claude Code against `account`. CLAUDE_CONFIG_DIR
--- is always set: without it the CLI falls back to ~/.claude. When
--- options.shell_dispatch defines a claude-<name> function, that runs
--- instead, so dispatch gets the same flags and wrappers as a terminal
--- launch; otherwise options.claude_bin runs directly. `args` are passed
--- through to Claude Code.
function M.command(account, args)
  args = args or {}
  local env = { CLAUDE_CONFIG_DIR = account.dir }
  local script = vim.fn.expand(config.options.shell_dispatch or "")
  if script == "" or vim.fn.filereadable(script) == 0 then
    return vim.list_extend({ config.options.claude_bin }, args), env
  end
  -- `exec` skips shell functions, so the fallback reaches the real binary
  -- even though the script redefines `claude` to refuse.
  local body = 'script=$1 fn=$2 bin=$3; shift 3; . "$script"; '
    .. 'if declare -F "$fn" >/dev/null; then "$fn" "$@"; else exec "$bin" "$@"; fi'
  local argv = { "bash", "-c", body, "onlooker", script, "claude-" .. account.name, config.options.claude_bin }
  return vim.list_extend(argv, args), env
end

return M
