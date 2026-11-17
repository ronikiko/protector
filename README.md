# protector

**One prompt → Fable 5.2 becomes your red-teamer.** It breaks into your own
app, site, or game, proves each weakness, and fixes it before real AI hackers
arrive.

Run it:

```
/protector
```

## The flow

Six phases, in order, each mapped to a best-in-class open security tool:

| # | Phase | Mapped tool | What it does |
|---|-------|-------------|--------------|
| 1 | Add-on vetting   | SkillSpector  | Checks Claude Code add-ons before install for hidden commands & prompt injection |
| 2 | Code audit       | security-audit | Reads your code for bypassable defenses; a second agent re-verifies each finding |
| 3 | Live attack      | Strix         | Attacks a running copy; records which attacks worked + repro steps |
| 4 | Secret hunt      | TruffleHog    | Scans full git history for secrets; checks which are still live |
| 5 | Dependency scan  | Trivy         | Finds vulnerable deps & misconfigs; names the exact fixed version |
| 6 | Anti-clone       | BLA           | Hardens shipped artifacts against reverse-engineering / cloning |

The skill, phase playbooks, and pinned tool runner live under `.claude/`.

## Scope & ethics

Protector runs **only against assets you own or are authorized to test** — your
own repo and your own local/staging instance. Phase 3 confirms the target is
yours before sending a request. Findings are reported with secrets **redacted**;
the fix for a leaked secret is rotation, never reuse. It is not a tool for
probing anyone else's systems.

## Requirements

- `docker` (runs Trivy & TruffleHog via pinned images — no native install)
- Your project's own way to run the app locally (for Phase 3)
