# treegraft

Filter a tar.gz archive down to selected subtrees, optionally re-rooting
each one to a different destination path.

Reads a gzipped tar archive on stdin and writes a plain (uncompressed) tar
archive on stdout.

## Why

This is the `filter.command` for [chezmoi](https://www.chezmoi.io/)
externals that deploy AI skills: chezmoi downloads a pinned upstream
repository archive, pipes it through `treegraft` to pick out and re-root
individual skill (or agent) directories, and extracts the result straight
into the target directory. No clone of the whole upstream repo ends up on
disk — just the pieces you asked for, in the shape you want them.

`treegraft` is stdlib-only and has no dependencies. It's invoked by file
path via system `python3` at `chezmoi apply` time, before tools like `uv`
or `mise` are installed, so it can't rely on anything beyond the standard
library.

## Usage

```
python3 main.py --strip-components N --select SRC[:DEST] [--select ...] [--transform NAME]
```

- `--strip-components N` — drop the first `N` path components of every
  archive member before matching selections, the same way
  `tar --strip-components` does. GitHub-style repository archives nest
  everything under a single `<repo>-<ref>/` directory, so this is usually
  `1`.
- `--select SRC[:DEST]` — repeatable. `SRC` is a directory (or file) path
  inside the archive, after prefix stripping. `DEST` is where it lands in
  the output:
  - Omitted — defaults to the basename of `SRC` (i.e. the subtree keeps its
    own directory name at the output root).
  - A path — the subtree's contents are placed under that path.
  - `.` — the subtree's contents are placed directly at the output root,
    with no extra directory level.

  At least one `--select` is required.
- `--transform NAME` — rewrite the frontmatter of every selected `.md`
  file. See [Transforms](#transforms) below.

Members outside every selected subtree are dropped silently. Everything
else about each member (permissions, mtime, uid/gid, file type) is passed
through unchanged — only the path is rewritten, and only file *contents*
are touched when `--transform` is given.

### Example

```sh
python3 main.py --strip-components 1 --select skills/brainstorming:. \
  < repo.tar.gz > skill.tar
```

Given an archive shaped like:

```
repo-main/
  skills/
    brainstorming/
      SKILL.md
      reference.md
    other-skill/
      ...
```

this strips the `repo-main/` prefix, keeps only `skills/brainstorming/`,
and re-roots its *contents* (because `dest` is `.`) to the top of the
output tar:

```
SKILL.md
reference.md
```

Multiple `--select` flags can pull several subtrees out of the same
archive in one pass, each with its own destination.

## Selection semantics

- A selection matches a member if its (prefix-stripped) path is exactly
  `SRC`, or is nested under `SRC/`.
- `SRC` may point at a single file rather than a directory. With `DEST` of
  `.`, the file lands at the output root under its own basename (there's
  no relative substructure to place, so there's nothing to collapse to).
- If a selected directory's own entry would land at the output root (i.e.
  matched with `DEST` of `.` and no relative path), that entry is simply
  dropped — its children are still emitted individually, and a
  zero-length root directory member isn't meaningful in a tar.
- Selections are checked in the order given; the first one that matches a
  member's path wins.

## Safety

- **Symlinks and hardlinks are skipped**, with a warning to stderr. They're
  not followed or rewritten — dropped outright.
- **Absolute paths and `..` path components abort the run** with a
  nonzero exit and an error to stderr, rather than being sanitized or
  silently dropped. Pinned-checksum archives from a trusted upstream
  should never contain either; if one shows up, something is wrong enough
  to want a hard failure instead of best-effort cleanup.

## Transforms

`--transform` rewrites the frontmatter block (the `---`-delimited YAML at
the top of a Markdown file) of every selected `.md` file. Files without a
recognizable `---`-delimited frontmatter block, or that aren't `.md`, pass
through untouched.

Every transform:
- Derives `name` from the **destination file's basename** (e.g.
  `SKILL.md` → `SKILL`, `reviewer.md` → `reviewer`) — not from any `name`
  field that may already be present in the source frontmatter.
- Carries the source's `description:` line over verbatim (empty string if
  none is present).
- Leaves the document body (everything after the closing `---`)
  completely unchanged.

| Transform | Purpose | Output frontmatter |
|---|---|---|
| `agent-skill` | Convert a Claude Code agent `.md` into `SKILL.md` form, for tools that consume agents as skills | `name`, `description` |
| `agent-opencode` | Emit [opencode](https://opencode.ai) agent frontmatter | `name`, `description`, `mode: subagent` |

Because `name` comes from the basename, a source file's own frontmatter
`name:` field is ignored — the output filename (as rewritten by
`--select`) is what determines the emitted name. Pick `DEST` filenames
accordingly.

## Development notes

- Single file, stdlib-only (`argparse`, `posixpath`, `re`, `sys`,
  `tarfile`, `io`). No third-party dependencies, no packaging — it's meant
  to be dropped in place and run by path.
- Streams both the input (`tarfile` mode `r|gz`) and output (`w|`) rather
  than buffering the whole archive, so it scales to large upstream repos.
- Exits nonzero with a message on stderr for all fatal conditions
  (missing `--select`, unsafe paths); non-fatal issues (skipped
  symlinks/hardlinks) print a warning and continue.