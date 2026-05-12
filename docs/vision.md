# Vision

This repository is a **machine-readable home for the developer environment**: shell, editors, CLIs, editor integrations, and the glue between them. The long-term bet is simple to state and demanding to execute:

**Coding agents should be able to own the day-to-day operation of that environment.** Humans stay in charge of **what matters**—intent, tradeoffs, taste, and aesthetic judgment—while agents handle much of the **mechanical fidelity** required to keep the environment consistent, up to date, and aligned with what the repo already says is true.

## What “agents own the environment” means here

- **Apply and reconcile**, not “suggest from memory.” Configuration lives in `home/` and related source; Chezmoi (and scripts this repo ships) turn that into a real `~`. Agents are expected to read the tree, run the right commands (`chezmoi diff` / `chezmoi apply`, pinned installs, tests), and leave the machine matching the repo.
- **Skills and agents encode workflows** so the same maintenance steps (installs, updates, PR hygiene, documentation patterns) are repeatable across sessions and machines, not re-derived from chat each time.
- **Automation is first-class**: Renovate, CI, and explicit review paths exist so dependency drift is handled systematically rather than by heroic manual bumps.

## What humans still own

- **Intent**: what this environment is *for* (which stacks, which risk posture, which workflows must never break).
- **Taste and aesthetics**: themes, typography, interaction choices, and any “this feels right” layer that is poorly served by generic defaults.
- **Judgment under ambiguity**: when a change touches security, irreversible data, or cross-cutting policy, humans decide—or explicitly delegate via documented rules (for example Package Manager review for pinned artifacts).

Agents amplify execution; they do not replace ownership of those categories.

## Success looks like

- A new machine (or a fresh clone) can converge toward a known-good state **without oral tradition**: install path, docs, and repo content agree.
- A coding agent can open this repo, follow `AGENTS.md` / `CLAUDE.md`, and **safely** perform scoped maintenance: update manifests, run tests, open or merge PRs where policy allows, and apply Chezmoi—while still routing high-risk edits through the filters you have defined.
- **Humans spend less time being the diff engine** and more time steering direction, reviewing exceptions, and refining the small set of principles that decide hard calls.

## Relationship to the rest of the docs

- **[Core principles](core-principles.md)** — concrete decision filters derived from this vision.
- **Operational detail** — installation, Chezmoi layout, package pins, and Renovate behavior remain in `README.md`, `AGENTS.md`, `docs/renovate.md`, and ADRs under `docs/adrs/`.

The vision is stable; the implementation will evolve. When in doubt, update the principles and ADRs before growing new one-off conventions.
