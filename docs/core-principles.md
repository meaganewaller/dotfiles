# Core principles

These principles are **decision filters**: if a change, automation, or skill conflicts with one of them, pause and fix the design—or document a deliberate exception in an ADR.

They implement the vision in **[Vision](vision.md)**.

---

### 1. The repository is the source of truth

The canonical developer environment is what is **committed here** (`home/`, scripts, manifests, tests—not a remembered sequence of manual edits on one laptop). Agents and humans both defer to the tree; “it works on my machine” without a repo change is a bug in process, not a private optimization.

**Filter:** If it matters for reproducibility, it belongs in source (or in explicitly documented private encrypted state), not only in chat.

---

### 2. Agents execute; humans retain intent and veto

Agents may run installs, apply templates, run tests, and prepare or merge changes **within the boundaries** set by docs, skills, and review rules. Humans retain **intent** (what we are optimizing for) and **veto** on ambiguous or high-impact moves (security, data loss, policy).

**Filter:** Prefer encoding “what may be done unsupervised” in skills, CI, and Renovate rules; reserve the rest for explicit human approval.

---

### 3. Taste and aesthetics are human-gated

Layout, theme, typography, motion, and “does this feel good to use” are **human responsibilities**. Agents can scaffold, refactor, or wire options—but they should not silently redefine aesthetic defaults without an explicit human decision captured in the repo.

**Filter:** Cosmetic or UX-default changes should trace to a human-authored preference (commit message, issue, or small spec), not only to model improvisation.

---

### 4. Reproducibility beats clever one-offs

Pins, digests, version manifests, and Renovate-aware layouts exist so upgrades are **reviewable and repeatable**. Favor boring, inspectable updates over “latest everywhere” unless the vision explicitly calls for bleeding edge—and then still encode it.

**Filter:** If a dependency cannot be explained to Renovate (or a documented exception), it is probably the wrong shape for this repo.

---

### 5. Security and least privilege are non-negotiable

Tool allowlists in skills, signature verification defaults, private material via Chezmoi’s `private_` patterns, and Package Manager review for sensitive surfaces are part of the **same** vision: agents are powerful, so their blast radius must be bounded by design.

**Filter:** Widen agent powers only with a proportional guardrail (narrow tools, tests, ADR, or human review path).

---

### 6. Progressive disclosure over giant manuals

Humans and agents should find **just enough** context at the entry point (`README`, `AGENTS.md`), with deeper rules in `docs/`, skills, and ADRs. Duplicating the same policy in five places is a drift hazard.

**Filter:** Add a link before adding a paragraph; split long policy into a focused doc and link it.

---

### 7. Same rules for solo and agent maintenance

Anything painful for an agent to do safely is probably painful for **you** in six months. Skills and scripts should make the **happy path obvious** and the dangerous path gated—not “agents only” hacks that humans never run.

**Filter:** If only an agent could safely perform a step, add automation or docs until a human could follow it too.

---

### 8. When principles collide, document the trade

Real work involves tension (speed vs. pin discipline, automation vs. review). **ADRs** exist so a resolved conflict becomes a durable precedent instead of tribal knowledge.

**Filter:** If you break or bend a principle, write a short ADR: context, decision, consequences—then move on.

---

## Using this list day to day

- **Shipping a feature or skill:** Run through principles 1–3 and 5 (truth, intent/taste, security).
- **Dependency or infra churn:** Emphasize 4 and 5 (reproducibility, security).
- **Docs or onboarding noise:** Use 6 and 7 (disclosure, shared workflows).
- **Anything weird or one-off:** Default to 8 (ADR).

These filters should evolve slowly. Propose edits in the same way as any other architectural change: small diffs, clear rationale, and a path for agents and humans to stay aligned.
