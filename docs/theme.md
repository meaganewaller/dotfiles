# Theme switcher

`theme` switches every themed tool on this machine at once. The design and the
options it rejected are in [ADR 0005](adrs/0005-universal-theme-switcher.md);
this page is how it works today and how to change it.

## Using it

| Command | Does |
| --- | --- |
| `theme` | Print the active theme (the catalog default if none has been set) |
| `theme list` | List the themes in the catalog |
| `theme <name>` | Make `<name>` active and run every applier |
| `theme <name> -n` | Dry run: check `<name>` exists and list the appliers, change nothing |

Switching never touches the chezmoi source tree, so it never shows up in
`chezmoi diff` or `git status`.

## Where things live

| Piece | Source | Deployed to |
| --- | --- | --- |
| Catalog | `home/.chezmoidata/themes.yaml` | `~/.config/theme/themes.json` (rendered by `home/dot_config/theme/themes.json.tmpl`) |
| Entrypoint | `home/dot_local/bin/executable_theme` | `~/.local/bin/theme` |
| Lookup helper | `home/dot_local/libexec/dotfiles/executable_theme-lookup` | `~/.local/libexec/dotfiles/theme-lookup` |
| Appliers | `home/dot_local/libexec/dotfiles/theme.d/executable_<tool>` | `~/.local/libexec/dotfiles/theme.d/<tool>` |
| Registry check | `home/.chezmoiscripts/run_onchange_after_verify-theme-registry.sh.tmpl` | runs on `chezmoi apply` |
| Active theme | not in source | `~/.local/state/theme/current` |
| Per-tool overlays | not in source | `~/.local/state/theme/` |

`~/.local/state` follows `$XDG_STATE_HOME` when it is set, and the catalog path
follows `$XDG_CONFIG_HOME`; `THEME_CATALOG` overrides the catalog path outright.

## How a switch runs

1. `theme <name>` checks `<name>` is a key under `palettes` in the catalog.
2. It writes `<name>` to `~/.local/state/theme/current`.
3. It runs every executable in `theme.d/`, in name order, passing `<name>`,
   and prints `ok` or `fail` for each. One failing applier doesn't stop the
   rest; `theme` exits non-zero if any failed.

Each applier asks `theme-lookup <tool> <name>` for its token: the value under
`palettes.<name>.<tool>`. If that theme has no entry for the tool, the lookup
falls back to the default theme's entry, so only the default palette has to be
complete.

## The appliers

| Tool | What its applier does | Live update? |
| --- | --- | --- |
| `tmux` | Writes pane and window styles to an overlay and sources it into the running server | Yes |
| `nvim` | Writes the colorscheme name for `lua/theme/init.lua` to read at startup and notifies running instances over their sockets | Yes |
| `ghostty` | Writes a config overlay holding only `theme = …`, which Ghostty's config includes | New windows only; reload open ones with `cmd+shift+,` |
| `starship` | Renders a full starship config with the palette pinned, since starship has no include mechanism; zsh and fish point `STARSHIP_CONFIG` at it before each prompt | Next prompt |
| `sketchybar` | Writes a Lua color table that the SbarLua config loads over its defaults, then reloads the bar | Yes |
| `claude-powerline` | Only checks the catalog has an entry: the statusline wrapper reads the state file on every render | Next render |

## Adding a theme

Add a palette under `themes.palettes` in `home/.chezmoidata/themes.yaml`. Give
it a token for each tool you want to change; tools you leave out use the
default theme's token. Then `chezmoi apply` and `theme <name>`.

A token is whatever that tool's applier understands, and it is keyed by token,
not by theme name. A new theme that reuses `tmux: catppuccin-mocha` works with
no applier change; a genuinely new tmux palette needs a new branch in the tmux
applier's `case`.

## Adding a tool

1. Write `home/dot_local/libexec/dotfiles/theme.d/executable_<tool>`. Take the
   theme name as `$1`, get your token from `theme-lookup <tool> "$1"`, and write
   your overlay under `~/.local/state/theme/`.
2. Add a `<tool>` key to the default palette, and to any other palette that
   should differ from the default.
3. Add the applier to the hash list at the top of
   `run_onchange_after_verify-theme-registry.sh.tmpl`, so editing it re-runs
   the registry check.
4. Point the tool's own config at the overlay.

## The registry check

On `chezmoi apply`, `run_onchange_after_verify-theme-registry` fails if the
default palette and `theme.d/` disagree: a tool key with no applier, or an
applier with no tool key. It then re-applies the current theme, so editing an
applier or the catalog takes effect without a manual `theme <name>`. Its BATS
spec is `test/run_onchange_after_verify-theme-registry.bats`.
