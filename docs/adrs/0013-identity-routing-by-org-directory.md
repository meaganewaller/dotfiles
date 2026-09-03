---
status: "accepted"
date: 2026-09-03
decision-makers: [Meagan Waller]
consulted: []
informed: []
supersedes: []
amends: ["0012-ssh-signing-via-1password.md"]
---

# Git identity and signing key route by org directory, from one list

## Context and Problem Statement

Identity was a single conditional in `dot_config/git/config.tmpl`:

```
{{- if .work_profile }}
[includeIf "gitdir:~/src/github.com/testdouble"]
	path = ~/.config/git/work.gitconfig
{{- end }}
```

with a single prompted `git.work_email` behind it. Three things had gone wrong with that at once.

**It pointed at a retired client.** ADR 0012 had already noted the work key "belonged to a former client and was retired," but the directory pattern kept naming `testdouble`. Client repositories live under `~/src/github.com/Gifthealth`, which that pattern never matched, so every commit in a client repo was authored as `meagan@meaganwaller.com` — the personal address — while appearing, at a glance, entirely normal.

**It had never worked at all.** The pattern also lacked a trailing slash. Git appends `**` to a `gitdir:` pattern only when the pattern ends in `/`; without one, the pattern matches a gitdir at *exactly* that path, and therefore never a repository *inside* the directory. Verified against git 2.50: `gitdir:<dir>` does not match `<dir>/repo/.git`, while `gitdir:<dir>/` does. So the overlay had been inert since the day it was written, for every client, not merely since the client changed. The stale name was the visible half of a bug whose other half nothing had ever exercised. Case was a third trap: the checkout is `Gifthealth`, the GitHub org is `giftHEALTH`, and a natural pattern is lowercase — and plain `gitdir:` compares case-sensitively even on a case-insensitive APFS volume.

**One slot could not hold the requirement.** The actual rule is per-org-directory, and the set of identities differs per machine: a personal laptop commits as personal under `meaganewaller`/`onlooker-community` and as TestDouble under `testdouble`/`testdoublelabs`; a client machine commits as personal and as Gift Health under the client org. A single `work_email` cannot express two work identities, and a `work_profile` boolean is the wrong axis — it already means "is this a work machine" for ssh, mise, fish, and the docker script, which is a different question from "which email in which directory."

Two constraints shaped the answer. `meaganewaller/dotfiles` is **public**, so client email addresses and engagement-scoped key material must not enter its history — which is already why `git.email` is prompted rather than committed. And the 1Password Development vault now serves **two** keys, "My Personal SSH Key" and "GiftHealth GitHub", so ADR 0012's recorded premise — that 1Password serves exactly one signing key, and work commits are therefore signed with the personal one — is no longer true.

## Decision Drivers

- **The failure mode must be structurally impossible, not merely fixed.** ADR 0012's whole argument was that two hand-maintained copies of one value will drift. A directory, an email, a key, and a trust line are four copies of one identity.
- **A guard must fail when the bug returns.** ADR 0012's guard was anchored to files a migration deleted, so the migration disabled the guard and introduced the drift in the same commit. The test asserting `gitdir:~/src/github.com/testdouble` was worse than absent: it *pinned the broken pattern in place*.
- **Nothing client-identifying may be committed.** The repo is public.
- **One source tree, several machines, different identity sets** — with no per-machine branching.
- **`work_profile` must keep its current meaning.** Four other templates depend on it.

## Considered Options

1. **Swap the directory name** — `testdouble` → `gifthealth`, keep everything else.
2. **Add a second work email slot** — `work_email` plus `client_email`.
3. **Identity map: routing committed, values prompted, both consumers rendered from one list.**
4. **Commit the whole identity map**, client emails and keys included.

## Decision Outcome

**Adopt option (3).** An identity is split along the line that the repo's visibility already draws.

| Half | Where it lives | Why |
| --- | --- | --- |
| Org directories | `home/.chezmoidata/git.yaml`, `git.identities` | Public information; the same orgs already appear in `pr.yaml` |
| Email, optional signing key | `~/.config/chezmoi/chezmoi.toml`, `git.identity_local.<key>` | PII and engagement-scoped; prompted, never committed |

Concretely:

1. **`git.identities` is a list of `{key, dirs}`.** `config.tmpl` renders one `includeIf` per directory; `allowed_signers.tmpl` renders one trust line per identity. Both loop the same list, so a directory cannot exist without a trust line, or vice versa.

2. **An identity is active if and only if its prompted email is non-empty.** A blank email removes its `includeIf`, its overlay file, and its trust line together. That single condition is what lets one source tree serve a personal laptop and a client machine with no branching — and it is why the overlay templates render *empty* rather than partial, since chezmoi omits a file whose output is empty.

3. **The trailing slash is appended by the template**, never stored per-entry, so it cannot be forgotten for one client. Patterns are emitted as `gitdir/i:` — case-insensitive — because one org has three spellings in play.

4. **Each identity may name its own signing key**, falling back to the personal key from `git.yaml` when it does not. This is the part of ADR 0012 that no longer holds; `allowed_signers` now maps each email to whichever key it actually signs with.

5. **Overlay bodies come from `home/.chezmoitemplates/git-identity`**, following the same shared-template pattern the Claude settings already use. Git requires one file per distinct identity — a `includeIf` can only name a path — so the per-client file is unavoidable; the duplicated *body* is not.

6. **The prompts are written out literally** in `.chezmoi.toml.tmpl` rather than looped from the data file, because `.chezmoidata` is not in scope there: chezmoi executes that template to *produce* the config that determines `sourceDir`, before any source state is read. This was verified with a probe rather than assumed. It is the one place an identity is named twice, and a test asserts the two agree.

### Consequences

**Good**

- Client commits are authored and signed as the client. Verified end to end: a commit made under the client org directory is authored `meagan.waller@gifthealth.com`, signed with the Gift Health key, and reports `G` against the local trust map.
- Adding a client is a data edit plus two prompts plus a one-line overlay file — and forgetting any of the three fails a test by name.
- The inert-pattern class of bug is gone. The slash is structural, the case-insensitivity is uniform, and both are asserted against every rendered `includeIf` rather than against one literal string.
- `work_profile` keeps its meaning; identity no longer rides on it.

**Bad / accepted**

- An identity is named in three places (data, prompts, overlay filename). The prompt duplication is forced by chezmoi's ordering and cannot be designed away; test `every declared identity has prompts and an overlay template` is the compensating control.
- Client emails and keys now live only in machine-local config, so a new machine cannot reconstruct them from the repo. That is the intended trade for a public repo, but it does mean 1Password, not this tree, is the record of what a client machine needs.
- Machines configured before this change carry a now-dead `git.work_email` and no `identity_local` tables. Templates merge defaults so they still render — a regression test covers exactly that state — but such a machine silently degrades to personal-only until it re-runs `chezmoi init`.

**Neutral**

- `dot_config/git/work.gitconfig.tmpl` is replaced by `identity_<key>.gitconfig.tmpl`. `home/.chezmoiremove` drops the orphan on machines that applied the old layout.
- ADR 0012 is amended, not superseded: 1Password still owns every private key, the personal public half is still recorded once in `git.yaml`, and the drift guard it re-anchored still stands. Only its single-key premise changed.

### Confirmation

- Rendering was checked across three machine shapes — client-only, both identities, neither (CI) — before anything was applied.
- The guards were verified to *fail* when their bugs are reintroduced, which is the property ADR 0012's guard lacked: dropping the trailing slash fails, dropping `/i` fails, and declaring a client without its prompts and overlay fails by name.
- Reverting the defaults merge reproduces `map has no entry for key "email"`, confirming the backward-compatibility test guards a real failure — chezmoi renders with `missingkey=error`, so this would have broken `chezmoi apply` outright on any pre-existing machine.
- Full suite: 220 tests, no failures.
- On the configured machine, `~/.config/git/identity_testdouble.gitconfig` is correctly absent and `work.gitconfig` removed, while the client overlay carries the client email and the client key.

## Rejected Options

- **(1) Swap the directory name** — Rejected. It fixes today and rots at the next engagement, which is the exact shape of the bug being fixed. It also leaves the missing trailing slash in place, so the overlay would have stayed inert and the "fix" would have looked applied while changing nothing.
- **(2) A second email slot** — Rejected. It encodes the current client count into the schema, and says nothing about which directory maps to which address; the routing would still be hardcoded in the template.
- **(4) Commit the whole map** — Rejected. Public repo. Public keys are not secrets and ADR 0012 accepted committing the personal one, but a client's address and engagement-scoped key are a different question, and prompting costs only a prompt while keeping the anti-drift property intact.

## More information

- Amends: [ADR 0012](0012-ssh-signing-via-1password.md) — its single-signing-key premise, and the work-identity half of its trust map.
- Implementation: [`home/.chezmoidata/git.yaml`](../../home/.chezmoidata/git.yaml), [`home/.chezmoi.toml.tmpl`](../../home/.chezmoi.toml.tmpl), [`home/dot_config/git/config.tmpl`](../../home/dot_config/git/config.tmpl), [`home/dot_config/git/allowed_signers.tmpl`](../../home/dot_config/git/allowed_signers.tmpl), [`home/.chezmoitemplates/git-identity`](../../home/.chezmoitemplates/git-identity).
- Guards: [`test/git-identity.bats`](../../test/git-identity.bats).
- Git's `gitdir` matching rules, including the trailing-slash `**` expansion and the `gitdir/i` case-insensitive form: `git help config`, "Conditional includes".

## Revisit when

- A client requires a separate GitHub *account* rather than a separate key on the same one — SSH config and remote rewriting would then need the same per-identity treatment, which this ADR deliberately does not attempt.
- The org-directory convention (`~/src/github.com/<org>`) stops holding, since routing is anchored to it.
- chezmoi makes `.chezmoidata` available while the config template renders, which would remove the one duplicated place an identity is named.
