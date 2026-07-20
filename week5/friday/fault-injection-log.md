# Fault Injection Log — KijaniKiosk Payments Pipeline

| Stage | Fault Introduced | Observed Behaviour | Design Rationale |
|---|---|---|---|
| Lint | Syntax error added to `src/index.js` | Lint failed immediately; Build, Verify, Archive, and Publish all skipped | Fail-fast avoids spending build time on code that doesn't meet basic standards |
| Build | Import of a nonexistent module | Lint passed; Build failed; Verify, Archive, and Publish skipped | There's no value in testing or publishing an artifact that doesn't compile |
| Verify — Test | Incorrect assertion in a unit test | Test branch failed; Security Audit branch ran to completion independently; Archive and Publish skipped | Parallel branches are isolated so one failure doesn't mask or block the other's result |
| Verify — Security Audit | Dependency downgraded to a version with a known vulnerability | Security Audit branch failed; Test branch ran to completion independently; Archive and Publish skipped | Correctness and security are checked in parallel, but both must pass before release proceeds |
| Publish | Nexus credential ID pointed to a non-existent Jenkins credential | Lint, Build, Verify, and Archive all passed; Publish failed at the authentication step | Credential validation is the final gate — the artifact exists but is never released to an untrusted or unverified destination |

All faults listed above were reverted individually, with the pipeline
confirmed back to a green (SUCCESS) state after each fault before the next
one was introduced.