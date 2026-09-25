-- Defaults for the onlooker plugin. Nothing here talks to disk or
-- processes; `discover.lua`/`transcript.lua`/etc. read `M.options`.
local M = {}

M.defaults = {
  -- Binary dispatch falls back to when shell_dispatch has no
  -- claude-<account> function. Always run with CLAUDE_CONFIG_DIR set.
  claude_bin = "claude",
  -- Shell file defining one claude-<account> function per account (the
  -- same ones a terminal uses). Set to "" to always run claude_bin.
  shell_dispatch = "~/.config/shell/claude.sh",
  -- Claude Code config dirs to observe; each keeps transcripts under
  -- <dir>/projects, one subdirectory per project and one append-only
  -- .jsonl per session. nil auto-discovers ~/.claude, ~/.claude-*, and
  -- $CLAUDE_CONFIG_DIR (see accounts.lua).
  claude_dirs = nil,
  -- How often the live feed/digest re-check a tailed transcript for
  -- appended lines.
  poll_ms = 750,
  -- How often the dashboard re-scans each <claude_dir>/projects.
  scan_ms = 4000,
  -- A session is "active" if its transcript was written to within this
  -- many seconds; otherwise it's "idle".
  active_window_seconds = 120,
  -- Dispatched sessions whose terminal buffer is detached (not shown in
  -- any window) and idle longer than this are cleanup candidates.
  idle_cleanup_minutes = 45,
  -- How much of a transcript's tail to read when summarizing a session
  -- for the dashboard (last-activity preview).
  max_tail_bytes = 65536,
}

M.options = vim.deepcopy(M.defaults)

function M.setup(opts)
  opts = opts or {}
  -- Pre-multi-account option: a single <dir>/projects path.
  if opts.projects_root and not opts.claude_dirs then
    opts.claude_dirs = { vim.fn.fnamemodify(vim.fn.expand(opts.projects_root), ":h") }
  end
  M.options = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts)
end

return M
