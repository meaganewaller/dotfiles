# `bd linear` gets its key per invocation

**Date:** 2026-09-22
**Status:** implemented (2026-09-22)
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

```sh
bd() {
	if [ "$1" = linear ]; then
		fnox exec --config "$HOME/.config/fnox/config.toml" --if-missing error -- bd "$@"
	else
		command bd "$@"
	fi
}
```

Five decisions, each with a real alternative:

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

**`--if-missing error`, not fnox's default.** fnox defaults to `warn`: an
unresolvable secret is reported, and then fnox exits 0 and runs the command
anyway. Caught during verification, after the wrapper had already shipped
without it — a real 1Password authorization timeout produced
`WARN … authentication failed`, followed by `bd` running with `LINEAR_API_KEY`
unset and exiting 0. For `bd linear sync` that means talking to Linear
unauthenticated rather than stopping. With the flag, the same condition gives
`ERROR` and exit 1, and `bd` never runs. The retired `secrets` task carried this
flag for the same reason, and the original spec named it as the guard the `trap`
could not provide; the wrapper initially failed to inherit it.

**Written as its own shell files, not added to `aliases.yaml`.** The
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

**Resolved the same day (`dotfiles-ogz`).** Stating the asymmetry prompted the
obvious question — who actually reads that file? — and the answer was nobody:
one writer, zero readers. The export was retired rather than the key narrowed,
which closes the gap from the other end and leaves `[secrets]` exactly as it is.
See the [second amendment](2026-09-20-fnox-secrets-design.md#amendment-2026-09-22-the-file-route-is-retired).

## Changes

### `home/dot_config/shell/bd.sh.tmpl` (new)

A POSIX file shared by zsh and bash, gated on `lookPath` for both `fnox` and
`bd`, following the shape `dot_config/shell/claude.sh.tmpl` already established.

```sh
bd() {
	if [ "$1" = linear ]; then
		fnox exec --config "$HOME/.config/fnox/config.toml" -- bd "$@"
	else
		command bd "$@"
	fi
}
```

**This placement changed during implementation.** The design first put the
function directly in `dot_zshrc.tmpl`. That file sources Oh My Zsh and a great
deal besides, so it cannot be sourced in isolation — which would have reduced
the tests to greps over template text instead of assertions about what the
function does. The repository had already solved exactly this for the Claude
account guard: a POSIX file shared by zsh and bash, with a fish twin. Reusing
that shape also brought bash in for free, which the design had listed as out of
scope.

### `home/dot_config/fish/conf.d/21-bd.fish.tmpl` (new)

The twin. Fish cannot source POSIX shell, so the logic is duplicated rather than
shared, exactly as `10-claude.fish.tmpl` duplicates `claude.sh.tmpl`.

```fish
function bd
    if test "$argv[1]" = linear
        fnox exec --config "$HOME/.config/fnox/config.toml" -- bd $argv
    else
        command bd $argv
    end
end
```

A quoted out-of-range index expands to the empty string in fish, so a bare `bd`
takes the `else` branch and prints its own usage, as before.

No `--wraps`. The idiom for a wrapper function is `--wraps` the underlying
command, but here the function and the command share the name `bd`, so it would
be a completion loop rather than a no-op. Fish resolves completions registered
with `complete -c bd` by name whether `bd` is a function or a binary, so the
flag buys nothing.

### `home/dot_zshrc.tmpl` and `home/dot_bashrc.tmpl`

Each sources the POSIX file, beside the existing `shell/claude.sh` block. In
zshrc that is outside the agent-minimal branch — deliberately, since the
consumer is an agent.

### `test/bd-linear-credential-wrapper.bats` (new)

Four assertions, exercising behavior rather than template text. Both files are
rendered with stub `bd` and `fnox` binaries on `PATH`, then sourced in each
installed shell. The stub `fnox` logs its arguments and then `exec`s whatever
follows `--`, so a wrapper that calls fnox but garbles the command after it
still fails.

1. **`bd linear` is routed through `fnox exec`** in every shell, with the
   machine-wide `--config` and `--if-missing error`, reaching `bd` with its
   arguments intact.
2. **Every other `bd` subcommand skips fnox entirely** — checked across `ready`,
   `prime`, `show`, and `close`. This is the load-bearing one: it fails if the
   function is ever flattened into `alias bd='fnox exec … -- bd'`, which would
   look like a simplification and would put an `op read` in front of every
   hook's `bd` call.
3. **zsh and bash both source the wrapper.** A wrapper nothing sources is
   precisely the state this change exists to fix.
4. **Defining the wrapper does not itself invoke fnox** — sourcing the file and
   running `true` leaves the fnox log empty, so startup stays free of 1Password.

The stubs are on `PATH` during rendering as well as execution, because the
templates gate on `lookPath`; without them the templates would emit nothing and
every assertion would pass vacuously. The tests degrade to the shells present,
with bash as a floor, so a runner missing zsh or fish loses coverage for that
shell rather than passing silently.

`test/shell-startup-secrets.bats` is unchanged and still passes: it matches
`fnox activate`, and this adds `fnox exec` inside a function body.

## Verification

Full suite: 291 tests, no failures.

After `chezmoi apply`:

- `type bd` resolves to the function, in an interactive shell and in an agent
  shell (`CLAUDECODE=1`).
- `bd ready` runs with no Touch ID prompt — the hot path is untouched.
- `bd <TAB>` still completes with the function shadowing the binary.
- With 1Password unable to authorize, `bd linear` exits 1 and `bd` never runs,
  rather than running unauthenticated. Verified against a real authorization
  timeout on 2026-09-22.
- `fnox exec --config "$HOME/.config/fnox/config.toml" -- sh -c 'test -n "$LINEAR_API_KEY"'`
  confirms the key resolves with no `--profile`, since top-level `[secrets]`
  merges into whichever profile is selected. This prompts for Touch ID once and
  does not contact Linear.

## Out of scope

**Retiring `~/.secrets`.** ~~Covered above.~~ Done, same day, as
`dotfiles-ogz`: the file had one writer and no readers, so the route was deleted
rather than left in place. See the
[second amendment](2026-09-20-fnox-secrets-design.md#amendment-2026-09-22-the-file-route-is-retired).

**Enforcing onlooker's `--pull` rule.** The wrapper supplies a credential; it
does not rewrite the command. Silently appending `--pull` to a bare
`bd linear sync` would be a surprising edit to something the caller typed.

**Other `bd` credentials.** `bd linear` is the only subcommand group here that
needs a secret. If another appears, it joins the same condition rather than
earning a second wrapper.
