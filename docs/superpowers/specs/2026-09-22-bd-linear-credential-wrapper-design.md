# `bd linear` gets its key per invocation

**Date:** 2026-09-22
**Status:** designed
**Beads:** [`dotfiles-6y1`](#changes)

A shell function that supplies `LINEAR_API_KEY` to `bd linear`, and to nothing
else, without putting it in the environment or in the path of opening a shell.

## Context

[The fnox secrets design](2026-09-20-fnox-secrets-design.md) ended with an
amendment: interactive shells get nothing, because injecting `LINEAR_API_KEY`
through mise's `_.fnox-env` cost two 1Password unlocks per terminal and one per
shim invocation. That was the right call. It also left the key with no route to
its consumer.

### The file route has no reader

`mise run secrets` materializes `~/.secrets`, and the spec describes that file
as serving "agents and dotenv-only tools." Measured on 2026-09-22:

```
-rw-------  /Users/meaganwaller/.secrets     # Total secrets: 1
fish -l -c 'set -q LINEAR_API_KEY'           # UNSET
```

Nothing in `dot_zshrc.tmpl`, `dot_bashrc.tmpl`, or `fish/conf.d/` sources the
file. The two greps that match `secrets` in the rendered shell configs are
comments in the credential-alias blocks. This is not new breakage — the original
spec observed the same thing about the hand-made file it replaced: "nothing in
zsh, bash, or fish sources it." The generated file inherited the property.

So `~/.secrets` is written on demand and read by no one. The gap went unnoticed
because the key was reaching shells by the other route, until that route was
removed.

### The consumer is an agent, and it types the documented command

`bd linear sync --pull` appears nowhere in this repository as an automated call.
It appears in onlooker's `ecosystem` plugin, in both `CLAUDE.md` and `AGENTS.md`:

> **Never run a bare `bd linear sync` or `bd linear push`.** […] `bd linear sync --pull`.

That is an instruction to an agent, and it names the command verbatim. Any
wrapper published under a different name — `bdsync`, `bd-linear-sync` — would be
correct and never invoked, because the documentation the agent follows says
`bd linear sync --pull`.

Agents do inherit shell definitions here. Measured in a Claude Code session
(`CLAUDECODE=1`, shell `/bin/zsh`, which sources `.zshrc`):

```
type claude-api  →  alias for fnox exec --config … --profile claude -- claude
type bktide      →  not found        # lookPath gate; bktide is not installed
```

The credential aliases sit outside the agent-minimal branch of `dot_zshrc.tmpl`,
under the comment "always be available, for humans & agents." That placement is
what makes a shell-level fix viable for an agent consumer at all.

### A whole-tool alias would re-create the problem it solves

The existing pattern in `.chezmoidata/aliases.yaml` wraps a whole binary:

```yaml
credentials:
  - { tool: claude, alias: claude-api, profile: claude }
  - { tool: bktide, profile: buildkite }
```

`claude` and `bktide` are invoked deliberately, a few times a day. `bd` is not:
session hooks, `bd prime`, `bd ready`, `bd show`, `bd close` run constantly and
often several times per turn. Wrapping the binary would put an `op read` in
front of every one of them — the same per-invocation Touch ID cost that
`_.fnox-env` was removed for, relocated from shell startup to shell use.

Only `bd linear` needs the key.

## Decision

A shell function named `bd` that dispatches on its first argument.

```zsh
bd() {
  if [[ "$1" == linear ]]; then
    fnox exec --config "$HOME/.config/fnox/config.toml" -- bd "$@"
  else
    command bd "$@"
  fi
}
```

Four decisions, each with a real alternative:

**Dispatch on `linear`, not on `linear sync`.** Every `bd linear` subcommand
talks to the same API and needs the same key, so the narrower match would need
extending the first time `bd linear push` or `bd linear status` is run. One
condition covers the group, and nothing under `bd linear` is on the hot path.

**The function is defined at startup and invoked on demand.** This is the whole
reason it is a function and not an environment variable. Defining it costs
nothing; `fnox` runs only when a `bd linear` command is actually typed. Shell
startup continues to make zero `op` calls, which
`test/shell-startup-secrets.bats` already guards.

**The fnox branch ends in `-- bd "$@"`, not `-- command bd "$@"`.** `command` is
a shell builtin, and `fnox exec` does a `PATH` lookup — passing it `command`
would fail to exec. Because `fnox exec` spawns a fresh process, shell functions
do not exist there, so plain `bd` resolves to the real binary. There is no
recursion to guard against. The `else` branch does need `command bd`, since it
runs inside the function's own shell.

**Written in the two shell templates, not added to `aliases.yaml`.** The
`credentials:` list emits flat `alias X='fnox exec … -- tool'` lines and cannot
express subcommand dispatch. Generalizing that data shape — adding a `command:`
or `subcommand:` key and the template logic to consume it — would be a framework
serving one caller. The accepted cost is one credential route that the data file
does not describe; this document and the test are where that is recorded, so it
is not rediscovered later as drift.

### `LINEAR_API_KEY` stays in top-level `[secrets]`

Moving it to a `[profiles.linear.secrets]` block would give it the stronger
property the `claude` and `buildkite` profiles have: never written to disk at
all. It is deliberately not done here.

`LINEAR_API_KEY` is the only key in `[secrets]`. Moving it would leave
`~/.secrets` holding zero secrets and `mise run secrets` exporting nothing —
retiring the file route rather than narrowing one key. That may well be correct,
and the original spec already flagged `fnox mcp` as the likely better answer for
the agent consumer, but it is a different change with a different blast radius
and it should be decided on its own terms.

So this wrapper buys **shell-environment absence, not on-disk absence**. The key
still sits in plaintext in `~/.secrets` after any `mise run secrets`. That is
weaker than what `claude-api` and `bktide` get, and it is stated here plainly so
the asymmetry is not mistaken for an oversight.

## Changes

### `home/dot_zshrc.tmpl`

Beside the credential-alias block, inside the "always available, for humans &
agents" section — outside the agent-minimal branch, which is what gives an agent
shell the function.

```zsh
{{- if and (lookPath "fnox") (lookPath "bd") }}
bd() {
  if [[ "$1" == linear ]]; then
    fnox exec --config "$HOME/.config/fnox/config.toml" -- bd "$@"
  else
    command bd "$@"
  fi
}
{{- end }}
```

### `home/dot_config/fish/conf.d/20-credentials.fish.tmpl`

The twin, matching how the alias block is already twinned across the two shells.

```fish
{{- if and (lookPath "fnox") (lookPath "bd") }}
function bd
    if test "$argv[1]" = linear
        fnox exec --config "$HOME/.config/fnox/config.toml" -- bd $argv
    else
        command bd $argv
    end
end
{{- end }}
```

Fish returns an empty string for an out-of-range index, so `bd` with no
arguments takes the `else` branch and prints its own usage, as today.

No `--wraps`. The idiom for a wrapper function is `--wraps` the underlying
command, but here the function and the command share the name `bd`, and a
self-referential wrap is a completion loop rather than a no-op. Fish resolves
completions registered with `complete -c bd` by name regardless of whether `bd`
is a function or a binary, so the flag buys nothing here. To be confirmed during
implementation: that `bd <TAB>` still completes with the function in place.

### `test/bd-linear-credential-wrapper.bats` (new)

Three assertions:

1. **The wrapper exists in both templates.** Catches one shell drifting from the
   other, which is the failure mode the zsh/fish twinning has.
2. **A non-`linear` fallback branch exists.** This is the load-bearing one. It
   fails if the function is ever flattened into `alias bd='fnox exec … -- bd'`,
   which would look like a simplification and would put an `op read` in front of
   every hook's `bd` call.
3. **Both rendered templates parse**, via the existing `assert_valid_shell`
   helper.

`test/shell-startup-secrets.bats` is unchanged and must keep passing: it matches
`fnox activate`, and this adds `fnox exec` inside a function body.

## Verification

After `chezmoi apply`:

- `type bd` resolves to the function, in an interactive shell and in an agent
  shell (`CLAUDECODE=1`).
- `bd ready` runs with no Touch ID prompt — the hot path is untouched.
- `fnox exec --config "$HOME/.config/fnox/config.toml" -- sh -c 'test -n "$LINEAR_API_KEY"'`
  confirms the key resolves with no `--profile`, since top-level `[secrets]`
  merges into whichever profile is selected. This prompts for Touch ID once and
  does not contact Linear.

## Out of scope

**Retiring `~/.secrets`.** Covered above. If no consumer is ever wired to it,
the honest follow-up is deleting the route, not leaving a file nothing reads.

**Enforcing onlooker's `--pull` rule.** The wrapper supplies a credential; it
does not rewrite the command. Silently appending `--pull` to a bare
`bd linear sync` would be a surprising edit to something the caller typed.

**`bash`.** `dot_bashrc.tmpl` is described in the repository as minimal and has
no credential-alias block to twin. Adding one is not required by any consumer
found here.
