# Post Incident Review

## 1. Incident Summary

During an investor demonstration, the deployment pipeline targeted the wrong environment, causing staging to become unavailable for 48 seconds. The issue was resolved after the deployment was redirected to the correct environment.

---

## 2. Timeline

| Time | Event |
|------|-------|
| 09:00 (Estimated) | Demonstration began |
| 09:05 (Estimated) | Deployment started |
| 09:06 (Estimated) | Wrong environment targeted |
| 09:06:30 (Estimated) | Error detected |
| 09:06:48 (Estimated) | Service restored |
| 09:07 (Estimated) | Investigation started |

---

## 3. Root Cause

Why?

The deployment targeted the wrong environment.

Why?

The deployment script allowed the wrong environment to be selected.

Why?

There was no validation before deployment.

Why?

The pipeline trusted manual configuration.

Why?

Automatic environment verification had not been implemented.

**Root Cause**

The deployment process lacked automatic validation of the target environment before deployment.

---

## 4. Contributing Factors

- Manual deployment configuration
- Missing validation checks
- No automated confirmation before switching traffic
- Limited deployment safeguards

---

## 5. What Went Well

- The issue was identified quickly.
- The rollback process restored service.
- Team communication remained effective.

---

## 6. Action Items

| Owner | Action | Target |
|--------|--------|--------|
| DevOps Engineer | Add automatic environment validation | 1 Week |
| Software Engineer | Improve rollback automation | 2 Weeks |
| QA Engineer | Add deployment verification tests | 2 Weeks |