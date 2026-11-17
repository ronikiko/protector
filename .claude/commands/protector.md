---
description: Run the 6-phase Protector security flow against your own product
---

Invoke the `protector` skill and run the full flow end-to-end against **this
repository and the operator's own local instance only**:

0. Plan & inventory → seed `security/protector-report.md`
1. SkillSpector — vet Claude Code add-ons before they run
2. Code audit — static review + adversarial verifier pass
3. Strix — attack a running local copy (confirm the target is owned first)
4. TruffleHog — secrets across full git history, live-check
5. Trivy — vulnerable deps & misconfigs, with fixed versions
6. BLA — harden shipped artifacts against reverse-engineering

Prove each finding, fix it, re-run the check to confirm it's closed, and write
the ranked summary + verdict to `security/protector-report.md`. Log any phase
that can't run as skipped — never as passed.

$ARGUMENTS
