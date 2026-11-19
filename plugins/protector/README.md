# Protector (plugin)

Claude as your resident red-teamer — a six-phase flow that attacks your own
product and fixes what it finds. See the [repo README](../../README.md) for
full usage.

Install:

```
/plugin install protector --marketplace ronikiko/protector
```

- **Skill:** `skills/protector/SKILL.md` — the orchestrator and the six phase
  playbooks under `phases/`. Auto-activates when you ask to protect / harden /
  audit / red-team your product, or run `/protector:protector`.
- **Runner:** `scripts/run-tools.sh` — pinned, Docker-based wrappers for Trivy
  and TruffleHog, invoked by the phases as
  `"${CLAUDE_PLUGIN_ROOT}/scripts/run-tools.sh"`.

Phases: 1) SkillSpector (add-on vetting) · 2) security-audit (code + verifier
pass) · 3) Strix (live attack on a running copy) · 4) TruffleHog (git-history
secrets) · 5) Trivy (dependencies & misconfig) · 6) BLA (anti-reverse-engineering).

Runs only against assets you own; Phase 3 confirms the target is yours first.
