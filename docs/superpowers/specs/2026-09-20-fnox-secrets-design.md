# API keys in `~/.secrets` via fnox

**Date:** 2026-09-20
**Status:** implemented (2026-09-20)
**Beads:** [`dotfiles-4zt`](#changes) (implementation), [`dotfiles-vv3`](#out-of-scope) (follow-up decision)

Giving coding agents and dotenv-only tools a materialized `~/.secrets` file, by
finishing the fnox wiring that is already installed and currently does nothing.

## Context

The original ask was a `.chezmoidata` file mapping environment variable names to
1Password references, plus a script that reads it and writes a plaintext
`~/.secrets`. Exploring the repository first turned up three facts that changed
the shape of the answer.

### fnox is installed, activated, and unconfigured

| | Location | State |
| --- | --- | --- |
| Binary | `home/dot_config/mise/config.toml.tmpl` `[tools] fnox = "latest"` | installed, 1.24.0 |
| mise env plugin | `_.fnox-env = { tools = true, profile = "…" }` | active, profile switches on `.work_profile` |
| fish activation | `home/dot_config/fish/conf.d/fnox.fish` | active |
| Manifest | — | **does not exist anywhere** |

`fnox doctor` from `$HOME` on 2026-09-20 reports `No configuration file found in
/Users/meaganwaller or any parent directory`. So the profile-aware plumbing is
in place and inert. Building a second, homegrown secret system beside it would
leave that dangling permanently.

### There is already a credentials pattern, and it is deliberately not this one

`home/.chezmoidata/aliases.yaml` carries a `credentials:` list:

```yaml
credentials:
  - { tool: claude, alias: claude-api, env: ANTHROPIC_API_KEY, op_ref_key: claude_api }
  - { tool: bktide, env: BUILDKITE_API_TOKEN, op_ref_key: buildkite }
```

`home/dot_zshrc.tmpl` renders each into an alias that runs `op read` on **every
invocation**, and the actual `op://` refs live machine-local in
`.chezmoi.toml.tmpl` under `[data.credentials]`, prompted at `chezmoi init`. The
comments in that file are explicit that the split exists because
`meaganewaller/dotfiles` is public.

This matters twice over. It is prior art for how secrets are shaped here, and it
is a stronger guarantee than what this spec builds: a secret fetched per
invocation never enters the environment at all.

### The existing `~/.secrets` is hand-made and world-readable

```
-rw-r--r--  /Users/meaganwaller/.secrets
export LINEAR_API_KEY=…
```

One hand-written line, mode `0644`, and nothing in zsh, bash, or fish sources
it. The permissions are the immediate bug; the absence of any consumer is the
reason it has gone unnoticed.

### Measured facts

Run on 2026-09-20 against fnox 1.24.0 and `op` 2.38.1. Nothing was modified.

- **fnox has a global config.** `fnox init --global` initializes
  `~/.config/fnox/config.toml`. Without it, config discovery is cwd-and-parents
  only, which is why `fnox config-files` from `$HOME` returns nothing today.
  This is what makes a chezmoi-managed, XDG-correct manifest possible; per-project
  `fnox.toml` files still layer on top.
- **`1password` is a first-class provider type.** Confirmed in
  `fnox provider add --help`. The implementation shells out to `op inject` and
  accepts either an `op signin` session or `OP_SERVICE_ACCOUNT_TOKEN`. `op account
  list` already returns an active account, so the desktop app's biometric unlock
  covers authentication; the service-account guidance in the fnox skill is aimed
  at CI.
- **Full `op://` URIs are a supported secret value**, alongside the bare
  item-name and `Item/field` forms.
- **`fnox export` writes a file directly**, and `--output <path>` respects the
  caller's umask (verified: `umask 022` produced `-rw-r--r--`, `umask 077`
  produced `-rw-------`).
- **`--format env` emits `export KEY='value'`**, not the bare `KEY=value` this
  spec originally assumed. Single-quoted, with an `export` prefix, under a
  four-line header that includes an `# Exported at:` timestamp.
- **Single quotes in a value corrupt the entire file.** fnox does not escape
  them: a value of `it's` exports as `export K='it's'`, and sourcing the result
  fails with ``unexpected EOF while looking for matching `'``. The failure is
  file-wide, not confined to the offending line — one bad value takes every
  other key down with it. See [Guards](#guards).
- **`fnox mcp` exists** — "Start an MCP server for secret-gated AI agent access."
  Considered and set aside; see [Out of scope](#out-of-scope).

## Decision

Use fnox as the manifest. Keep `~/.secrets` as a generated export.

Four decisions were taken deliberately, each with a real alternative:

**The manifest is committed, holding `op://` pointers.** A reference names a
vault and an item; it is not a credential. Committing it buys a reviewable,
diffable inventory and a new machine that works without re-prompting. This does
reverse the machine-local convention that `[data.credentials]` established —
knowingly, because that convention exists to keep *client* identifiers out of a
public repo, and personal vault item names do not carry the same exposure.

**A global fnox manifest, not a `.chezmoidata` YAML file.** The original ask was
a `.chezmoidata` file, which would have matched `aliases.yaml` in shape. It was
rejected because fnox already provides the fetching, profile selection, and
export that the accompanying script would have hand-rolled, and because a
`.chezmoidata` file only becomes real through a template that consumes it —
giving two artifacts where fnox needs one.

**Generation is on demand, not on `chezmoi apply`.** A `run_onchange_` script
would keep the file always fresh, at the cost of every `chezmoi apply` requiring
an unlocked 1Password or failing. `apply` runs constantly in this repository;
that trade is bad. A global mise task means plaintext lands on disk only when
asked for.

**`~/.secrets` is written by atomic replace, not `export`-then-`chmod`.** The
naive sequence leaves a window where a file full of live API keys is
world-readable — which is precisely the state the current hand-made file is in.

## Changes

### `home/dot_config/fnox/config.toml` (new)

A plain file, not a template: nothing in it is machine-local, and profile
selection happens at runtime via mise.

```toml
[providers]
onepassword = { type = "1password" }

[secrets]
LINEAR_API_KEY = { provider = "onepassword", value = "op://Automation/Linear Onlooker API Key/credential" }
```

The `LINEAR_API_KEY` reference is the real one, confirmed in
[Migration](#migration). No `[profiles.work.secrets]` block ships in the initial
manifest — there is no work-only key to put in it yet. The block is added when
one exists; the profile plumbing is already proven to work.

Top-level `[secrets]` merges into whichever profile mise selects, so shared keys
belong there and only work-only keys need a `[profiles.work.secrets]` entry. The
`personal` profile needs no block of its own.

### `home/dot_config/mise/config.toml.tmpl`

Adds the first `[tasks]` block in the global mise config, making `mise run
secrets` available from any directory:

```toml
[tasks.secrets]
description = "Regenerate ~/.secrets from the fnox manifest"
run = '''
umask 077
tmp="$(mktemp "$HOME/.secrets.XXXXXX")"
trap 'rm -f "$tmp"' EXIT
fnox export --config "$HOME/.config/fnox/config.toml" --if-missing error --profile {{ if .work_profile }}work{{ else }}personal{{ end }} --format env --output "$tmp"
bash -n "$tmp"
mv -f "$tmp" "$HOME/.secrets"
'''
```

`mktemp` creates at `0600`; `mv` replaces atomically. The file is never briefly
world-readable.

The temp file is created **in `$HOME`, not `$TMPDIR`**, deliberately. On macOS
`$TMPDIR` resolves under `/var/folders`, a different APFS volume from `/Users`;
`mv` across volumes degrades from an atomic rename to a copy-then-unlink, which
reintroduces the window this construction exists to close. Same directory means
a true `rename(2)`.

The `trap` matters because `fnox export` can fail partway — a value that breaks
`bash -n`, or (with `--if-missing error`) an unresolvable secret — and without
it a partial or empty `.secrets.XXXXXX` full of live keys would be left behind
in `$HOME` on every failure. The trap does **not**, by itself, protect against a
locked 1Password or a deleted vault item: fnox's default `--if-missing warn`
reports success (exit 0) for an unresolvable secret, so the task never fails,
the trap never fires as a save, and a comments-only, zero-secret export gets
`mv`'d over a known-good `~/.secrets`. That silent-success case needed the
separate `--if-missing error` guard, not the trap.

`bash -n` parses without executing, which catches the single-quote corruption
described in [Measured facts](#measured-facts) for the common case: an odd
number of stray quotes breaks quoting and fails to parse. It is not a complete
guard — an even number of quotes still parses as valid shell, just with a
silently wrong value (`a'b'c` parses fine and yields `abc`). Running it on the
temp file rather than after the `mv` is still the whole point for what it does
catch: a syntax-breaking export aborts the task and leaves the previous
`~/.secrets` intact.

**`--config` is the load-bearing flag here, not a tidiness nicety.** fnox merges
every `fnox.toml` from the cwd up through its ancestors. `mise run secrets` is
invocable from any directory, so without an explicit config path, running it
from inside a project that has its own `fnox.toml` would silently fold that
project's secrets into the machine-wide `~/.secrets`. Verified on 2026-09-20:
from a nested directory, a bare export emitted both the parent's and the child's
keys, while `--config <parent>` emitted only the parent's — isolation is
complete, including against ancestors further up.

## Guards

Five failure modes are designed against explicitly, because each one is silent:

| Failure | Guard |
| --- | --- |
| A value contains `'`, corrupting every key in the file | `bash -n` on the temp file, before `mv` |
| Export fails partway, stranding live keys in `$HOME` | `trap … EXIT` removes the temp file |
| The file is world-readable, even briefly | `umask 077` + same-filesystem `mktemp`, atomic `mv` |
| A project's `fnox.toml` leaks into the machine-wide file | `--config "$HOME/.config/fnox/config.toml"` pins the manifest |
| An unresolvable secret (locked 1Password, deleted vault item) silently succeeds and exports zero secrets | `--if-missing error` makes that exit non-zero instead |

The quote hazard is latent rather than immediate — the keys in play today are
alphanumeric — but it surfaces as a broken shell profile at some unrelated
future moment, which is a bad way to find out.

### `home/dot_local/libexec/executable_block-sensitive-or-generated-writes`

The current `sensitive_path_regex` matches `secrets.toml` and `secrets.yaml`
through its `(^|/)(credentials|secrets?)\.(json|ya?ml|toml|env)$` branch, but
**not** a bare `~/.secrets` — there is no extension to match. Add it, so the
`Write`/`Edit`/`MultiEdit` tools are blocked from hand-editing a generated file
and having the edit silently disappear on the next `mise run secrets`. This is
a PreToolUse hook gating those three tool calls specifically, not an absolute
guarantee — a shell redirection like `cat > ~/.secrets` run through the `Bash`
tool is unaffected.

The fnox manifest is deliberately *not* added: it holds pointers rather than
values, and it has to stay editable.

### Migration

`LINEAR_API_KEY`'s 1Password reference moves into the manifest and the file is
regenerated. The `0644` permissions problem is resolved by the regeneration
rather than by a separate `chmod`.

The reference was **not** knowable from the repository — the current `~/.secrets`
holds a bare value with no record of its origin, and the vault contains several
plausible candidates (`Linear Onlooker API Key` in `Automation`, `Linear` in
`Development`). It was resolved on 2026-09-20 by hashing the live value and
comparing it against each candidate's fields, rather than guessed:

```
op://Automation/Linear Onlooker API Key/credential
```

Confirmed end to end: `fnox get LINEAR_API_KEY` through a bare `1password`
provider returns a 48-character value matching the one currently in the file.

`LINEAR_API_KEY` is the only key in the initial manifest. It is the only entry
in the current `~/.secrets`, and the two keys carried by the alias mechanism are
explicitly out of scope.

### `test/fnox-config.bats` (new)

Per the repository's existing per-script BATS convention:

- the manifest parses as TOML
- every entry under `[secrets]` and any `[profiles.*.secrets]` declares a
  `provider` and an `op://`-shaped `value`
- no entry contains a literal secret value

### `test/block-sensitive-or-generated-writes.bats`

Extended to assert `~/.secrets` is denied.

## Consumers

All three requested consumers are served, but not all by the same mechanism, and
one of them is worth stating plainly because it is easy to assume otherwise.

| Consumer | Mechanism |
| --- | --- |
| Coding agents, subprocesses | read or source `~/.secrets` |
| Dotenv-only tools | read `~/.secrets` — but see the `export` prefix note below |
| Interactive shells | **native, via the mise `_.fnox-env` plugin** — they do not source `~/.secrets` |

Because `--format env` emits `export KEY='value'` rather than bare `KEY=value`,
the file sources directly in `sh`/`bash`/`zsh` with no `set -a` wrapper. The
cost lands on the dotenv side instead: parsers that do not strip a leading
`export` will read the key name as `export KEY`. Most common implementations
(`python-dotenv`, `dotenv-rb`, `godotenv`) do strip it, so this is a
per-tool question to check when one is added, not a blocker.

Shells were named as a consumer in the original ask. They are covered, but
sourcing the file would be redundant with the plumbing already active in mise
and fish, so nothing in this design does it.

## Resolved before planning

Both questions this spec originally left open were settled empirically on
2026-09-20 against a throwaway manifest, before the implementation plan was
written. Neither changed the design; one corrected a factual claim.

- **Quoting** is `export KEY='value'`, not bare `KEY=value`. Corrected in
  [Measured facts](#measured-facts) and [Consumers](#consumers). The single-quote
  escaping bug surfaced during this check and produced the `bash -n` guard.
- **Provider keys:** a bare `{ type = "1password" }` block works. No `account`
  or `vault` key is needed when every secret carries a fully-qualified `op://`
  URI, including URIs whose item name contains spaces.
- **Profile merge** behaves as designed: with a top-level `[secrets]` and a
  `[profiles.work.secrets]`, exporting `-P personal` yields only the shared keys
  and `-P work` yields shared plus work-only.

## Out of scope

**The `op read` credential aliases stay exactly as they are.** `aliases.yaml`'s
`credentials:` list, the `[data.credentials]` prompts, and the rendered zshrc
aliases are untouched. Consolidating them into fnox for the sake of consistency
would trade away the stronger per-invocation property described in
[Context](#there-is-already-a-credentials-pattern-and-it-is-deliberately-not-this-one).
The cost of leaving it is that `ANTHROPIC_API_KEY` and `BUILDKITE_API_TOKEN` have
two plausible homes, and that fish has no alias equivalent, so today those two
keys are zsh-only. Tracked as `dotfiles-vv3` to be decided deliberately rather
than by drift.

**`fnox mcp` is not set up.** Gating agent access behind an MCP server is very
likely a better long-term answer for the agent consumer than a plaintext file,
since it removes the file entirely. It is a different design with a different
blast radius, and folding it in here would mean not delivering the thing that
was asked for.

**No age provider, no encrypted-in-git secrets.** Every value resolves from
1Password at export time. Nothing encrypted is committed, so there is no key
distribution or rotation story to build.
