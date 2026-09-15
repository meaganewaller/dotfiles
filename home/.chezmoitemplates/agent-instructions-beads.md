## Beads

Beads is durable only in **my own repositories** — those under:
{{ range .beads.personal_dirs }}- `{{ . }}`
{{ end }}
(`home/.chezmoidata/beads.yaml` is the source of truth). There, commit
`.beads/`'s `issues.jsonl`, `config.yaml`, `metadata.json`, `.gitignore`, and
`README.md`; never `interactions.jsonl` or `hooks/`. Durability comes from
`bd dolt push`, not the JSONL export — bd is explicit that the export is not a
backup.

In any repository that is **not mine** — client work, or anything cloned to
contribute to — run `bd init --stealth`. Then finish the local-only block in
`{{ .chezmoi.workingTree }}/docs/beads.md`, which restores the machine-wide bd
setting that `--stealth` changes and ends with the fail-closed no-push check.
Nothing beads-related gets committed; there is no `sync.remote` and no Dolt
remote; and `refs/dolt/data` is never pushed to a remote that isn't mine.

Full policy, including the adoption order for each mode: `{{ .chezmoi.workingTree }}/docs/beads.md`.
