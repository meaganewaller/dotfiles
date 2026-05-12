---
status: "accepted"
date: 2026-05-12
decision-makers: [Meagan Waller]
consulted: []
informed: []
---

# Agents Need a Specialized Shell

## Context and Problem Statement

AI coding agents shell out to standard UNIX commands (`ls`, `grep`, `cat`, `find`, etc.). This zsh configuration aliases many of those to preferred alternatives (`cat` → `bat`, `ls` → `eza`, and so on), which changes output format, flags, and exit behavior in ways that break agent assumptions and parsing. Agents also pay the startup cost of interactive-oriented plugins (Oh My Zsh, atuin, autosuggestions, syntax highlighting) that do not improve automated command execution.

How should `.zshrc` detect agent contexts and conditionally disable human-centric features while preserving essential tooling (PATH, mise, editor-related env vars)?

## Decision Drivers

- **Correctness**: Detection MUST distinguish between humans and agents accurately; false positives remove niceties from an interactive session, false negatives break agent output parsing.
- **Maintainability**: New agents appear regularly; detection logic SHOULD have a single source of truth.
- **Startup performance**: Detection SHOULD add negligible latency to shell startup.
- **No bootstrap fragility**: Detection MUST work in the environments where it matters (agent shells still need mise and a sane PATH even when Oh My Zsh and heavy plugins are skipped).

## Considered Options

1. **Do nothing; document `command cat` / unalias in agent instructions**  
   Rely on agents always prefixing builtins or bypassing aliases. Low maintenance but brittle: agents and skills do not consistently do this, and it does not reduce startup cost.

2. **Treat “non-interactive shell” as agent shell**  
   Use `[[ ! -o interactive ]]` or equivalent to skip heavy config. Simple and fast, but wrong for many agent integrations that spawn an interactive login shell; high false-negative rate against the correctness driver.

3. **Separate profile via `ZDOTDIR`**  
   Point agent-only invocations at a minimal directory with a tiny `.zshrc` (PATH + mise only). Very predictable output and fast startup, but only helps when the parent process can set `ZDOTDIR`; not all agent hosts document or honor that, and humans must not accidentally use that directory as their default.

4. **Early branch inside the existing Chezmoi-managed `dot_zshrc.tmpl`**  
   At the top of `.zshrc` (after any definitions needed for the predicate itself), evaluate one function or snippet—e.g. `_dotfiles_is_agent_shell`—that returns true only when an explicit knob and/or an allowlisted set of environment fingerprints match. If true, apply a short “minimal agent” path: skip Oh My Zsh, atuin, autosuggestions, syntax highlighting, and human-centric aliases; still activate mise and retain PATH / XDG / editor exports needed for tooling. Single file, single source of truth, works for any process that runs the user’s normal zsh init.

5. **Default to POSIX `/bin/sh` for agent command execution**  
   Configure the agent or IDE to use `sh` instead of zsh. Avoids zsh-specific config entirely but diverges from the user’s real toolchain assumptions (mise hooks, functions, login env) unless duplicated into `PROFILE`/`.profile`, creating two worlds to maintain.

## Decision Outcome

**Chosen option: (4) early branch inside `dot_zshrc.tmpl`**, backed by **(1) an explicit override** for unknown tools.

- **Predicate (single source of truth)**: One shell function or equivalent block (sourced once) that returns true if any of the following holds:
  - **Explicit opt-in**: `DOTFILES_AGENT_SHELL=1` (or similarly named) is set—used for new agents, CI jobs, or sandboxes until a native fingerprint exists.
  - **Explicit opt-out**: `DOTFILES_AGENT_SHELL=0` forces the full interactive profile when a heuristic would otherwise misfire.
  - **Known fingerprints** (maintained in that one block, with comments and dates when extended), including at least:
    - **Claude Code**: `CLAUDECODE=1` in shells spawned by the Bash tool and related sessions ([Claude Code environment variables](https://code.claude.com/docs/en/env-vars)).
    - **Cursor**: integrated-terminal variables such as `CURSOR_AGENT` / `CURSOR_CLI` where those reliably indicate agent-driven execution (see Cursor terminal / CLI docs; adjust if the product renames them).

- **Minimal path behavior**: When the predicate is true, skip loading Oh My Zsh, atuin, zsh-autosuggestions, zsh-syntax-highlighting, and human-centric aliases; still run the smallest sequence needed for mise activation (or equivalent) and any PATH / XDG / `EDITOR` / `PAGER` setup required so agents behave like “my machine,” not “stock macOS/Linux,” without rewriting coreutils output.

### Consequences

- **Positive**: Standard command names resolve to POSIX-like behavior for agents; faster cold starts; one place to update when a new agent product appears.
- **Positive**: Humans keep the full profile unless they set the explicit opt-in (or hit a fingerprint), so day-to-day terminals are unchanged.
- **Negative**: Fingerprints can change when vendors update their integrations; the allowlist needs occasional maintenance (mitigated by `DOTFILES_AGENT_SHELL` and opt-out).
- **Negative**: If a future agent runs inside an interactive shell without setting any fingerprint and the user does not set the explicit env var, false negatives remain possible; documentation in `docs/zsh.md` (or this ADR) should mention the override.

### Confirmation

- With `DOTFILES_AGENT_SHELL=1 zsh -il -c 'alias cat'` (or equivalent), `cat` MUST NOT be aliased to `bat` when `bat` is installed.
- With a clean interactive human session (no opt-in, no agent fingerprints), existing aliases and plugins MUST still load.
- After implementation, add a small BATS or shell check in `test/` that renders the template or sources the predicate fixture and asserts the predicate matches expected env fixtures (optional but recommended).

## Rejected Options

- **(1) documentation-only / `command` prefix**: Fails correctness and performance goals; does not scale across agents and skills.
- **(2) non-interactive heuristic alone**: Fails the correctness driver for common agent shells.
- **(3) `ZDOTDIR`-only solution**: Valuable as an optional adjunct for specific hosts, but not sufficient as the sole strategy because not every agent invocation can set `ZDOTDIR`.
- **(5) forcing `sh` for agents**: Duplicates environment setup and drifts from the real developer shell; rejected in favor of a minimal zsh path inside the existing dotfiles.

## More Information

- Claude Code: `CLAUDECODE` is documented as set to `1` in shell environments Claude Code spawns—primary signal for that stack. See [Environment variables - Claude Code](https://code.claude.com/docs/en/env-vars).
- Cursor: terminal integration and CLI behavior are documented in Cursor’s help/docs; verify `CURSOR_*` variables against the version in use before relying on them in the predicate.
- Repository shell layout: [docs/zsh.md](../zsh.md) (`home/dot_zshenv`, `home/dot_zshrc.tmpl`).
