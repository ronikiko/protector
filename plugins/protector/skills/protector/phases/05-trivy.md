# Phase 5 — Trivy: vulnerable deps & misconfigs

Your product inherits the vulnerabilities of everything it pulls in. Trivy scans
dependencies, container images, and IaC/config, and — crucially — tells you the
**exact fixed version** to move to.

## Run (via Docker — runner at ${CLAUDE_PLUGIN_ROOT}/scripts/run-tools.sh)

```bash
# Filesystem scan: lockfiles + misconfig, HIGH/CRITICAL, only where a fix exists
bash "${CLAUDE_PLUGIN_ROOT}/scripts/run-tools.sh" trivy-fs

# If the product ships a container image:
bash "${CLAUDE_PLUGIN_ROOT}/scripts/run-tools.sh" trivy-image <image:tag>
```

Covers: `package-lock.json`/`yarn.lock`, `requirements.txt`/`poetry.lock`,
`go.sum`, `Cargo.lock`, Dockerfiles, k8s/Terraform misconfigs.

## Triage

- Sort by severity, then by **"fix available"** — those are free wins.
- For each: package, installed version, CVE, severity, and **fixed version**.
- Prefer scanning with `--ignore-unfixed` first so you act on what's actionable.

## Fix

- Bump each fixable dependency to the fixed version in the lockfile/manifest.
- Re-install and **re-run the scan** to confirm the CVE is gone and nothing broke.
- For misconfigs (e.g. container running as root, world-readable secrets),
  apply the recommended setting.
- No-fix-available CVEs: record with mitigation (network isolation, input
  constraints) and track them as open.

## Record

Table of: package → installed → fixed → CVE → severity → status
(`updated` / `open-no-fix`).
