#!/usr/bin/env python3
"""treegraft - filter a tar.gz archive down to selected, re-rooted subtrees.

Reads a gzipped tar archive on stdin and writes a plain tar archive on
stdout. Used as the ``filter.command`` for chezmoi externals that deploy AI
skills: chezmoi downloads a pinned upstream repository archive, pipes it
through this tool to select and re-root individual skill directories, and
extracts the result to the target directory.

This module is intentionally self-contained and stdlib-only. It runs via
system python3 at chezmoi apply time, before uv or mise are installed, and
is invoked by file path rather than as an installed package.

See README.md for full usage and examples.
"""
import argparse
import posixpath
import re
import sys
import tarfile
from io import BytesIO

FRONTMATTER_RE = re.compile(r"\A---\n(.*?\n)---\n?(.*)\Z", re.DOTALL)
DESCRIPTION_RE = re.compile(r"^description:\s*(.*)$", re.MULTILINE)


def parse_selection(raw):
    """Parse a ``src`` or ``src:dest`` selection string into (src, dest)."""
    if ":" in raw:
        src, dest = raw.split(":", 1)
    else:
        src, dest = raw, posixpath.basename(raw.rstrip("/"))
    src = src.strip("/")
    dest = dest if dest == "." else dest.strip("/")
    if not src:
        sys.exit(f"treegraft: empty source in selection {raw!r}")
    return src, dest


def check_safe(member_name):
    """Abort the run if member_name is absolute or contains a '..' component."""
    if member_name.startswith("/"):
        sys.exit(f"treegraft: refusing archive containing absolute path {member_name!r}")
    if ".." in member_name.split("/"):
        sys.exit(f"treegraft: refusing archive containing '..' path {member_name!r}")


def strip_prefix(path, n):
    """Drop the first n path components. Returns None if path is too shallow."""
    parts = path.split("/")
    if len(parts) <= n:
        return None
    return "/".join(parts[n:])


def map_path(path, is_dir, selections):
    """Return the rewritten output path for path, or None if it's unselected."""
    for src, dest in selections:
        if path == src:
            rel = ""
        elif path.startswith(src + "/"):
            rel = path[len(src) + 1 :]
        else:
            continue
        if dest == ".":
            if rel:
                return rel
            # rel == "" means src itself was selected exactly. For a
            # directory this is just its own root entry, which has nowhere
            # meaningful to go when re-rooted to "." (skip it - its
            # children are still emitted individually). For a file, there's
            # no substructure to place at the root, so fall back to its own
            # basename rather than collapsing to an empty path.
            return "" if is_dir else posixpath.basename(src)
        return posixpath.join(dest, rel) if rel else dest
    return None


def render_frontmatter(name, description, body, extra=None):
    lines = ["---", f"name: {name}", f"description: {description}"]
    for key, value in (extra or {}).items():
        lines.append(f"{key}: {value}")
    lines.append("---")
    return "\n".join(lines) + "\n" + body


TRANSFORMS = {
    "agent-skill": lambda name, desc, body: render_frontmatter(name, desc, body),
    "agent-opencode": lambda name, desc, body: render_frontmatter(
        name, desc, body, extra={"mode": "subagent"}
    ),
}


def apply_transform(data, out_path, transform):
    """Rewrite frontmatter of a selected markdown file. Non-.md or files
    without a recognizable frontmatter block pass through unchanged."""
    if transform is None or not out_path.endswith(".md"):
        return data
    try:
        text = data.decode("utf-8")
    except UnicodeDecodeError:
        return data
    match = FRONTMATTER_RE.match(text)
    if not match:
        return data
    frontmatter, body = match.group(1), match.group(2)
    desc_match = DESCRIPTION_RE.search(frontmatter)
    description = desc_match.group(1).strip() if desc_match else ""
    name = posixpath.splitext(posixpath.basename(out_path))[0]
    return transform(name, description, body).encode("utf-8")


def run(argv):
    parser = argparse.ArgumentParser(
        prog="treegraft",
        description="Filter a tar.gz archive down to selected, re-rooted subtrees.",
    )
    parser.add_argument(
        "--strip-components",
        type=int,
        default=0,
        metavar="N",
        help="strip N leading path components before matching selections "
        "(like tar --strip-components)",
    )
    parser.add_argument(
        "--select",
        action="append",
        default=[],
        dest="selections",
        metavar="SRC[:DEST]",
        help="select subtree SRC, placed at DEST (default: basename of SRC; "
        "'.' means the output root). Repeatable.",
    )
    parser.add_argument(
        "--transform",
        choices=sorted(TRANSFORMS),
        default=None,
        help="rewrite the frontmatter of every selected .md file",
    )
    args = parser.parse_args(argv)

    if not args.selections:
        sys.exit("treegraft: at least one --select is required")

    selections = [parse_selection(s) for s in args.selections]
    transform = TRANSFORMS[args.transform] if args.transform else None

    with tarfile.open(fileobj=sys.stdin.buffer, mode="r|gz") as tin, tarfile.open(
        fileobj=sys.stdout.buffer, mode="w|"
    ) as tout:
        for member in tin:
            check_safe(member.name)

            stripped = strip_prefix(member.name, args.strip_components)
            if not stripped:
                continue

            out_path = map_path(stripped, member.isdir(), selections)
            if not out_path:
                continue

            if member.issym() or member.islnk():
                kind = "symlink" if member.issym() else "hardlink"
                print(f"treegraft: skipping {kind} {member.name!r}", file=sys.stderr)
                continue

            member.name = out_path
            if member.isfile():
                data = tin.extractfile(member).read()
                data = apply_transform(data, out_path, transform)
                member.size = len(data)
                tout.addfile(member, BytesIO(data))
            else:
                tout.addfile(member)


def main():
    run(sys.argv[1:])


if __name__ == "__main__":
    main()
