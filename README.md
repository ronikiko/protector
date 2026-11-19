# Protector

**Claude as your resident red-teamer.** One flow turns Claude into the hacker
against your *own* app, site, or game: it breaks in, proves each weakness, and
fixes it before real attackers arrive.

This repo is a **Claude Code plugin** (distributed via its own marketplace).

## Install

One step (Claude Code 2.1.275+):

```
/plugin install protector --marketplace ronikiko/protector
```

Or the two-step form:

```
/plugin marketplace add ronikiko/protector
/plugin install protector@protector-marketplace
```

(Shell equivalents: `claude plugin marketplace add ronikiko/protector` then
`claude plugin install protector@protector-marketplace`.)

To try it without installing, from a clone:

```bash
claude --plugin-dir ./plugins/protector     # load for one session
claude plugin validate .                     # validate manifest + marketplace + skill
```

## Use

Open any project in Claude Code and either ask in plain language
("protect my app", "red-team this", "security-audit this repo") or run it
explicitly:

```
/protector:protector
```

Claude then runs the six phases in order against **your own** code and a local
copy of your app, writing a ranked report to `security/protector-report.md`.

## The flow

| # | Phase | Mapped tool | What it does |
|---|-------|-------------|--------------|
| 1 | Add-on vetting   | SkillSpector  | Checks Claude Code add-ons before install for hidden commands & prompt injection |
| 2 | Code audit       | security-audit | Reads your code for bypassable defenses; a second pass re-verifies each finding |
| 3 | Live attack      | Strix         | Attacks a running copy; records which attacks worked + repro steps |
| 4 | Secret hunt      | TruffleHog    | Scans full git history for secrets; checks which are still live |
| 5 | Dependency scan  | Trivy         | Finds vulnerable deps & misconfigs; names the exact fixed version |
| 6 | Anti-clone       | BLA           | Hardens shipped artifacts against reverse-engineering / cloning |

Every finding is **proven**, then **fixed**, then the check is **re-run** to
confirm it's closed. Anything that can't run is logged as *skipped*, never
faked green.

## Scope & ethics

Protector runs **only against assets you own or are authorized to test** — your
own repo and your own local/staging instance. Phase 3 confirms the target is
yours before sending a request; it's non-destructive (marker payloads,
stop-at-proof). Secrets are reported **redacted**; the fix for a leaked secret
is rotation, never reuse. It is not a tool for probing anyone else's systems.

## Requirements

- `docker` (runs Trivy & TruffleHog via pinned images — no native install)
- Your project's own way to run the app locally (for Phase 3)

## Layout

```
.claude-plugin/marketplace.json     ← marketplace manifest
plugins/protector/
  .claude-plugin/plugin.json        ← plugin manifest
  skills/protector/SKILL.md         ← the orchestrator + phase playbooks
  scripts/run-tools.sh              ← pinned Docker runners for Trivy + TruffleHog
```

## License

MIT
