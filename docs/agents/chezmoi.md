# Chezmoi in this repository

Operational detail for **editing, rendering, and applying** dotfiles managed by [Chezmoi](https://chezmoi.io/). For repository purpose and decision filters, see [Vision](../vision.md) and [Core principles](../core-principles.md). For pins and Renovate, see [Renovate](../renovate.md).

## Source vs destination (critical)

**Never edit Chezmoi-managed files directly under `~` or `~/.config/`** unless you are deliberately bypassing this repo (changes will be overwritten on the next `chezmoi apply`).

All durable edits belong in the **source tree** under `home/` in this repository (or encrypted `private_*` material per Chezmoi’s rules).

| Destination (example) | Source in this repo |
| --- | --- |
| `~/.zshrc` | `home/dot_zshrc.tmpl` or `home/dot_zshrc` |
| `~/.config/mise/config.toml` | `home/dot_config/mise/config.toml` |
| `~/.config/nvim/` | `home/dot_config/nvim/` |
| `~/.config/ghostty/config` | `home/dot_config/ghostty/config` |

Prefix rules:

- **`dot_`** — becomes a dotfile or dot-directory under `$HOME` (e.g. `dot_zshrc` → `.zshrc`).
- **`dot_config/`** — maps to `~/.config/`.
- **`private_`** — sensitive or machine-local content; treat as non-public and follow Chezmoi encryption rules for those paths.

## Layout in this repo

- **`sourceDir`** — Repository root (`{{ .chezmoi.workingTree }}`); managed paths live under `home/`.
- **Templates** — Files ending in `.tmpl` are rendered with Go `text/template` before install.
- **`run_onchange_*`** — Scripts under `home/` run when their declared content changes (e.g. package installs).
- **Data for templates** — e.g. `home/.chezmoidata/` for structured values consumed by templates.

Common template variables include:

- `.chezmoi.os` — `darwin`, `linux`, etc.
- `.chezmoi.workingTree` — path to this repo on disk.
- `.packages.darwin.brews` / `.casks` — Homebrew selections where templated.

## Day-to-day workflow

Use this sequence for normal changes:

1. **Edit** only under `home/` (or add new managed files there).
2. **Preview** with `chezmoi diff` — confirm only intended paths change; investigate noise before applying.
3. **Apply**
   - Full tree: `chezmoi apply`
   - Targeted: `chezmoi apply ~/.zshrc ~/.config/mise/config.toml` (adjust paths to match what you changed).
4. **Validate** with `chezmoi status` — a clean status means destinations match source; remaining diffs usually mean partial apply or edits outside the repo.

```bash
# Example
vim home/dot_zshrc.tmpl
chezmoi diff
chezmoi apply ~/.zshrc
chezmoi status
```

### Claude Code / agent workflow

1. Prefer **`/install <package>`** for new tools (see root `AGENTS.md` for Package Manager routing on sensitive manifests).
2. Edit **only** in `home/` for dotfiles.
3. Run **`chezmoi diff`** before apply; use **partial apply** when unrelated drift appears.
4. **`chezmoi status`** after apply.
5. **Commit** with a Conventional Commit message per logical change.

This repository may also register **hooks** (e.g. `.claude/hooks/enforce-source-dir.sh` in the dotfiles repo) that block writes to `~` targets—still follow source-only discipline even when hooks are absent.

## Adding new managed files

1. Place the file under `home/` with the appropriate `dot_` / `dot_config/` / `private_` naming.
2. Prefer templates (`.tmpl`) when content depends on OS, hostname, or data files.
3. Run `chezmoi diff` / `chezmoi apply` / `chezmoi status` as above.

## Scripts in this repo

Scripts invoked by install or `run_onchange_*` should be:

- **Idempotent** where possible.
- **Strict** — `set -o errexit -o nounset` (and `pipefail` when using bash).
- **`DEBUG`-aware** — honor `DEBUG=1` for verbose logging when helpful.
- **Defensive** — check for required binaries before destructive steps.

## Testing

Tests use [BATS](https://github.com/bats-core/bats-core). From the repo root (after `./bin/setup` / mise dev tools):

```bash
bats test/
bats test/run_onchange_install-mise-tools.bats
bats -t test/
```

Shared helpers live in `test/test_helper.bash` (e.g. `assert_valid_shell`, `assert_script_structure`).

## Troubleshooting

| Symptom | Things to check |
| --- | --- |
| Tool not found | `~/.local/bin` on `PATH`; mise shims activated in the shell you use. |
| Template render errors | Template syntax; variables only available on certain OSes or machines. |
| Permission errors | Writable home; correct ownership on `~/.config`. |
| Signature / download failures during `./install` | Network; `VERIFY_SIGNATURES=false` only as a last resort (not recommended). |

Verbose Chezmoi / installer output:

```bash
DEBUG=1 ./install
DEBUG=1 chezmoi apply -v
```

## Security notes

- **`./install`** may verify release artifacts (e.g. cosign) depending on environment; see installer header comments.
- **`private_*`** paths are for secrets—do not paste secret values into public issues or skills.

## Related docs

- [Zsh and shell layout](../zsh.md)
- [Renovate and package pins](../renovate.md)
- [Package management](../package-management.md) (adding/updating packages)
- [ADRs](../adrs/README.md) for recorded decisions (e.g. agent-aware shell)
