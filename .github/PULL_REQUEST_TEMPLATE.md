<!--
Thanks for opening a PR. Quick orientation:

- Repo philosophy: agents handle mechanical maintenance; humans steer intent.
  See docs/vision.md and docs/core-principles.md.
- Most edits live under `home/` and ride chezmoi (see docs/agents/chezmoi.md).
- Pins / Renovate-sensitive manifests go through the Package Manager subagent,
  not ad-hoc bumps (see docs/renovate.md).
-->

## Summary

<!-- 1–3 sentences. What changed and WHY. The diff shows the WHAT. -->

## Scope

<!-- Check every area this PR touches. -->

- [ ] Chezmoi source (`home/`)
- [ ] Docs (`docs/`, `README.md`, `AGENTS.md`)
- [ ] CI / GitHub Actions (`.github/workflows/`)
- [ ] Pinned manifests / Renovate (mise, chezmoi externals, brew bundle, GHA digests)
- [ ] Claude Code config (`home/dot_claude/` — skills, agents, hooks)
- [ ] Repo tooling (`bin/`, `test/`, `hk.pkl`, `mise.toml`)
- [ ] Other: <!-- describe -->

## Verification

<!-- Tick what you actually ran. Don't check what you didn't. -->

- [ ] `hk check` clean
- [ ] `./bin/test` green (set `CI=1 GITHUB_ACTIONS=1` if your change touches a chezmoi template that branches on CI)
- [ ] `chezmoi diff` previewed and only intended paths changed
- [ ] Template renders verified with `chezmoi execute-template --file <path>` (if you touched a `.tmpl`)
- [ ] N/A — docs/config-only change

## Linked work

<!-- Closes #N, refs #N, ADR drafted at docs/adrs/NNNN-…, or "none". -->
