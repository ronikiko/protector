# Phase 6 — BLA: harden against reverse-engineering & cloning

The first five phases close holes an attacker exploits. This one raises the cost
of someone **reverse-engineering or cloning** your shipped product. These are
defense-in-depth measures for artifacts **you distribute** — not a substitute
for real server-side security (never trust the client).

## What to harden (pick what fits the product)

**Web / JS apps**
- Minify + bundle for production; strip source maps from public builds (or keep
  them private/authenticated).
- Remove `console.*` debug output and dead developer endpoints.
- Keep real logic server-side. Anything shipped to the browser is readable —
  don't put secrets, licensing checks, or trust decisions there.

**Native / desktop / game builds**
- Strip symbols from release binaries; disable verbose stack traces.
- Consider integrity checks on critical assets; keep validation server-side.

**APIs / licensing**
- Validate entitlements on the server, signed and rate-limited — not in the
  client where a clone can patch it out.

## What NOT to do

- Don't rely on obfuscation as your only protection — it slows, never stops.
- Don't obfuscate in a way that breaks error reporting for real users; keep a
  private symbol/source-map store for your own debugging.

## Record

List what you hardened, what's deliberately left (and why), and the residual
risk: "a determined reverse-engineer can still X; the real control for X is
server-side Y." Then write the final summary table and plain-language verdict in
`security/protector-report.md`.
