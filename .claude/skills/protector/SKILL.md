---
name: protector
description: >-
  One command turns Fable into your own red-teamer: it audits the add-ons you
  install, breaks into a running copy of your app/site/game, hunts leaked
  secrets across git history, flags vulnerable dependencies, and hardens the
  build against cloning — then fixes what it finds. Use when the user asks to
  "protect", "harden", "security-audit", "red-team", or "pen-test" their own
  product, or runs /protector.
---

# Protector — Fable 5.2 as your resident red-teamer

**Mental model:** don't wait for an AI hacker to find the hole. *Become* the
hacker against your own product first, prove each weakness with a repeatable
attack, then close it. Every finding must be **proven**, not guessed, and every
fix must be **verified** before the phase is marked green.

This flow runs **only against assets the operator owns or is explicitly
authorized to test** — their own repo, their own running instance. It is not a
tool for probing third-party systems. Before Phase 3 (the live attack), confirm
the target URL belongs to the user. If a target looks like someone else's
property, stop and ask.

## The six phases

Run them in order. Each phase has its own file under `phases/`; open it, follow
it, and record findings in the audit log before moving on. A phase that can't
run (tool missing, no target) is **skipped and logged as skipped** — never
reported as passed.

| # | Phase file | Maps to | What it does |
|---|------------|---------|--------------|
| 0 | `phases/00-plan.md`         | —                       | Inventory the product, pick targets, write the audit log skeleton |
| 1 | `phases/01-skillspector.md` | SkillSpector            | Vet Claude Code add-ons/skills/MCP **before** install for hidden commands & prompt injection |
| 2 | `phases/02-code-audit.md`   | Cloudflare security-audit | Static audit of the source; a second agent re-verifies each finding |
| 3 | `phases/03-strix.md`        | Strix                   | Attack a **running** copy; record which attacks worked and the repro steps |
| 4 | `phases/04-trufflehog.md`   | TruffleHog              | Scan full git history for secrets; check which are still live |
| 5 | `phases/05-trivy.md`        | Trivy                   | Find vulnerable deps & misconfigs; report the exact fixed version |
| 6 | `phases/06-bla.md`          | BLA                     | Harden shipped artifacts against reverse-engineering / cloning |

## How to run

1. Create the audit log at `security/protector-report.md` (Phase 0 seeds it).
2. Work phases 1→6. After each, append a section: findings, severity, proof,
   and fix status (`fixed` / `open` / `skipped`).
3. For every **fix** you apply, re-run the phase's check to confirm it's closed.
4. End with the summary table in the report and a short plain-language verdict.

## Severity rules

- **Critical** — live secret, RCE, auth bypass, or a working exploit from Phase 3.
- **High** — exploitable-with-effort vuln, known-CVE dep with public exploit.
- **Medium** — misconfig, outdated dep without known exploit, info leak.
- **Low** — hardening gaps, defense-in-depth.

Rank the final report most-severe first. Never downgrade a finding to make a
phase look clean. If you couldn't prove it, label it **unverified**, don't drop it.

## Tooling notes (this environment)

- `trivy` and `trufflehog` aren't installed natively but run via Docker — see
  `scripts/run-tools.sh` for pinned, checksummed invocations.
- Phase 3 needs the app actually running; use the project's own run method.
- Never exfiltrate anything you find. Secrets go in the report **redacted**
  (first/last 4 chars only) and the real remediation is rotation.
