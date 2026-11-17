# Phase 4 — TruffleHog: secrets across git history

A secret deleted from the current tree still lives in history and may still be
valid. Scan the **whole git history**, then check which findings are live.

## Run (via Docker — see scripts/run-tools.sh)

```bash
# Full history scan of this repo, verified secrets surfaced
scripts/run-tools.sh trufflehog
```

This scans every commit, not just the working tree. TruffleHog's verification
checks whether a credential still authenticates (safe read-only probe to the
provider's own API).

## Also check

- `.env`, config files, CI configs, and any committed `*.pem`/`*.key`.
- Build artifacts or fixtures that may embed tokens.

## Triage

- **Verified live** → **Critical.** The only real fix is **rotation** at the
  provider, then purge from history (`git filter-repo` / BFG) and force-update.
  Removing the line in a new commit does **not** help — it's still in history.
- **Unverified / expired** → still report (Medium): rotate anyway if it was ever real.

## Record (redacted)

Report each secret as: type, where (commit/file), live-status, and remediation.
Show only first/last 4 characters — **never** paste a full secret into the report
or anywhere else. Do not exfiltrate or reuse any secret found.
