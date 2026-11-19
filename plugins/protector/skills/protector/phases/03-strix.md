# Phase 3 — Strix: attack a running copy

Static reading misses what only breaks at runtime. Stand up a **local** copy of
the product and attack it like an adversary would — then write down exactly
which attacks worked so a fix can be proven later.

## Authorization gate (required)

Only run this against a target the operator owns: `localhost`, a dev instance,
or a staging host they control. **Confirm the URL before sending any request.**
Never point this phase at a third party's system. If scope is unclear, stop and ask.

## Set up

1. Launch the app with its own run method (dev server, `docker compose`, etc.).
2. Note the base URL and any test credentials the operator provides.
3. Keep traffic on the loopback / owned host.

## Attacks to attempt (own target only)

Drive these with the browser tools or `curl` against the local instance:

- **Auth** — can you reach privileged routes unauthenticated? Swap an object id
  to read another user's data (IDOR)? Forge/replay a session or JWT?
- **Injection at runtime** — probe inputs for SQLi, command injection, SSTI,
  reflected XSS with benign markers (e.g. a harmless `alert`-style payload) —
  enough to *prove* the hole, not to cause damage.
- **SSRF / open redirect** — does a URL parameter fetch or redirect anywhere?
- **Access control on APIs** — method tampering, missing rate limits on
  auth/OTP endpoints, verbose error leakage.
- **File upload** — content-type bypass, path control on stored name.

## Rules of engagement

- Non-destructive only: no data deletion, no DoS, no persistence. Use marker
  payloads that demonstrate the flaw without harm.
- Stop at proof. Once an attack works, record it — don't pivot deeper.

## Record (this is the valuable output)

For each successful attack: the request (redact secrets), the exact repro steps,
the impact, and severity. These repro steps are what you re-run after the fix to
confirm the hole is closed. Failed attempts: note them as "tested, not vulnerable".
