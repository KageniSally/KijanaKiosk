# KijaniKiosk Payments — CI Pipeline

Production Jenkins pipeline for the `kijanikiosk-payments` service, built as
part of Week 5 (Friday Independent Project).

## What this pipeline does

1. **Lint** — enforces code style before anything else runs (fail-fast).
2. **Build** — compiles the application.
3. **Verify** (parallel) — runs unit tests and a dependency security audit
   at the same time, independently.
4. **Archive** — packages and fingerprints the build output.
5. **Publish** — versions the package as `<semver>-<git-sha>` and publishes
   it to the team's Nexus npm registry.

## Requirements

- Docker (agent runs `node:18.20.4-alpine`, pinned)
- A reachable Nexus instance at the URL configured in `NEXUS_URL`
- A Jenkins credential named `nexus-publisher-creds` (username/password type)
  scoped to the Nexus repository

## Repository layout

| Path | Purpose |
|---|---|
| `Jenkinsfile` | Pipeline definition |
| `src/` | Application source |
| `nexus screenshots/` | Evidence of published artifact versions |
| `ci-pipeline-board-document.md` | Non-technical pipeline explanation for stakeholders |
| `fault-injection-log.md` | Record of deliberate stage failures and pipeline response |
| `credential-audit.txt` | Confirmation no credentials leak into code, history, or logs |
| `green-pipeline-run.txt` | Console log of a successful end-to-end run |

## Local development

```bash
npm ci
npm run lint
npm run build
npm test
```

## Manual publish (for debugging only)

Never commit a populated `.npmrc`. See `credential-audit.txt` for the checks
that confirm this hasn't happened.