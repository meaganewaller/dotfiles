---
status: "accepted"
date: 2026-08-05
decision-makers: [Meagan Waller]
consulted: []
informed: []
supersedes: []
---

# SSH commit signing: 1Password owns the key, the repo records the public half once

> **Amended by [ADR 0013](0013-identity-routing-by-org-directory.md) (2026-09-03).** The
> premise below that "1Password serves one signing key, so work commits are signed with
> it too" no longer holds: the Development vault also holds a client key, and identities
> now route per org directory, each trusted against the key it actually signs with.
> Everything else here — 1Password owning the private half, the public half recorded once
> in `.chezmoidata/git.yaml`, `allowedSignersFile`, and the re-anchored drift guard —
> still stands.

## Context and Problem Statement

Commit signing in this repo is SSH-based (`gpg.format = ssh`) and backed by 1Password: `op-ssh-sign` asks the 1Password SSH agent to sign, and the agent's vault is configured in `home/dot_config/private_1Password/private_ssh/private_agent.toml`. The private key never touches disk. That part worked.

Verification did not. Two independent defects, both silent:

1. **`gpg.ssh.allowedSignersFile` was never configured.** `home/dot_config/git/allowed_signers.tmpl` rendered a trust map and chezmoi deployed it to `~/.config/git/allowed_signers`, but nothing pointed git at it. `git log --show-signature` failed outright with *"gpg.ssh.allowedSignersFile needs to be configured and exist for ssh signature verification"*, and `%G?` reported `N` for every commit — indistinguishable, at a glance, from not signing at all.

2. **The trusted key was not the signing key.** `config.tmpl` signed with `SHA256:TeXrUZ1G…` (the key 1Password's agent actually holds). `allowed_signers.tmpl` trusted `SHA256:Mkbx5xRY…`. Even with (1) fixed, verification would have failed.

The origin of (2) is instructive. Commit `0b2feb5` moved the keys into 1Password: it changed `config.tmpl`'s `signingkey` from `~/.ssh/id_ed25519_personal.pub` to a literal pubkey and deleted `home/private_dot_ssh/id_ed25519{,_personal}.pub`. It did **not** update `allowed_signers.tmpl`, which kept its own separately-pasted literal — the content of the file that had just been deleted.

There *was* a guard against exactly this. `test/git-identity.bats` carried two tests whose comment read:

> These two guard against the hardcoded key material in allowed_signers.tmpl silently drifting from the actual checked-in public keys (e.g. a key rotation that updates one file but not the other), which would make git quietly stop verifying — or start "verifying" against the wrong key.

They compared `allowed_signers.tmpl` against the `.pub` files. Deleting those files did not make the guard fail loudly in a way anyone acted on — it made it error on a missing path, and the failure sat in the suite while the drift it described happened. **The guard was anchored to an artifact the migration removed, so the migration disabled the guard and introduced the bug in the same commit.**

The decision: where should the signing key live so that "sign with X" and "trust X" cannot disagree, given 1Password owns the key material?

## Decision Drivers

- **1Password is authoritative for key material.** The private key MUST stay in the vault, served by the agent. Nothing in this repo should hold or need it.
- **One source for the public half.** The two files that need the pubkey MUST derive it from one place; two hand-maintained literals is the defect above.
- **No 1Password auth at apply time.** `chezmoi apply` had just been freed of its only `onepasswordRead` call (removing aichat), which had been aborting applies with `authorization timeout`. Re-introducing an apply-time vault read to fetch a *public* key would trade a real reliability property for nothing.
- **Verification must actually work.** Signing without verification is a silent half-feature; the config MUST wire `allowedSignersFile`.
- **The guard must be anchored to something that cannot be deleted out from under it.**

## Considered Options

1. **Status quo** — two hand-pasted literals, no `allowedSignersFile`.
2. **Fix the values in place** — correct `allowed_signers.tmpl`, add `allowedSignersFile`, keep two literals.
3. **Read the pubkey from 1Password at apply time** via `onepasswordRead`.
4. **Derive the pubkey from the running agent** at apply time via `output "ssh-add" "-L"`.
5. **Record the public key once in `.chezmoidata`** and render both files from it.

## Decision Outcome

**Adopt option (5).** `home/.chezmoidata/git.yaml` holds `git.signing_key` (and `git.allowed_signers_file`); `config.tmpl` and `allowed_signers.tmpl` both render from it.

The division of ownership:

| Concern | Owner |
| --- | --- |
| Private key material | 1Password vault; never on disk, never in this repo |
| Serving the key to git | 1Password SSH agent + `op-ssh-sign`, vault selected in `dot_config/1Password/ssh/agent.toml` |
| The public key's value | `home/.chezmoidata/git.yaml`, one entry |
| `signingkey`, `allowedSignersFile` | `dot_config/git/config.tmpl`, rendered from that entry |
| The trust map | `dot_config/git/allowed_signers.tmpl`, rendered from that entry |

Concretely:

1. **`git.signing_key` in `.chezmoidata/git.yaml`** is the single source. A public key is not a secret, so committing it costs nothing — and unlike an `onepasswordRead`, it needs no vault auth at apply time.

2. **`gpg.ssh.allowedSignersFile` is now set**, from `git.allowed_signers_file`, naming the path `allowed_signers.tmpl` deploys to.

3. **The retired work key is gone.** It belonged to a former client. 1Password serves one signing key, so on a work profile the work email maps to that same key rather than a second one.

4. **`home/.chezmoidata/authorized_keys.yaml` is deleted.** Its only consumer, `private_dot_ssh/authorized_keys.tmpl`, was removed in `0b2feb5`; it had been orphaned data holding two stale keys ever since.

5. **The drift guard is re-anchored.** It now renders *both* templates and asserts the trusted key equals the signing key. It cannot be disabled by deleting a file, because it depends only on the two templates whose agreement it checks. A second test asserts `allowedSignersFile` is set and names the deployed path. Both were verified to fail when the original bug is reintroduced.

### Consequences

- **Positive**: `git log --show-signature` reports `G` (verified) instead of erroring. Confirmed against existing history — those commits were always correctly signed; only verification was broken.
- **Positive**: The class of bug is gone, not just the instance. Two files can no longer hold different keys, because there is only one value.
- **Positive**: Rotation is a one-line edit (`ssh-add -L` → `git.yaml`) plus re-registering on GitHub, instead of two literals to keep in sync.
- **Positive**: No 1Password auth needed at apply time, preserving the reliability win from removing aichat's `onepasswordRead`.
- **Negative / accepted**: The public key is committed. This is standard — public keys are published to GitHub by design — but it does mean the repo names the key, so rotation is a visible commit.
- **Negative / accepted**: `.chezmoidata/git.yaml` merges into the same `.git` namespace as `[data.git]` from `chezmoi.toml` (verified: they merge rather than clobber). The key reads as `.git.signing_key` alongside `.git.email`, which is the intent, but it does mean the `git` data namespace now has two sources.

### Confirmation

- `git log --show-signature` reports `G` / "Good \"git\" signature … SHA256:TeXrUZ1G…" for existing commits; previously it errored and `%G?` was `N`.
- `git config --get gpg.ssh.allowedSignersFile` returns `~/.config/git/allowed_signers`, and that file exists.
- The rendered `signingkey` equals the agent's `ssh-add -L` output.
- Reintroducing a hardcoded stale key into `allowed_signers.tmpl` makes `test/git-identity.bats` fail with "trusted key does not match signingkey" (verified, then reverted).
- `grep -rn authorized_keys home/ bin/ test/ docs/` is clean.

## Rejected Options

- **(1) Status quo** — Rejected; signing verification was broken two ways.
- **(2) Fix the values in place** — Rejected. Corrects the instance, leaves the mechanism. Two hand-maintained literals is precisely what failed, and it failed silently for months.
- **(3) `onepasswordRead` at apply time** — Rejected. It would re-add a vault-auth dependency to `chezmoi apply` — the exact failure mode (`authorization timeout` aborting the whole apply) that removing aichat had just eliminated — to fetch a value that is not secret.
- **(4) Derive from the running agent** — Rejected. Requires an unlocked 1Password agent at apply time, fails in CI and on a fresh machine before 1Password is signed in, and makes the rendered config depend on ambient state rather than the tree.

## More information

- Related: the `test/git-identity.bats` guard that this ADR re-anchors, and the bats caveat that let its siblings under-assert — bats only checks a test's **last** command, so non-final bare `[[ ... ]]` assertions are silently ignored. `test_helper.bash` now ships a `fail()` helper for the `[[ ... ]] || fail "..."` idiom.
- 1Password agent vault config: [`home/dot_config/private_1Password/private_ssh/private_agent.toml`](../../home/dot_config/private_1Password/private_ssh/private_agent.toml).
- Implementation: [`home/.chezmoidata/git.yaml`](../../home/.chezmoidata/git.yaml), [`home/dot_config/git/config.tmpl`](../../home/dot_config/git/config.tmpl), [`home/dot_config/git/allowed_signers.tmpl`](../../home/dot_config/git/allowed_signers.tmpl).
