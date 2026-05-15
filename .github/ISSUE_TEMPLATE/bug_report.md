---
name: Bug report
about: Something installed wrong, chezmoi diverged, a script failed, CI is red, etc.
title: "bug: "
labels: ["bug"]
---

<!--
Before filing, check that the failure isn't already covered by:
- docs/agents/chezmoi.md (edit / diff / apply troubleshooting)
- docs/renovate.md (pinned manifest mismatches)
- AGENTS.md (component inventory and where things live)
-->

## What happened

<!-- One paragraph. What did you expect, what did you get? -->

## Reproduction

```bash
# Exact commands you ran. Include env vars set on the line.
```

If this is an `./install` failure, attach the run directory printed in the
final report (`INSTALL_RUN_DIR=…/dotfiles-install-XXXXXX/steps/*.log`).

## Environment

- OS: <!-- `sw_vers` on macOS, `uname -a` on Linux, container if any -->
- Shell: <!-- zsh / fish / bash; `echo $0` -->
- Repo state: <!-- `git rev-parse HEAD` and `chezmoi status` output, if relevant -->

## Notes

<!-- Anything weird about the host (work profile, IT-managed mise, custom BIN_DIR, …)? -->
