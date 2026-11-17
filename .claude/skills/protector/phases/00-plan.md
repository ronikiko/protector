# Phase 0 — Plan & inventory

Goal: know what you're protecting before you attack it.

## Steps

1. **Detect the stack.** Look for `package.json`, `requirements.txt`,
   `pyproject.toml`, `go.mod`, `Cargo.toml`, `Dockerfile`, `pom.xml`, etc.
   Note language(s), framework, and how the app is run/served.
2. **Map the attack surface.** List: HTTP routes/handlers, auth entry points,
   file uploads, deserialization, template rendering, subprocess/`eval` calls,
   outbound network calls, and anything reading untrusted input.
3. **Identify targets.**
   - Static target: the repo tree.
   - Dynamic target: the local URL the app serves on (for Phase 3). If none can
     run, mark Phase 3 as skipped.
   - Confirm every dynamic target is owned by the operator.
4. **Seed the report.** Create `security/protector-report.md`:

```markdown
# Protector audit — <product> — <date>

Operator-authorized security audit of own product. Scope: <repo + local target>.

## Summary
| Phase | Status | Critical | High | Medium | Low |
|-------|--------|----------|------|--------|-----|
| 1 SkillSpector | pending | - | - | - | - |
| 2 Code audit   | pending | - | - | - | - |
| 3 Strix        | pending | - | - | - | - |
| 4 TruffleHog   | pending | - | - | - | - |
| 5 Trivy        | pending | - | - | - | - |
| 6 BLA          | pending | - | - | - | - |

## Findings
<!-- appended per phase, most severe first -->
```

Then proceed to Phase 1.
