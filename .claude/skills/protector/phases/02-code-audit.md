# Phase 2 — Code audit (with a verifier pass)

Read the source for places a defense can be bypassed. Then a **second pass**
re-checks every finding adversarially before it's allowed into the report. This
two-agent pattern kills false positives — the thing that makes audits noise.

## Pass A — hunt

Walk the attack surface from Phase 0. Look for:

- **Injection** — SQL/NoSQL built by string concat; `os.system`/`exec`/`eval`
  on user input; template injection; command args from requests.
- **AuthN/AuthZ** — missing checks on privileged routes; IDOR (object id from
  the request with no ownership check); JWT with `alg:none` or no verify.
- **Secrets & crypto** — hardcoded keys; weak hashing (`md5`/`sha1` for
  passwords); `Math.random` for tokens; disabled TLS verification.
- **Input handling** — path traversal, SSRF (fetch to a user-supplied URL),
  unsafe deserialization (`pickle`, `yaml.load`, `Marshal`), XXE.
- **Web** — reflected/stored XSS, missing CSRF protection, permissive CORS
  (`*` with credentials), open redirect.
- **Config** — debug mode on, verbose errors to users, default creds.

For each candidate: file, line, the data path from untrusted input to sink.

## Pass B — verify (adversarial)

For every Pass-A candidate, try to **disprove** it:

- Is the input actually attacker-controlled, or already validated/escaped
  upstream? Is the sink real, or a safe wrapper?
- Construct the concrete input that would trigger it. If you can't, mark the
  finding **unverified** (keep it, flagged) rather than **confirmed**.

Only `confirmed` findings get a severity; `unverified` are listed separately.

## Fix

For each confirmed finding, apply the minimal correct fix (parameterized query,
authz check, safe deserializer, escaping, etc.), then re-read to confirm the
data path is closed. Record before/after in the report.
